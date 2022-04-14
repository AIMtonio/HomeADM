-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASTRANSFERMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASTRANSFERMOD`;
DELIMITER $$


CREATE PROCEDURE `CUENTASTRANSFERMOD`(
# =======================================================================
# ------- STORE PARA MODIFICAR CUENTAS DESTINO DE UN CLIENTE ---------
# =======================================================================
	Par_ClienteID		INT(11),		-- ID del Cliente
	Par_CuentaTranID	INT(11),     	-- ID de la Cuenta Destino
	Par_InstitucionID	INT(11),        -- ID de la Institucion
	Par_TipoCuentaSpei  INT(11),        -- Tipo de Cuenta Spei
	Par_Clabe			VARCHAR(20),    -- Numero de Cuenta Clabe

	Par_Beneficiario   	VARCHAR(100),   -- Nombre del Beneficiario
	Par_Alias			VARCHAR(30),	-- Alias del Beneficiario
	Par_TipoCuenta      CHAR(1),        -- Tipo de Cuenta
    Par_CuentaAhoIDCa   BIGINT(12), 	-- Cuenta de Ahorro Destino Interna
    Par_NumClienteCa    INT(11),        -- Numero de Cliente Destino Interna

	Par_Salida			CHAR(1),		-- Parametro Establece si requiere Salida
	INOUT Par_NumErr	INT(11),		-- Parametro INOUT para el Numero de Error
	INOUT Par_ErrMen	VARCHAR(400),	-- Parametro INOUT para la Descripcion del Error

	Par_EmpresaID		INT(11) ,		-- Parametro de Auditoria
	Aud_Usuario			INT(11) ,       -- Parametro de Auditoria
	Aud_FechaActual		DATETIME,       -- Parametro de Auditoria
	Aud_DireccionIP		VARCHAR(15),    -- Parametro de Auditoria
	Aud_ProgramaID		VARCHAR(50),    -- Parametro de Auditoria
	Aud_Sucursal		INT(11) ,       -- Parametro de Auditoria
	Aud_NumTransaccion	BIGINT(20)      -- Parametro de Auditoria
)

TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_EstatusCli		CHAR(1);			-- Estatus del cliente
	DECLARE Var_NumCtaTran		INT(11);			-- numero de cuenta destino
	DECLARE Var_ClienteID		INT(11);			-- ID cliente
	DECLARE Var_Clabe			VARCHAR(20);		-- clabe de la cuenta
    DECLARE Var_Consecutivo 	INT(12);			-- Variable Consecutivo
	DECLARE Var_Control			VARCHAR(50);		-- Variable de Control
	-- Declaracion de Constantes
	DECLARE Cadena_Vacia    CHAR(1);
	DECLARE Entero_Cero     INT;
	DECLARE Fecha_Vacia     DATE;
	DECLARE SalidaSI		CHAR(1);
	DECLARE SalidaNO		CHAR(1);
	DECLARE	Est_Registrado	CHAR(1);
	DECLARE Interna        	CHAR(1);
	DECLARE Externa       	CHAR(1);
	DECLARE Inactivo		CHAR(1);
    -- Asignacion de constantes
	SET Cadena_Vacia		:= '';
	SET Fecha_Vacia    		:= '1900-01-01';
	SET Entero_Cero        	:= 0;
	SET SalidaSI      		:= 'S';
	SET	SalidaNO			:= 'N';
	SET Est_Registrado		:= 'A';
	SET Interna			    := 'I';
	SET Externa			    := 'E';
	SET Inactivo			:= 'I';

	ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr 	:= 999;
			SET Par_ErrMen 	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-CUENTASTRANSFERMOD');
			SET Var_Control	:= 'SQLEXCEPTION';
		END;

		SELECT ClienteID, Estatus INTO Var_ClienteID, Var_EstatusCli
			FROM CLIENTES
			WHERE	ClienteID	= Par_ClienteID;

        SELECT CuentaTranID INTO Var_NumCtaTran
			FROM CUENTASTRANSFER
			WHERE	ClienteID	= Par_ClienteID
				AND CuentaTranID = Par_CuentaTranID;

		IF(IFNULL(Var_ClienteID,Entero_Cero) = Entero_Cero)THEN
			SET Par_NumErr 	:= 1;
			SET Par_ErrMen 	:= 'El Cliente No Existe.';
			SET Var_Control := 'clienteID';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_EstatusCli=Inactivo)THEN
			SET Par_NumErr	:= 2;
			SET Par_ErrMen 	:= 'La Cuenta Destino Pertenece a un Cliente Inactivo.';
			SET Var_Control := 'cuentaAhoIDCa';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Var_NumCtaTran,Entero_Cero) = Entero_Cero)THEN
			SET Par_NumErr 	:= 3;
			SET Par_ErrMen 	:= 'El Numero de Cuenta Destino No Existe.';
			SET Var_Control := 'clienteID';
			LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual := NOW();

        UPDATE CUENTASTRANSFER SET
            TipoCuentaSpei	=   Par_TipoCuentaSpei,
			InstitucionID	=  	Par_InstitucionID,
            Clabe			=	Par_Clabe,
            Beneficiario	=	Par_Beneficiario,
			Alias			=	Par_Alias,
            CuentaDestino   = 	Par_CuentaAhoIDCa,
			EmpresaID		= 	Par_EmpresaID,
            Usuario			= 	Aud_Usuario,
			FechaActual		= 	Aud_FechaActual,
            DireccionIP		=   Aud_DireccionIP,
            ProgramaID		=	Aud_ProgramaID,
            Sucursal		=	Aud_Sucursal,
            NumTransaccion	=   Aud_NumTransaccion
		WHERE ClienteID = Par_ClienteID
			AND CuentaTranID = Par_CuentaTranID;

		SET	Par_NumErr 		:= 0;
		SET	Par_ErrMen 		:= CONCAT('Cuenta Destino Modificada Exitosamente: ', CONVERT(Par_CuentaTranID, CHAR));
		SET Var_Control 	:= 'cuentaTranID';
		SET Var_Consecutivo := Par_CuentaTranID;

END ManejoErrores;

		IF(Par_Salida = SalidaSI)THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_Consecutivo AS Consecutivo;
		END IF;

END TerminaStore$$