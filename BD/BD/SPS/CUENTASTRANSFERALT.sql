

-- CUENTASTRANSFERALT --

DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASTRANSFERALT`;
-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE `CUENTASTRANSFERALT`(
# =======================================================================
# ------- STORE PARA DAR DE ALTA CUENTAS DESTINO DE UN CLIENTE ---------
# =======================================================================
	Par_ClienteID		INT(11),		-- ID del Cliente
	Par_CuentaTranID	BIGINT(12),     -- ID de la Cuenta Destino
	Par_InstitucionID	INT(11),        -- ID de la Institucion
	Par_Clabe			VARCHAR(20),    -- Numero de Cuenta Clabe
	Par_Beneficiario   	VARCHAR(100),   -- Nombre del Beneficiario

	Par_Alias			VARCHAR(30),	-- Alias del Beneficiario
	Par_FechaRegistro	DATE,           -- Fecha de Registro
    Par_TipoCuenta      CHAR(1),        -- Tipo de Cuenta
    Par_CuentaDestino   BIGINT(12),     -- Numero de Cuenta Destino
    Par_ClienteDestino  INT(11),        -- Cliente Destino

    Par_CuentaAhoIDCa   BIGINT(12), 	-- Cuenta de Ahorro Destino
    Par_NumClienteCa    INT(11),        -- Numero de Cuenta Destino
    Par_TipoCuentaSpei  INT(2),         -- Tipo de Cuenta Spei
    Par_RFCBeneficiario VARCHAR(18),    -- RFC del Beneficiario
    Par_EsPrincipal		CHAR(1),		-- Indica si la Cuenta Destino es Principal.
    Par_AplicaPara		CHAR(1),		-- Aplica para cuenta,credito o ambas
    Par_MontoLimite		DECIMAL(14,2),

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
	DECLARE Var_EstatusCli		CHAR(1);
	DECLARE Var_NumCtaTran		INT(11);
	DECLARE Var_ClienteID		INT(11);
	DECLARE Var_Clabe			VARCHAR(20);
    DECLARE Var_Consecutivo 	INT(12);			-- Variable Consecutivo
	DECLARE Var_Control			VARCHAR(50);		-- Variable de Control
    DECLARE Var_EstatusDomicilio CHAR(1);			-- variable para el estatus de la clabe
    DECLARE Var_CuentaTranID	INT(11);			-- Consecutivo para cuenta transfer de un cliente

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
    DECLARE Aplica_Cuenta	CHAR(1);
	DECLARE No_Afiliada		CHAR(1);
	DECLARE Cons_SI			CHAR(1);
	DECLARE Cons_NO			CHAR(1);
	DECLARE Est_Bloqueado	CHAR(1);

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
    SET Aplica_Cuenta		:= 'S';
	SET No_Afiliada			:= 'N';
	SET Cons_SI				:= 'S';
	SET	Cons_NO				:= 'N';
	SET Est_Bloqueado		:= 'B';

	ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr 	:= 999;
			SET Par_ErrMen 	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-CUENTASTRANSFERALT');
			SET Var_Control	:= 'SQLEXCEPTION';
		END;

		SELECT ClienteID INTO Var_ClienteID
			FROM CLIENTES
			WHERE	ClienteID	= Par_ClienteID;

		IF(IFNULL(Var_ClienteID,Entero_Cero) = Entero_Cero)THEN
			SET Par_NumErr 	:= 1;
			SET Par_ErrMen 	:= 'El numero de Cliente indicado no Existe.';
			SET Var_Control := 'clienteID';
			LEAVE ManejoErrores;
		END IF;

		SELECT	Cli.Estatus INTO Var_EstatusCli
			FROM CLIENTES Cli
			INNER JOIN CUENTASAHO Cue ON Cue.ClienteID = Cli.ClienteID
			WHERE	Cue.CuentaAhoID	= Par_CuentaAhoIDCa;

		IF(Var_EstatusCli=Inactivo)THEN
			SET Par_NumErr	:= 2;
			SET Par_ErrMen 	:= 'La Cuenta Destino Pertenece a un Cliente Inactivo.';
			SET Var_Control := 'cuentaAhoIDCa';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_TipoCuenta=Externa)THEN
			IF EXISTS(SELECT Clabe
						FROM CUENTASTRANSFER
						WHERE InstitucionID = Par_InstitucionID
						  AND Clabe = Par_Clabe
						  AND ClienteID = Par_ClienteID
						  AND Estatus = Est_Registrado )THEN
				SET Par_NumErr 	:= 3;
				SET Par_ErrMen 	:= 'La Cuenta Clabe ya se Encuentra Registrada para la Institucion Especificada.';
				SET Var_Control := 'clienteID';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_EsPrincipal,Cons_NO) = Cons_SI)THEN
				IF EXISTS(SELECT * FROM CUENTASTRANSFER
							WHERE ClienteID = Par_ClienteID
								AND Estatus = Est_Registrado
								AND EsPrincipal = Cons_SI
								AND CuentaTranID != Par_CuentaTranID)THEN
					SET Par_NumErr 	:= 6;
					SET Par_ErrMen 	:= CONCAT('Ya Existe una Cuenta Destino Principal Externa.');
					SET Var_Control := 'esPrincipal';
					LEAVE ManejoErrores;
				END IF;
			END IF;

            SET Var_ClienteID := Entero_Cero;

            IF(IFNULL(Par_Clabe, Cadena_Vacia) != Cadena_Vacia) THEN
				SELECT		MAX(ClienteID),		MAX(CuentaTranID)
					INTO	Var_ClienteID,	Var_CuentaTranID
					FROM	CUENTASTRANSFER
					WHERE	Clabe = Par_Clabe
							AND TipoCuenta = Externa
							AND Estatus != Est_Bloqueado
							AND ClienteID = Par_ClienteID;

				SET Var_CuentaTranID	:= IFNULL(Var_CuentaTranID, Entero_Cero);

	            IF(IFNULL(Var_ClienteID,Entero_Cero)!=Entero_Cero)THEN
					SET Par_NumErr := 7;
					SET Par_ErrMen := CONCAT('La Cuenta Clabe ya se encuentra registrada en la Cuenta Destino ', Var_CuentaTranID,
											' del Cliente ', Var_ClienteID, '.');
					SET Var_Control := "clabe";
					LEAVE ManejoErrores;
				END IF;

	            SET Par_AplicaPara := IFNULL(Par_AplicaPara,Cadena_Vacia);

				IF(Par_AplicaPara = Cadena_Vacia ) THEN
					SET Par_NumErr := 8;
					SET Par_ErrMen := CONCAT('Especifique al menos una opci&oacute;n.');
					SET Var_Control := "aplicaPara";
					LEAVE ManejoErrores;
				END IF;
			END IF;

		END IF;

		IF(Par_TipoCuenta =Interna) THEN
			SET Par_EsPrincipal := Cons_NO;
			IF (SELECT COUNT(CuentaDestino)
						FROM CUENTASTRANSFER
						WHERE CuentaDestino=Par_CuentaAhoIDCa
						  AND ClienteID = Par_ClienteID
						  AND Estatus = Est_Registrado) > Entero_Cero THEN
				SET Par_NumErr 	:= 4;
				SET Par_ErrMen 	:= 'La Cuenta Destino ya se encuentra Registrada.';
				SET Var_Control := 'clienteID';
				LEAVE ManejoErrores;
			END IF;
		END IF;

        /*Validacion que evita que se relacionen cuentas
        si el cliente no corresponde con la cuenta*/
        IF(Par_CuentaAhoIDCa <> Entero_Cero)THEN
			IF (SELECT ClienteID
				FROM CUENTASAHO
				WHERE CuentaAhoID = Par_CuentaAhoIDCa) <> Par_NumClienteCa THEN
						SET Par_NumErr:=5 ;
						SET Par_ErrMen:= "El Cliente Destino no esta asociado a la Cuenta.";
						SET Var_Control:='cuentaAhoIDCa';

                        LEAVE ManejoErrores;
			END IF;
		END IF;
		IF (Par_AplicaPara <> Aplica_Cuenta) THEN
			SET Var_EstatusDomicilio = No_Afiliada;
		ELSE
			SET Var_EstatusDomicilio = Cadena_Vacia;
		END IF;

		SET Aud_FechaActual  := NOW();
        SET Par_Beneficiario := UPPER(Par_Beneficiario);
        SET Par_Alias		 := UPPER(Par_Alias);
		SET Var_NumCtaTran	 := (SELECT MAX(CuentaTranID) FROM CUENTASTRANSFER WHERE ClienteID = Par_ClienteID);
		SET Var_NumCtaTran	 := IFNULL(Var_NumCtaTran, Entero_Cero) + 1;

		IF(IFNULL(Par_CuentaDestino,Entero_Cero) = Entero_Cero)THEN
			SET Par_ClienteDestino := Entero_Cero;
		END IF;

		IF(IFNULL(Par_Clabe,Entero_Cero)=Entero_Cero)THEN
			SET Par_InstitucionID 	:= IFNULL(Par_InstitucionID, Entero_Cero);
			SET Par_Beneficiario 	:= IFNULL(Par_Beneficiario, Cadena_Vacia);
			SET Par_Alias 			:= IFNULL(Par_Alias, Cadena_Vacia);
			SET Par_CuentaDestino 	:= Par_CuentaAhoIDCa;
			SET Par_ClienteDestino 	:= Par_NumClienteCa;
			SET Par_TipoCuentaSpei 	:= IFNULL(Par_TipoCuentaSpei,Entero_Cero);
			SET Par_RFCBeneficiario := IFNULL(Par_RFCBeneficiario, Cadena_Vacia);
		END IF;

		INSERT INTO CUENTASTRANSFER (
			ClienteID,			CuentaTranID,			InstitucionID,	   		Clabe,			Beneficiario,
			Alias,				FechaRegistro,			Estatus,           		TipoCuenta,		CuentaDestino,
			ClienteDestino,     TipoCuentaSpei,     	RFCBeneficiario,   		EsPrincipal,	AplicaPara,
            EstatusDomici,		MontoLimite,			EmpresaID,				Usuario,		FechaActual,
            DireccionIP,		ProgramaID,				Sucursal,				NumTransaccion)
		VALUES (
			Par_ClienteID,		Var_NumCtaTran,		 	Par_InstitucionID,		Par_Clabe,		Par_Beneficiario,
			Par_Alias,			Par_FechaRegistro,	 	Est_Registrado,	  		Par_TipoCuenta,	Par_CuentaDestino,
			Par_ClienteDestino, Par_TipoCuentaSpei,  	Par_RFCBeneficiario,	Par_EsPrincipal,Par_AplicaPara,
            Var_EstatusDomicilio,Par_MontoLimite,		Par_EmpresaID,			Aud_Usuario,	Aud_FechaActual,
            Aud_DireccionIP,	 Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

		SET	Par_NumErr 		:= 0;
		-- NOTA: En caso de actualizar el mensaje se debe actualizar el SP de BANCUENTASDESTINOALT.
		SET	Par_ErrMen 		:= CONCAT('Cuenta Destino Agregada: ', CONVERT(Var_NumCtaTran, CHAR));
		SET Var_Control 	:= 'cuentaTranID';
		SET Var_Consecutivo := Var_NumCtaTran;

END ManejoErrores;

		IF(Par_Salida = SalidaSI)THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_Consecutivo AS Consecutivo;
		END IF;

END TerminaStore$$
