-- Creacion del Proceso REVISIONREMESASPRO

DELIMITER ;

DROP PROCEDURE IF EXISTS `REVISIONREMESASPRO`;

DELIMITER $$

CREATE PROCEDURE `REVISIONREMESASPRO`(
-- =====================================================================================
-- ------------------------- STORED PARA LA REVISION DE REMESAS ------------------------
-- =====================================================================================
	Par_RemesaFolioID			VARCHAR(45),		-- Indica la Referencia de Pago.
    Par_ClienteID				INT(11),			-- Identificador del Cliente
	Par_UsuarioServicioID		INT(11),			-- Identificador del Usuario de Servicio
	Par_Monto					DECIMAL(14,2),		-- Almacena el Monto de la Remesa
	Par_FormaPago				CHAR(1),			-- Indica la clave para identificar la Forma de Pago: R = Retiro en efectivo, A = Abono a cuenta, S = SPEI,

    Par_PermiteOperacion		CHAR(1),			-- Indica Permite Operacion: S = SI, N = NO
	Par_Comentario				VARCHAR(1000),		-- Indica el Comentario de la Revision de la Remesa

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
	DECLARE Var_Control         	VARCHAR(100);   -- Variable de Control
    DECLARE Var_FechaSistema		DATE;			-- Fecha de sistema
    DECLARE Var_RemesaWSID			BIGINT(20);		-- Identificador de la remesa
	DECLARE Var_NumeroCuenta 		VARCHAR(18);	-- Almacena la cuenta CLABE del cliente o usuario
	DECLARE Var_NumParticipanteSPEI	BIGINT(20);		-- Almacena el numero que le asigno SPEI a la institucion para operar con SPEI valor esperado 90646

	DECLARE Var_ClienteID			INT(11);		-- Almacena el Numero de Cliente de la Remesa
    DECLARE Var_NombreCompleto		VARCHAR(200);	-- Almacena el Nombre Completo del Cliente
	DECLARE Var_CuentaClabeRemesa	VARCHAR(18);	-- Indica la cuenta CLABE de la remesadora
	DECLARE Var_TipoPersonaRemitente CHAR(1);		-- Indica el tipo de persona  Fisica(F) , Fisica con Actividad Empresarial(A) y Moral (M) para el remitente

	DECLARE Var_RfcRemitente		CHAR(13);		-- Indica RFC del remitente
	DECLARE Var_CurpRemitente		CHAR(18);		-- Curp del remitente
    DECLARE	Var_CuentaTranID		INT(11);		-- No consecutivo de cuentas transfer por cliente
	DECLARE Var_TipoCuentaSpei		INT(11); 		-- Tipo de Cuenta de Envio para SPEI
	DECLARE Var_InstitucionID		INT(11); 		-- Institucion de la cuenta externa

	DECLARE Var_PrimerNombre		VARCHAR(50); 	-- Primer Nombre
	DECLARE Var_RFC					CHAR(13);		-- Indica el RFC del cliente o usuario
	DECLARE Var_NumCuentaDigi		VARCHAR(18);	-- Variable para almacenar los primeros 10 digitos de la cuenta del cliente para verificar que pertenece a SOFIEXPRESS
	DECLARE Var_TipoPagoRem		   	INT(2);
	DECLARE Var_TipoCuentaOrd	   	INT(2);

	DECLARE Var_ClabeSpei		   	VARCHAR(20);
	DECLARE Var_IdService	   		INT(2);
	DECLARE Var_NombreCompletoRem	VARCHAR(200);
	DECLARE Var_FechaSinGuion		VARCHAR(7);		-- Variable para almacenar la fecha sin guiones
	DECLARE Var_ReferenciaNum		INT(7);			-- Variable para almacenar la referencia numerica del envio SPEI


    -- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);     	-- Cadena Vacia
	DECLARE Fecha_Vacia     	DATE;		   	-- Fecha Vacia
	DECLARE Entero_Cero     	INT(1);       	-- Entero Cero
	DECLARE Decimal_Cero		DECIMAL(14,2);	-- Decimal cero
	DECLARE Salida_SI       	CHAR(1);      	-- Parametro de salida SI

	DECLARE Salida_NO       	CHAR(1);      	-- Parametro de salida NO
	DECLARE Cons_SI       		CHAR(1);   		-- Constante:  SI
	DECLARE Cons_NO       		CHAR(1); 		-- Constante:  NO
	DECLARE Est_Nuevo			CHAR(1);		-- Estatus: Nuevo
    DECLARE Est_Revision		CHAR(1);		-- Estatus: En revision Oficial de Cumplimiento

    DECLARE Est_Pagado			CHAR(1);		-- Estatus: Pagado
    DECLARE Est_Rechazado		CHAR(1);		-- Estatus: Rechazado
    DECLARE FormaSPEI			CHAR(1);		-- Forma de Pago: SPEI
	DECLARE FormaAbonoCta		CHAR(1);		-- Forma de Pago: Abono a Cuenta
    DECLARE ValorNumClabeInicial	VARCHAR(18);	-- Numero de cuenta CLABE inicial del cliente o usuario, el numero inicial esperado para Abono a Cuenta es 6461802111

    DECLARE ValorNumPartSPEI	BIGINT(20);		-- Numero que le asigno SPEI a la institucion para operar con SPEI valor esperado 90646
	DECLARE Est_Pendiente		CHAR(1);		-- Estatus Pendiente
	DECLARE Tipo_Externa		CHAR(1);		-- Tipo Externa
	DECLARE Est_Autorizada		CHAR(1);		-- Estatus Autorizada
	DECLARE Persona_Moral		CHAR(1);		-- Tipo Persona: Moral

	DECLARE Entero_Uno      	INT(11);      	-- Entero Uno

    -- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia       	:= '';			-- Cadena Vacia
	SET Fecha_Vacia         := '1900-01-01';-- Fecha Vacia
	SET Entero_Cero         := 0;			-- Entero Cero
	SET Decimal_Cero		:= 0.0;			-- Decimal cero
	SET Salida_SI          	:= 'S';			-- Parametro de salida SI

	SET Salida_NO           := 'N';			-- Parametro de salida NO
	SET Cons_SI          	:= 'S';			-- Constante:  SI
	SET Cons_NO           	:= 'N';			-- Constante:  NO
	SET Est_Nuevo			:= 'N';			-- Estatus: Nuevo
    SET Est_Revision		:= 'R';			-- Estatus: En revision Oficial de Cumplimiento

    SET Est_Rechazado		:= 'C';			-- Estatus: Rechazado
    SET Est_Pagado			:= 'P';			-- Estatus: Pagado
    SET FormaSPEI			:= 'S';			-- Forma de Pago: SPEI
    SET FormaAbonoCta		:= 'A';			-- Forma de Pago: Abono a Cuenta
    SET ValorNumClabeInicial	:= '6461802111'; -- Numero de cuenta CLABE inicial del cliente o usuario, el numero inicial esperado para Abono a Cuenta es 6461802111

    SET ValorNumPartSPEI	:= 90646;		-- Numero que le asigno SPEI a la institucion para operar con SPEI valor esperado 90646
    SET Est_Pendiente		:= 'P';			-- Estatus Pendiente
    SET Tipo_Externa		:= 'E';			-- Tipo Externa
    SET Est_Autorizada		:= 'A';			-- Estatus Autorizada
    SET Persona_Moral		:= 'M';			-- Tipo Persona: Moral

	SET Entero_Uno          := 1;			-- Entero Uno

	ManejoErrores:BEGIN

         DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			GET DIAGNOSTICS condition 1
			@Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
			SET Par_NumErr = 999;
			SET Par_ErrMen = LEFT(CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
				 'esto le ocasiona. Ref: SP-REVISIONREMESASPRO','[',@Var_SQLState,'-' , @Var_SQLMessage,']'), 400);
			SET Var_Control = 'SQLEXCEPTION';
		END;

		SET Aud_FechaActual 	:= NOW();
        SET Var_FechaSistema 	:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

		-- SE OBTIENE INFORMACION DE LA REMESA
        SELECT 	RemesaWSID
		INTO 	Var_RemesaWSID
		FROM REMESASWS
		WHERE RemesaFolioID = Par_RemesaFolioID;

        IF(IFNULL(Par_RemesaFolioID,Cadena_Vacia) = Cadena_Vacia)THEN
        	SET Par_NumErr 		:= 001;
			SET Par_ErrMen 		:= 'La Referencia se encuentra Vacia.';
			SET Var_Control		:= 'remesaFolioID';
			LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Var_RemesaWSID,Entero_Cero) = Entero_Cero)THEN
        	SET Par_NumErr 		:= 002;
			SET Par_ErrMen 		:= 'La Referencia No Existe.';
			SET Var_Control		:= 'remesaFolioID';
			LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_FormaPago,Cadena_Vacia) = Cadena_Vacia)THEN
        	SET Par_NumErr 		:= 003;
			SET Par_ErrMen 		:= 'La Forma de Pago se encuentra Vacia.';
			SET Var_Control		:= 'formaPago';
			LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_PermiteOperacion,Cadena_Vacia) = Cadena_Vacia)THEN
        	SET Par_NumErr 		:= 004;
			SET Par_ErrMen 		:= 'Permite Operacion se encuentra Vacia.';
			SET Var_Control		:= 'permiteOperacion';
			LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_Comentario,Cadena_Vacia) = Cadena_Vacia)THEN
        	SET Par_NumErr 		:= 005;
			SET Par_ErrMen 		:= 'El Comentario se encuentra Vacia.';
			SET Var_Control		:= 'comentario';
			LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_Monto,Decimal_Cero) = Decimal_Cero)THEN
        	SET Par_NumErr 		:= 006;
			SET Par_ErrMen 		:= 'El Monto se encuentra Vacio.';
			SET Var_Control		:= 'monto';
			LEAVE ManejoErrores;
        END IF;

        -- SI NO PERMITE OPERACION
        IF(Par_PermiteOperacion = Cons_NO)THEN
			-- SE ACTUALIZA ESTATUS, PERMITE OPERACION Y EL COMENTARIO DE LA REMESA
			UPDATE REMESASWS
			SET Estatus			 = Est_Rechazado,
				PermiteOperacion = Par_PermiteOperacion,
				Comentarios = Par_Comentario
			WHERE RemesaWSID = Var_RemesaWSID;
		END IF;

        -- SI PERMITE OPERACION
        IF(Par_PermiteOperacion = Cons_SI)THEN
			-- SE ACTUALIZA ESTATUS, PERMITE OPERACION Y EL COMENTARIO DE LA REMESA
			UPDATE REMESASWS
			SET Estatus			 = Est_Nuevo,
				PermiteOperacion = Par_PermiteOperacion,
				Comentarios = Par_Comentario
			WHERE RemesaWSID = Var_RemesaWSID;

            -- SI LA FORMA DE PAGO ES POR SPEI
            IF(Par_FormaPago = FormaSPEI)THEN

				SELECT 	CuentaClabeRemesa,		TipoPersonaRemitente,		RfcRemitente,		CurpRemitente,		NumeroCuenta,
						TipoCuentaSpei,			InstitucionID,				NombreCompleto,		PrimerNombre,		RFC,
						NombreCompletoRemit
				INTO 	Var_CuentaClabeRemesa,	Var_TipoPersonaRemitente,	Var_RfcRemitente,	Var_CurpRemitente,	Var_NumeroCuenta,
						Var_TipoCuentaSpei,		Var_InstitucionID,			Var_NombreCompleto,	Var_PrimerNombre,	Var_RFC,
						Var_NombreCompletoRem
				FROM REMESASWS
				WHERE RemesaWSID = Var_RemesaWSID;

				SELECT SUBSTRING(DATE_FORMAT(FechaSistema, '%y%m%d'), 1, 7)
				INTO Var_FechaSinGuion
				FROM PARAMETROSSIS
				LIMIT 1;

				SET Var_FechaSinGuion := IFNULL(Var_FechaSinGuion, Cadena_Vacia);
				SET Var_ReferenciaNum := CAST(Var_FechaSinGuion AS UNSIGNED);

				-- ALTA DE DESCARGA DE REMESAS
				CALL SPEIDESCARGASREMALT (
					Entero_Cero,						Cadena_Vacia,		1,					Var_TipoCuentaSpei,		Var_CuentaClabeRemesa,
					SUBSTR(Var_NombreCompletoRem,1,40),	Var_RfcRemitente,	4,					Par_Monto,				Entero_Cero,
					Entero_Cero,						Entero_Cero,		ValorNumPartSPEI,	Var_InstitucionID,		Var_NumeroCuenta,
					Var_NombreCompleto,					Var_RFC,			Var_TipoCuentaSpei,	'REMESASWS',			Cadena_Vacia,
					Cadena_Vacia,						Cadena_Vacia,		Entero_Cero,		Cadena_Vacia,			Cadena_Vacia,
					Var_ReferenciaNum,					Entero_Cero,		Entero_Uno,			Cadena_Vacia,			8,
					NOW(),								Entero_Cero,		Cadena_Vacia,		Entero_Cero,			Entero_Cero,
					Entero_Cero,						Cadena_Vacia,		Var_RemesaWSID,		Salida_NO,				Par_NumErr,
					Par_ErrMen,							Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
					Aud_ProgramaID,						Aud_Sucursal,		Aud_NumTransaccion
				);

				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

	            -- VALIDACIONES CUENTAS CLABE
	            SET Var_ClienteID := (SELECT CTA.ClienteID FROM CUENTASTRANSFER CTA
											INNER JOIN CLIENTES CTE
												ON CTA.ClienteID = CTE.ClienteID
										WHERE CTA.TipoCuenta = Tipo_Externa
											AND CTA.Clabe = Var_CuentaClabeRemesa
	                                        AND IF(Var_TipoPersonaRemitente = Persona_Moral,
													CTE.RFCOficial = Var_RfcRemitente,
	                                                CTE.CURP = Var_CurpRemitente)
										LIMIT 1);

	            IF(IFNULL(Var_ClienteID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr	:= 1;
					SET Par_ErrMen	:= 'La Cuenta Clabe no esta Registrada a la Remesadora';
					LEAVE ManejoErrores;
	            END IF;

	            SET Var_CuentaTranID := (SELECT CTA.CuentaTranID FROM CUENTASTRANSFER CTA
											INNER JOIN CLIENTES CTE
												ON CTA.ClienteID = CTE.ClienteID
										WHERE CTA.ClienteID = Var_ClienteID
											AND CTA.TipoCuenta = Tipo_Externa
											AND CTA.Clabe = Var_NumeroCuenta
	                                        AND CTA.TipoCuentaSpei = Var_TipoCuentaSpei
	                                        AND CTA.Estatus = Est_Autorizada
										LIMIT 1);

	            -- SI NO EXISTE LA CUENTA DEL BENEFICIARIO RELACIONADA ALA REMESADORA COMO CUENTA EXTERNA SE DA DE ALTA
	            IF(IFNULL(Var_CuentaTranID, Entero_Cero) = Entero_Cero)THEN
					CALL CUENTASTRANSFERALT(
						Var_ClienteID, 					Entero_Cero,		Var_InstitucionID,		Var_NumeroCuenta,	Var_NombreCompleto,
						CONCAT(Var_PrimerNombre,'-REMESASWS'),Var_FechaSistema,	Tipo_Externa,		Entero_Cero,		Entero_Cero,
						Entero_Cero,					Entero_Cero,		Var_TipoCuentaSpei,		Var_RFC,			Cons_NO,
						Cons_SI,						Entero_Cero,
	                    Salida_NO, 						Par_NumErr, 		Par_ErrMen, 			Par_EmpresaID, 		Aud_Usuario,
						Aud_FechaActual, 				Aud_DireccionIP,	Aud_ProgramaID, 		Aud_Sucursal, 		Aud_NumTransaccion
					);

					IF(Par_NumErr <> Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;
	            END IF;
            END IF; -- FIN SI LA FORMA DE PAGO ES POR SPEI

             -- SI LA FORMA DE PAGO ES ABONO A CUENTA
			IF(Par_FormaPago = FormaAbonoCta)THEN

				SELECT ClienteID,	NombreCompleto
				INTO Var_ClienteID, Var_NombreCompleto
				FROM CLIENTES
				WHERE ClienteID = Par_ClienteID;

				SET Var_ClienteID		:= (IFNULL(Var_ClienteID,Entero_Cero));
				SET Var_NombreCompleto	:= (IFNULL(Var_NombreCompleto,Cadena_Vacia));

                IF(IFNULL(Par_ClienteID,Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 008;
					SET Par_ErrMen 		:= 'La Forma de Pago Abono a Cuenta solo aplica para Clientes.';
					SET Var_Control		:= 'clienteID';
					LEAVE ManejoErrores;
				END IF;

				IF(Var_ClienteID = Entero_Cero)THEN
					SET Par_NumErr 		:= 009;
					SET Par_ErrMen 		:= CONCAT('El Cliente ',Par_ClienteID,' No Existe.');
					SET Var_Control		:= 'clienteID';
					LEAVE ManejoErrores;
				END IF;

                SELECT NumeroCuenta,		NumParticipanteSPEI
                INTO   Var_NumeroCuenta,	Var_NumParticipanteSPEI
                FROM REMESASWS
                WHERE RemesaWSID = Var_RemesaWSID;

                SET Var_NumeroCuenta 		:= IFNULL(Var_NumeroCuenta,Cadena_Vacia);
				SET Var_NumParticipanteSPEI := IFNULL(Var_NumParticipanteSPEI,Entero_Cero);

				-- SE OBTIENEN LOS PRIMEROS 10 DIGITOS DEL NUMERO DE CUENTA CLABE
                SET Var_NumCuentaDigi := (SELECT LEFT(Var_NumeroCuenta,10));

                -- SE VALIDA EL NUMERO DE CUENTA CLABE INICIAL Y EL NUMERO DE PARTICIPANTE SPEI
                IF(Var_NumCuentaDigi != ValorNumClabeInicial AND Var_NumParticipanteSPEI != ValorNumPartSPEI)THEN
					UPDATE REMESASWS
					SET Estatus			= Est_Rechazado,
						Comentarios =  CONCAT(CASE WHEN IFNULL(Comentarios, Cadena_Vacia) = Cadena_Vacia
													THEN Cadena_Vacia
												  ELSE ' '
											  END,
										'---- RECHAZO DE LA REMESA POR ABONO A CUENTA POR DATOS DE LA CUENTA INCORRECTOS ---- \n',
                                        ' NUMERO CUENTA CLABE ',Var_NumeroCuenta,' NUMERO PARTICIPANTE SPEI ',Var_NumParticipanteSPEI,'\n\n')
					WHERE RemesaWSID = Var_RemesaWSID;
				END IF;

                -- SI EL NUMERO DE CUENTA CLABE INICIAL Y EL NUMERO DE PARTICIPANTE SPEI SON CORRECTOS
                IF(Var_NumCuentaDigi = ValorNumClabeInicial AND Var_NumParticipanteSPEI = ValorNumPartSPEI)THEN
					-- SE REALIZA LLAMADA AL PROCESO SPEITRANSFERENCIASALT PARA EL REGISTRO EN LA TABLA SPEITRANSFERENCIAS
					CALL SPEITRANSFERENCIASALT(
						Entero_Cero,		Var_NombreCompleto,	Var_NumeroCuenta,	Var_Monto,			Par_RemesaFolioID,
						Salida_NO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
						Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;
                END IF;
            END IF; -- FIN SI LA FORMA DE PAGO ES ABONO A CUENTA
		END IF;-- FIN SI PERMITE OPERACION


		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= CONCAT('Revision de Remesa Grabada Exitosamente: ',CAST(Par_RemesaFolioID AS CHAR) );
		SET Var_Control		:= 'remesaFolioID';

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) then
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Par_RemesaFolioID AS consecutivo;

	END IF;

END TerminaStore$$