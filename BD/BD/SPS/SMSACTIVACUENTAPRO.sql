-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSACTIVACUENTAPRO

DELIMITER ;
DROP PROCEDURE IF EXISTS `SMSACTIVACUENTAPRO`;
DELIMITER $$

CREATE PROCEDURE `SMSACTIVACUENTAPRO`(
	-- SP para actualizar las cuentas de ahorro
	Par_CuentaAhoID			BIGINT(12),				-- Cuenta de ahorro, requerido para saber si el tipo de cuenta requiere SMS


	Par_Salida				CHAR(1),				-- Salida S:Si No:No
	INOUT Par_NumErr		INT(11),				-- Numero de error
	INOUT Par_ErrMen		VARCHAR(400),			-- Mensaje de error
	-- Auditoria
	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),

	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
	)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE	Var_TelCelular		Char(10);         -- Telefono Receptor
	DECLARE	Var_PlantillaID		INT(11);          -- Identificador de plantilla
	DECLARE Var_NotificaSMS		CHAR(1);          -- Notificación Si o no
	DECLARE Var_Mensaje			VARCHAR(400);     -- Mensaje a enviar
	DECLARE	Var_CampaniaSMS		VARCHAR(10);      -- Campania parametro
	DECLARE Var_CampaniaID		INT(11);          -- Campaña envio
	DECLARE Var_Control			VARCHAR(100);     -- Variable de control
	DECLARE Var_ClienteID		INT(11);          -- Cliente identificador
	DECLARE Var_NumClientes		INT(11);
	DECLARE Var_ClientesID		VARCHAR(200);
    -- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE Entero_Uno			INT(1);
	DECLARE	Entero_Cero			INT(1);
	DECLARE	Valor_Si			CHAR(1);
	DECLARE SalidaSI			CHAR(1);
	DECLARE	SalidaNo			CHAR(1);
	DECLARE Var_EmisorGenerico  CHAR(11);			-- Remitente generico para validacion de alta de envio de mensajes
	DECLARE Fecha_Vacia			DATE;
	DECLARE ActivaCuenta	    INT(11);
    DECLARE Var_TipoPersona     CHAR(1); -- LUCAN T_14294

	-- Asignacion de constantes
	SET	Cadena_Vacia			:= '';
	SET	Entero_Uno 				:= 1;
	SET Entero_Cero				:= 0;
	SET Valor_Si				:= 'S';
	SET SalidaSI				:= 'S';
	SET SalidaNo				:= 'N';
	SET	Var_EmisorGenerico		:= '9999999999';			-- Remitente generico para validacion de alta de envio de mensajes
	SET Fecha_Vacia				:= '1900-01-01';			-- Asignacion de fecha vacia
	SET ActivaCuenta			:= 3;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SMSACTIVACUENTAPRO');
			SET Var_Control := 'SQLEXCEPTION' ;
		END;

			-- Verificar si el tipo de cuenta permite envio de SMS y tiene plantilla asociada
		SELECT		Tp.NotificacionSms,	Tp.PlantillaID
			INTO	Var_NotificaSMS,		Var_PlantillaID
			FROM CUENTASAHO Cue
				INNER JOIN TIPOSCUENTAS Tp
				ON Cue.TipoCuentaID = Tp.TipoCuentaID
			WHERE Cue.CuentaAhoID = Par_CuentaAhoID
			LIMIT Entero_Uno;

		SET Var_NotificaSMS := IFNULL(Var_NotificaSMS, Cadena_Vacia);
		SET Var_PlantillaID	:= IFNULL(Var_PlantillaID, Entero_Cero);

		IF(Var_NotificaSMS = Valor_Si) THEN
	        -- Verificar si el cliente cuenta con un numero de telefono celular
			SELECT		Cli.TelefonoCelular,	Cli.ClienteID, TipoPersona
				INTO 	Var_TelCelular,			Var_ClienteID, Var_TipoPersona
				FROM CLIENTES Cli
				INNER JOIN CUENTASAHO Cue ON Cue.ClienteID=Cli.ClienteID
				WHERE Cue.CuentaAhoID = Par_CuentaAhoID
				LIMIT Entero_Uno;

			SET Var_TelCelular	:= IFNULL(Var_TelCelular, Cadena_Vacia);

			IF (Var_TipoPersona = 'F' OR Var_TipoPersona = 'A')THEN -- LUCAN T_14294 SE AGREGO EL IF

                IF(Var_TelCelular=Cadena_Vacia)THEN
			    	SET Par_NumErr	:= 001;
			    	SET Par_ErrMen	:= ('El Cliente No cuenta con un Numero Celular.');
			    	SET Var_Control	:= 'cuentaAhoID' ;
			    	LEAVE ManejoErrores;
			    END IF;

            END IF; -- FIN AGREGADO

			IF(Var_PlantillaID = Entero_Cero) THEN
				SET Par_NumErr	:= 002;
				SET Par_ErrMen	:= ('El tipo de cuenta no tiene Plantilla definida');
				SET Var_Control	:= 'cuentaAhoID' ;
				LEAVE ManejoErrores;
			END IF;

			-- Validar la existencia de la plantilla
			SELECT sm.Descripcion
				INTO Var_Mensaje
				FROM SMSPLANTILLA sm
				WHERE sm.PlantillaID = Var_PlantillaID
				LIMIT Entero_Uno;

			SET Var_Mensaje := IFNULL(Var_Mensaje, Cadena_Vacia);

			IF(Var_Mensaje = Cadena_Vacia) THEN
				SET Par_NumErr	:= 003;
				SET Par_ErrMen	:= ('La Plantilla no existe');
				SET Var_Control	:= 'cuentaAhoID' ;
				LEAVE ManejoErrores;
			END IF;
			-- Validar Campaña

			SELECT par.ValorParametro
				INTO Var_CampaniaSMS
				FROM PARAMGENERALES par
				WHERE par.LlaveParametro = 'CamSmsAperturaCta'
				LIMIT Entero_Uno;
			SET Var_CampaniaSMS := IFNULL(Var_CampaniaSMS, Cadena_Vacia);

			IF(Var_CampaniaSMS = Cadena_Vacia) THEN
				SET Par_NumErr	:= 004;
				SET Par_ErrMen	:= ('La campaña SMS no esta definida en PARAMGENERALES');
				SET Var_Control	:= 'cuentaAhoID' ;
				LEAVE ManejoErrores;
			END IF;

            IF (Var_TipoPersona = 'F' OR Var_TipoPersona = 'A')THEN -- LUCAN T_14294 SE AGREGO EL IF

			    IF(LENGTH(Var_TelCelular) <> 10) THEN
			    	SET Par_NumErr	:= 005;
			    	SET Par_ErrMen	:= ('EL Numero Celular No tiene 10 digitos');
			    	SET Var_Control	:= 'cuentaAhoID' ;
			    	LEAVE ManejoErrores;
			    END IF;

            END IF; -- FIN

			SELECT sm.CampaniaID
				INTO Var_CampaniaID
				FROM SMSCAMPANIAS sm
				WHERE sm.CampaniaID = Var_CampaniaSMS
				LIMIT Entero_Uno;
			SET Var_CampaniaID := IFNULL(Var_CampaniaID, Entero_Cero);

			IF(Var_CampaniaID = Entero_Cero) THEN
				SET Par_NumErr	:= 006;
				SET Par_ErrMen	:= ('La campaña SMS no existe');
				SET Var_Control	:= 'cuentaAhoID' ;
				LEAVE ManejoErrores;
			END IF;

			IF(Var_TipoPersona = 'F' OR Var_TipoPersona = 'A')THEN -- LUCAN T_14294 SE AGREGO EL IF

			SELECT COUNT(ClienteID), GROUP_CONCAT(ClienteID)
			INTO    Var_NumClientes, Var_ClientesID
			FROM	CLIENTES
			WHERE	TelefonoCelular	= Var_TelCelular
			GROUP BY TelefonoCelular
			LIMIT 3;

            END IF; -- FIN

			SET Var_NumClientes := IFNULL(Var_NumClientes, Entero_Cero);
			SET Var_ClientesID	:= IFNULL(Var_ClientesID, Cadena_Vacia);

			IF(Var_NumClientes > 1) THEN
				SET Par_NumErr := 007;
				SET Par_ErrMen := 'Existe mas de un cliente con el mismo numero de teléfono celular, Clientes: ';
				SET Par_ErrMen := CONCAT(Par_ErrMen, Var_ClientesID);
				SET Var_Control := 'cuentaAhoID';
				LEAVE ManejoErrores;
			END IF;


			CALL SMSPLANTILLAPROST(		Par_CuentaAhoID,	Var_Mensaje,		Var_TelCelular,		ActivaCuenta,	SalidaNo,
										Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
										Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero) THEN
				SET Var_Control := 'SMSPLANTILLAPROST';
				LEAVE ManejoErrores;
			END IF;

            IF(Var_TipoPersona = 'F' OR Var_TipoPersona = 'A')THEN -- LUCAN T_14294 SE AGREGO EL IF

		    	CALL SMSENVIOMENSAJEALT(	Var_EmisorGenerico,		Var_TelCelular,		Fecha_Vacia,		Var_Mensaje,	Aud_FechaActual,
		    								Var_CampaniaID, 		Fecha_Vacia,		Par_CuentaAhoID,	Var_ClienteID,		Cadena_Vacia,
		    								Cadena_Vacia,			SalidaNo,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
		    								Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
										Aud_NumTransaccion);

		    	IF (Par_NumErr <> Entero_Cero) THEN
		    		SET Var_Control := 'SMSENVIOMENSAJEALT';
		    		LEAVE ManejoErrores;
		    	END IF;

            END IF; -- FIN

		END IF;
END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
	SELECT	Par_NumErr 		AS NumErr,
			Par_ErrMen 		AS ErrMen,
			Var_Control 	AS control;
END IF;

END TerminaStore$$