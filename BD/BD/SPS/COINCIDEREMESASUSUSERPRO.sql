-- Creacion del Proceso COINCIDEREMESASUSUSERPRO

DELIMITER ;

DROP PROCEDURE IF EXISTS `COINCIDEREMESASUSUSERPRO`;

DELIMITER $$

CREATE PROCEDURE `COINCIDEREMESASUSUSERPRO`(
-- ===================================================================================
-- ----- STORED DE DETECCION DE COINCIDENCIAS DE REMESAS DE USUARIOS DE SERVICIOS -----
-- ===================================================================================
	Par_UsuarioServicioID		INT(11),			-- Numero del Usuario de Servicio
    Par_TipoPersona				CHAR(1),			-- Indica el Tipo de Persona:  Fisica(F) , Fisica con Actividad Empresarial(A) y Moral (M) del usuario
    Par_CURP					CHAR(18),			-- Indica la clave CURP del usuario
	Par_RFC						CHAR(13),			-- Indica el RFC del usuario

    Par_Salida    				CHAR(1),			-- Parametro de salida S= si, N= no
    INOUT Par_NumErr 			INT(11),			-- Parametro de salida numero de error
    INOUT Par_ErrMen  			VARCHAR(400),		-- Parametro de salida mensaje de error

    Par_EmpresaID       		INT(11),			-- Parametro de auditoria ID de la empresa
    Aud_Usuario         		INT(11),			-- Parametro de auditoria ID del usuario
    Aud_FechaActual     		DATETIME,			-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     		VARCHAR(15),		-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      		VARCHAR(50),		-- Parametro de auditoria Programa
    Aud_Sucursal        		INT(11),			-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  		BIGINT(20)  		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
    DECLARE Var_Consecutivo			VARCHAR(100);   	-- Variable consecutivo
	DECLARE Var_Control         	VARCHAR(100);   	-- Variable de Control
    DECLARE Var_PorcCoincideRemesas	INT(11);			-- Almacena el valor del parametro del % de Coincidencia de Remesas
	DECLARE Var_ConsecutivoID		INT(11);   			-- Variable consecutivo
    DECLARE Var_NumRegistros		INT(11);			-- Almacena el Numero de Registros

    DECLARE Var_Contador			INT(11);			-- Contador
	DECLARE Var_NombreCompleto		VARCHAR(200);		-- Almacena el nombre completo del usuario
    DECLARE Var_UsuarioServCoinID   INT(11);         	-- Identificador del Usuario de Servicio a buscar la Coincidencia
	DECLARE Var_RFCCoin             CHAR(13);			-- Registro Federal de Contribuyente del Usuario a buscar la Coincidencia
    DECLARE Var_CURPCoin            CHAR(18);        	-- Clave Unica de Registro de Poblacion del Usuario de Servicio a buscar la Coincidencia

    DECLARE	Var_NombreCompletoCoin	VARCHAR(200);		-- Nombre Completo del del Usuario de Servicio a buscar la Coincidencia
	DECLARE Var_PorcConcidencia		DECIMAL(14,2);		-- Porcentaje de Coincidencia

    -- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante Cadena Vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha Vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero Cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- Decimal Cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de Salida SI

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de Salida NO
	DECLARE Cons_SI       		CHAR(1);   			-- Constante  S, valor si
	DECLARE Cons_NO       		CHAR(1); 			-- Constante  N, valor no
    DECLARE PersonaFisica		CHAR(1);			-- Tipo Persona: FISICA
    DECLARE PersonaFisicaActEmp	CHAR(1); 			-- Tipo Persona: FISICA CON ACTIVIDAD EMPRESARIAL

    DECLARE PersonaMoral		CHAR(1);			-- Tipo Persona: MORAL
    DECLARE PorcCoincideRemesas	VARCHAR(200);		-- Llave Parametro  % de Coincidencia de Remesas
    DECLARE TipoCoincideCURP	CHAR(4);			-- Tipo de Coincidencia: CURP
	DECLARE TipoCoincideRFC		CHAR(4);			-- Tipo de Coincidencia: RFC


    -- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Cons_SI          		:= 'S';
	SET Cons_NO           		:= 'N';
    SET PersonaFisica			:= 'F';
    SET PersonaFisicaActEmp		:= 'A';

    SET PersonaMoral			:= 'M';
    SET PorcCoincideRemesas		:= '%CoincidenciaRemesas';
    SET TipoCoincideCURP		:= 'CURP';
	SET TipoCoincideRFC			:= 'RFC';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			GET DIAGNOSTICS condition 1
			@Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
			SET Par_NumErr = 999;
			SET Par_ErrMen = LEFT(CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
				 'esto le ocasiona. Ref: SP-COINCIDEREMESASUSUSERPRO','[',@Var_SQLState,'-' , @Var_SQLMessage,']'), 400);
			SET Var_Control = 'SQLEXCEPTION';
		END;

        -- SE OBTIENE EL PORCENTAJE PARAMETRIZADO DE COINCIDENCIAS DE REMESAS DE RFC O CURPR PARA USUARIOS DE SERVICIO
        SET Var_PorcCoincideRemesas := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = PorcCoincideRemesas);
        SET Var_PorcCoincideRemesas	:= IFNULL(Var_PorcCoincideRemesas,Entero_Cero);

        -- SE OBTIENE INFORMACION DEL USUARIO DE SERVICIO
        SELECT NombreCompleto
        INTO Var_NombreCompleto
        FROM USUARIOSERVICIO
        WHERE UsuarioServicioID = Par_UsuarioServicioID;

        -- SI EL PORCENTAJE PARAMETRIZADO DE COINCIDENCIAS DE REMESAS ES MAYOR A CERO
		IF(Var_PorcCoincideRemesas > Entero_Cero)THEN
			-- SE ELIMINA LA TABLA TEMPORAL
			DELETE FROM TMPCOINCREMESASUSUSER;
			SET @Var_ConsecutivoID := 0;

			-- SE OBTIENE INFORMACION DE LOS USUARIOS DE SERVICIOS PARA BUSCAR COINCIDENCIAS DE RFC O CURP
			INSERT INTO TMPCOINCREMESASUSUSER(
				ConsecutivoID,		UsuarioServCoinID,		RFCCoin,		CURPCoin,			NombreCompletoCoin,			EmpresaID,
                Usuario,			FechaActual,			DireccionIP,	ProgramaID,			Sucursal,					NumTransaccion)
			SELECT
				@Var_ConsecutivoID:=@Var_ConsecutivoID+1,	UsuarioServicioID,		IFNULL(RFCOficial,Cadena_Vacia),IFNULL(CURP,Cadena_Vacia),IFNULL(NombreCompleto,Cadena_Vacia),
				Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
                Aud_Sucursal,		Aud_NumTransaccion
			FROM USUARIOSERVICIO
			WHERE UsuarioServicioID != Par_UsuarioServicioID
			AND UsuarioUnificadoID = Entero_Cero;

			-- SE OBTIENE EL NUMERO DE REGISTROS
			SET Var_NumRegistros := (SELECT COUNT(UsuarioServCoinID) FROM TMPCOINCREMESASUSUSER);
			SET Var_NumRegistros := IFNULL(Var_NumRegistros,Entero_Cero);

			-- SE VALIDA QUE EL NUMERO DE REGISTROS SEA MAYOR A CERO
			IF(Var_NumRegistros > Entero_Cero)THEN
				-- SE INICIALIZA EL CONTADOR
				SET Var_Contador := 1;

				-- SE REALIZA LA DETECCION DE COINCIDENCIAS DE REMESAS DE USUARIOS DE SERVICIOS
				WHILE(Var_Contador <= Var_NumRegistros) DO
					SELECT	UsuarioServCoinID,			RFCCoin,			CURPCoin,			NombreCompletoCoin
					INTO 	Var_UsuarioServCoinID,		Var_RFCCoin,		Var_CURPCoin,		Var_NombreCompletoCoin
					FROM TMPCOINCREMESASUSUSER
					WHERE ConsecutivoID = Var_Contador;

					-- SI EL TIPO DE PERSONA ES FISICA O FISICA CON ACTIVIDAD EMPRESARIAL LA COINCIDENCIA SE REALIZA POR LA CURP
					IF(Par_TipoPersona IN(PersonaFisica,PersonaFisicaActEmp))THEN
                        IF(Var_CURPCoin != Cadena_Vacia)THEN
							-- SE OBTIENE EL PORCENTAJE DE COINCIDENCIA POR LA CURP
							SET Var_PorcConcidencia := (SELECT FNPORCENTAJEDIFF(Par_CURP,Var_CURPCoin));
							-- SI EL PORCENTAJE DE COINCIDENCIA ES MAYOR O IGUAL AL PORCENTAJE PARAMETRIZADO DE COINCIDENCIAS DE REMESAS
							IF(Var_PorcConcidencia >= Var_PorcCoincideRemesas)THEN
								-- SE REALIZA LA LLAMADA AL PROCESO COINCIDEREMESASUSUSERALT PARA EL REGISTRO DE COINCIDENCIAS DE REMESAS DE USUARIOS DE SERVICIOS
								CALL COINCIDEREMESASUSUSERALT(
									Par_UsuarioServicioID,	Cadena_Vacia,		Par_CURP,			Var_NombreCompleto,		TipoCoincideCURP,
                                    Var_UsuarioServCoinID,	Cadena_Vacia,		Var_CURPCoin,		Var_NombreCompletoCoin,	Var_PorcConcidencia,
                                    Salida_NO,				Par_NumErr,			Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,
                                    Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

                                 IF(Par_NumErr != Entero_Cero)THEN
									LEAVE ManejoErrores;
								END IF;
							END IF;
						END IF;
					END IF;

					-- SI EL TIPO DE PERSONA ES MORAL LA COINCIDENCIA SE REALIZA POR EL RFC
					IF(Par_TipoPersona = PersonaMoral)THEN
                        IF(Var_RFCCoin != Cadena_Vacia)THEN
							-- SE OBTIENE EL PORCENTAJE DE COINCIDENCIA POR EL RFC
							SET Var_PorcConcidencia := (SELECT FNPORCENTAJEDIFF(Par_RFC,Var_RFCCoin));
							-- SI EL PORCENTAJE DE COINCIDENCIA ES MAYOR O IGUAL AL PORCENTAJE PARAMETRIZADO DE COINCIDENCIAS DE REMESAS
							IF(Var_PorcConcidencia >= Var_PorcCoincideRemesas)THEN
								-- SE REALIZA LA LLAMADA AL PROCESO COINCIDEREMESASUSUSERALT PARA EL REGISTRO DE COINCIDENCIAS DE REMESAS DE USUARIOS DE SERVICIOS
								CALL COINCIDEREMESASUSUSERALT(
									Par_UsuarioServicioID,	Par_RFC,			Cadena_Vacia,		Var_NombreCompleto,		TipoCoincideRFC,
                                    Var_UsuarioServCoinID,	Var_RFCCoin,		Cadena_Vacia,		Var_NombreCompletoCoin,	Var_PorcConcidencia,
                                    Salida_NO,				Par_NumErr,			Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,
                                    Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

                                 IF(Par_NumErr != Entero_Cero)THEN
									LEAVE ManejoErrores;
								END IF;
							END IF;
						END IF;
					END IF;

					SET Var_Contador := Var_Contador + 1;

				END WHILE; -- FIN DEL WHILE
			END IF; -- FIN SE VALIDA QUE EL NUMERO DE REGISTROS SEA MAYOR A CERO
		END IF; -- FIN SI EL PORCENTAJE PARAMETRIZADO DE COINCIDENCIAS DE REMESAS ES MAYOR A CERO

		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= 'Deteccion de Coincidencias de Remesas de Usuarios de Servicios Procesado Exitosamente.';
		SET Var_Control		:= Cadena_Vacia;
		SET Var_Consecutivo	:= Par_UsuarioServicioID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) then
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;

	END IF;

END TerminaStore$$