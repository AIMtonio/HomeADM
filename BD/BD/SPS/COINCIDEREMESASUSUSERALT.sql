-- Creacion del Proceso COINCIDEREMESASUSUSERALT

DELIMITER ;

DROP PROCEDURE IF EXISTS `COINCIDEREMESASUSUSERALT`;

DELIMITER $$

CREATE PROCEDURE `COINCIDEREMESASUSUSERALT`(
-- ===================================================================================
-- ------ STORED DE REGISTRO DE COINCIDENCIAS DE REMESAS DE USUARIOS DE SERVICIOS ------
-- ===================================================================================
	Par_UsuarioServicioID		INT(11),        	-- Identificador del Usuario de Servicio que busca Coincidencia
	Par_RFC						CHAR(13),       	-- Registro Federal de Contribuyente del Usuario de Servicio que busca Coincidencia
	Par_CURP					CHAR(18),			-- Clave Unica de Registro de Poblacion del Usuario de Servicio que busca Coincidencia
	Par_NombreCompleto			VARCHAR(200),   	-- Nombre Completo del del Usuario de Servicio que busca Coincidencia
	Par_TipoCoincidencia		CHAR(4),       	 	-- TipoConcidencia: RFC (Para Tipo de Persona Moral), CURP (Para Tipo de Persona Fisica o Fisica con Actividad Empresarial)

    Par_UsuarioServCoinID		INT(11),        	-- Identificador del Usuario de Servicio con el que hizo Coincidencia
	Par_RFCCoin					CHAR(13),       	-- Registro Federal de Contribuyente del Usuario con el que hizo Coincidencia
	Par_CURPCoin				CHAR(18),       	-- Clave Unica de Registro de Poblacion del Usuario de Servicio con el que hizo Coincidencia
	Par_NombreCompletoCoin		VARCHAR(200),  	 	-- Nombre Completo del del Usuario de Servicio con el que hizo Coincidencia
	Par_PorcConcidencia			DECIMAL(14,2),		-- Porcentaje de Coincidencia

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
    DECLARE Var_FechaSistema		DATE;				-- Fecha de sistema
    DECLARE Var_CoincideRemesaID	BIGINT(20);      	-- Numero consecutido de la tabla COINCIDEREMESASUSUSER

    -- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante Cadena Vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha Vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero Cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- Decimal Cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de Salida SI

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de Salida NO
	DECLARE Cons_SI       		CHAR(1);   			-- Constante  S, valor si
	DECLARE Cons_NO       		CHAR(1); 			-- Constante  N, valor no

    -- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Cons_SI          		:= 'S';
	SET Cons_NO           		:= 'N';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			GET DIAGNOSTICS condition 1
			@Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
			SET Par_NumErr = 999;
			SET Par_ErrMen = LEFT(CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
				 'esto le ocasiona. Ref: SP-COINCIDEREMESASUSUSERALT','[',@Var_SQLState,'-' , @Var_SQLMessage,']'), 400);
			SET Var_Control = 'SQLEXCEPTION';
		END;

		-- SE OBTIENE LA FECHA DEL SISTEMA
		SET Var_FechaSistema	:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

		-- SE OBTIENE EL NUMERO CONSECUTIVO DE LA COINCIDENCIA DE REMESAS DE USUARIO SERVICIO
		SET Var_CoincideRemesaID := (SELECT IFNULL(MAX(CoincideRemesaID),Entero_Cero) + 1 FROM COINCIDEREMESASUSUSER);

		-- SE OBTIENE LA FECHA ACTUAL
        SET Aud_FechaActual  := NOW();

		-- SE REGISTRA LA INFORMACION EN LA TABLA COINCIDEREMESASUSUSER
		INSERT INTO COINCIDEREMESASUSUSER(
			CoincideRemesaID, 		Fecha,					TipoCoincidencia,		UsuarioServicioID,		RFC,
            CURP,					NombreCompleto,			UsuarioServCoinID,		RFCCoin,				CURPCoin,
            NombreCompletoCoin,		PorcConcidencia,		Unificado,				EmpresaID,				Usuario,
            FechaActual,			DireccionIP, 			ProgramaID, 			Sucursal, 				NumTransaccion)
		VALUES(
			Var_CoincideRemesaID, 	Var_FechaSistema,		Par_TipoCoincidencia,	Par_UsuarioServicioID,	Par_RFC,
            Par_CURP,				Par_NombreCompleto,		Par_UsuarioServCoinID,	Par_RFCCoin,			Par_CURPCoin,
            Par_NombreCompletoCoin,	Par_PorcConcidencia,	Cons_NO,				Par_EmpresaID,			Aud_Usuario,
            Aud_FechaActual,    	Aud_DireccionIP,		Aud_ProgramaID, 		Aud_Sucursal,			Aud_NumTransaccion);

		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= 'Registro de Coincidencias de Remesas de Usuarios de Servicios realizado Exitosamente.';
		SET Var_Control		:= Cadena_Vacia;
		SET Var_Consecutivo	:= Var_CoincideRemesaID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) then
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;

	END IF;

END TerminaStore$$