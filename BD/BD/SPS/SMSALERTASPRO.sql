-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSALERTASRETIROSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `SMSALERTASPRO`;

DELIMITER $$
CREATE PROCEDURE `SMSALERTASPRO`(
	-- Stored procedure para realizar envios de SMS al realizar retiros en ventanilla
	Par_CuentaAhoID		BIGINT(20),		-- Identificador de la cuenta de ahorro
	Par_CantidadMov		DECIMAL(14,2),	-- Monto de la operacion realizado en ventanilla
	Par_NumAlerta		INT(11),		-- Numero de mensaje/plantilla
	Par_JsonParams		VARCHAR(1000),  -- Parametros para plantilla sms en formato json

	Par_Salida			CHAR(1),		-- Parametro que indica si el procedimiento devuelve una salida
	INOUT Par_NumErr	INT(11),		-- Parametro que corresponde a un numero de exito o error
	INOUT Par_ErrMen	VARCHAR(400),	-- Parametro que corresponde a un mensaje de exito o error

	Par_EmpresaID		INT(11),		-- Parametros de Auditoria
	Aud_Usuario			INT(11),		-- Parametros de Auditoria
	Aud_FechaActual		DATETIME,		-- Parametros de Auditoria
	Aud_DireccionIP		VARCHAR(15),	-- Parametros de Auditoria
	Aud_ProgramaID		VARCHAR(50),	-- Parametros de Auditoria
	Aud_Sucursal		INT(11),		-- Parametros de Auditoria
	Aud_NumTransaccion	BIGINT(20)		-- Parametros de Auditoria
)
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_Control			VARCHAR(50);				-- Variable de control
	DECLARE Var_ValorCampaniaID	VARCHAR(200);				-- Variable para obtener la campania parametrizada de PARAMGENERALES
	DECLARE Var_CampaniaID		INT(11);					-- Variable para obtener la campania de SMSCAMPANIAS
	DECLARE Var_TelefonoCelular	VARCHAR(20);				-- Telefono celular del cliente
	DECLARE Var_EnvioSMSRetiro	CHAR(1);					-- Envio de SMS al realizar retiros
	DECLARE Var_MonMinSMSRetiro	DECIMAL(14,2);				-- Monto minimo para realizar envios SMS en retiros
	DECLARE Var_MensajeSMS		VARCHAR(300);				-- Texto del mensaje a enviar
    DECLARE Var_ClienteID			INT(11);				-- Variable para obtener el Numero de cliente
	DECLARE Var_TelefonoCelularCta	VARCHAR(20);			-- Telefono celular de la cta de Ahorro

	-- Declaracion de constantes
	DECLARE Entero_Cero			INT(11);					-- Entero vacio
	DECLARE Entero_Uno			INT(11);					-- Entero uno
	DECLARE Decimal_Cero		DECIMAL(14,2);				-- Decimal cero
	DECLARE Cadena_Vacia		CHAR(1);					-- Cadena vacia
	DECLARE Fecha_Vacia			DATE;						-- Fecha vacia
	DECLARE Var_SalidaSI		CHAR(1);					-- Salida si
	DECLARE Var_SalidaNO		CHAR(1);					-- Salida no
	DECLARE Var_LlaveParametro	VARCHAR(50);				-- Parametro para la campania parametrizada de PARAMGENERALES
	DECLARE Var_ClasifSalida	CHAR(1);					-- Clasificacion salida
	DECLARE Var_EmisorGenerico	VARCHAR(10);				-- Remitente generico para validacion de alta de envio de mensajes

	-- Números de alertas
	DECLARE Var_AlrtTrCuentas	INT(11);
	DECLARE Var_AlrtDesembolso	INT(11);
	DECLARE Var_AlrtPagoServ	INT(11);
	DECLARE Var_AlrtSpei		INT(11);

	-- Nombres de plantilla, debe coincidir con los registros de SMSPLANTILLA
	DECLARE Var_PlanTrCuentas	VARCHAR(50);
	DECLARE Var_PlanDesembolso	VARCHAR(50);
	DECLARE Var_PlanPagoServ	VARCHAR(50);
	DECLARE Var_PlanSpei		VARCHAR(50);


	DECLARE Var_Plantilla		VARCHAR(1000);				-- Variable para plantilla obtenida de SMSPLANTILLA
	DECLARE Var_PlAlertaOp		INT(11);
	-- Asignacion de constantes
	SET Entero_Cero				:= 0;						-- Asignacion de entero vacio
	SET Entero_Uno				:= 1;						-- Asignacion de entero uno
	SET Decimal_Cero			:= 0.0;						-- Asignacion de decimal vacio
	SET Cadena_Vacia			:= '';						-- Asignacion de cadena vacia
	SET Fecha_Vacia				:= '1900-01-01';			-- Asignacion de fecha vacia
	SET Var_SalidaSI			:= 'S';						-- Asignacion de salida si
	SET Var_SalidaNO			:= 'N';						-- Asignacion de salida no
	SET Var_LlaveParametro		:= 'CampaniaSMSRetiros';	-- Parametro para la campania parametrizada de PARAMGENERALES
	SET	Var_ClasifSalida		:= 'S';						-- Clasificacion salida
	SET	Var_EmisorGenerico		:= '9999999999';			-- Remitente generico para validacion de alta de envio de mensajes

	-- Valores por default
	SET Par_CuentaAhoID			:= IFNULL(Par_CuentaAhoID, Entero_Cero);
	SET Par_CantidadMov			:= IFNULL(Par_CantidadMov, Decimal_Cero);

	SET Par_EmpresaID			:= IFNULL(Par_EmpresaID, Entero_Cero);
	SET Aud_Usuario				:= IFNULL(Aud_Usuario, Entero_Cero);
	SET Aud_FechaActual			:= IFNULL(Aud_FechaActual, Fecha_Vacia);
	SET Aud_DireccionIP			:= IFNULL(Aud_DireccionIP, Cadena_Vacia);
	SET Aud_ProgramaID			:= IFNULL(Aud_ProgramaID, Cadena_Vacia);
	SET Aud_Sucursal			:= IFNULL(Aud_Sucursal, Entero_Cero);
	SET Aud_NumTransaccion		:= IFNULL(Aud_NumTransaccion, Entero_Cero);

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-SMSALERTASRETIROSPRO');
			SET Var_Control = 'sqlException';
		END;

		-- Validaciones
		IF (Par_CuentaAhoID = Entero_Cero) THEN
			SET Par_NumErr 	:= 001;
			SET Par_ErrMen	:= 'El numero de cuenta se encuentra vacio';
			SET Var_Control := 'Par_CuentaAhoID';
			LEAVE ManejoErrores;
		END IF;

		SELECT		cli.TelefonoCelular,		cli.ClienteID
				INTO	Var_TelefonoCelular,	Var_ClienteID
				FROM	CUENTASAHO AS cue
				INNER JOIN CLIENTES AS cli on cue.ClienteID = cli.ClienteID
				WHERE	cue.CuentaAhoID = Par_CuentaAhoID;

		SET Var_TelefonoCelular := IFNULL(Var_TelefonoCelular, Cadena_Vacia);


        IF(Var_TelefonoCelular = Cadena_Vacia) THEN

			SELECT		cue.TelefonoCelular,	cue.ClienteID
			INTO	Var_TelefonoCelularCta,	Var_ClienteID
			FROM	CUENTASAHO AS cue
			WHERE	cue.CuentaAhoID = Par_CuentaAhoID;

        	SET Var_TelefonoCelular := IFNULL(Var_TelefonoCelularCta, Cadena_Vacia);

			IF (Var_TelefonoCelular = Cadena_Vacia) THEN
				SET Par_NumErr 	:= 002;
				SET Par_ErrMen	:= 'El cliente asociado a la cuenta no cuenta con telefono celular para envio de SMS';
				SET Var_Control := 'Var_TelefonoCelular';
				LEAVE ManejoErrores;
			END IF;

        END IF;

		SELECT		tipo.EnvioSMSRetiro,	tipo.MontoMinSMSRetiro
			INTO	Var_EnvioSMSRetiro,		Var_MonMinSMSRetiro
			FROM	CUENTASAHO AS cue
			INNER JOIN TIPOSCUENTAS AS tipo ON cue.TipoCuentaID = tipo.TipoCuentaID
			WHERE cue.CuentaAhoID = Par_CuentaAhoID;

		IF (Var_EnvioSMSRetiro <> Var_SalidaSI) THEN
			SET Par_NumErr 	:= 003;
			SET Par_ErrMen	:= 'No se encuentra habilitada la opcion de envio de SMS en retiros para esta cuenta';
			SET Var_Control := 'Var_EnvioSMSRetiro';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_CantidadMov < Var_MonMinSMSRetiro) THEN
			SET Par_NumErr 	:= 004;
			SET Par_ErrMen	:= 'El monto de retiro es menor que el monto minimo parametrizado para esta cuenta';
			SET Var_Control := 'Par_CantidadMov';
			LEAVE ManejoErrores;
		END IF;

		SELECT		ValorParametro
			INTO	Var_ValorCampaniaID
			FROM	PARAMGENERALES
			WHERE	LlaveParametro = Var_LlaveParametro;

		SET Var_ValorCampaniaID := IFNULL(Var_ValorCampaniaID, Cadena_Vacia);

		IF (Var_ValorCampaniaID = Cadena_Vacia) THEN
			SET Par_NumErr 	:= 005;
			SET Par_ErrMen	:= 'No se encuentra parametrizada una campania para envio de SMS en retiros';
			SET Var_Control := 'Var_ValorCampaniaID';
			LEAVE ManejoErrores;
		END IF;

		SELECT		CampaniaID
			INTO	Var_CampaniaID
			FROM	SMSCAMPANIAS
			WHERE	CampaniaID = CAST(Var_ValorCampaniaID AS UNSIGNED)
			  AND	Clasificacion = Var_ClasifSalida;

		SET Var_CampaniaID := IFNULL(Var_CampaniaID, Entero_Cero);

		IF (Var_CampaniaID = Entero_Cero) THEN
			SET Par_NumErr 	:= 006;
			SET Par_ErrMen	:= 'La campania parametrizada no se encuentra entre las campanias de salida existentes';
			SET Var_Control := 'Var_CampaniaID';
			LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual := CURRENT_TIMESTAMP();

		SELECT PlantillaID INTO Var_PlAlertaOp FROM SMSENVIOALERTAOP WHERE SMSEnvioAlertaOpID = Par_NumAlerta LIMIT 1;

		IF (IFNULL(Var_PlAlertaOp,Entero_Cero) = Entero_Cero) THEN
			SET Var_Plantilla := CONCAT('Retiro Cuenta terminacion &U4CO monto &MT el &FA Aut. &NT');
		ELSE
			Select Descripcion INTO Var_Plantilla FROM SMSPLANTILLA WHERE PlantillaID = Var_PlAlertaOp LIMIT 1;
		END IF;

		IF (IFNULL(Var_Plantilla,Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr 	:= 008;
			SET Par_ErrMen	:= 'No se encontró plantilla para el numero de alerta seleccionado';
			SET Var_Control := '';
			LEAVE ManejoErrores;
		END IF;

		SELECT SUBSTRING((FNSMSPLANTILLAJSON(Par_JsonParams,Var_Plantilla,1)),1,160) INTO Var_MensajeSMS;

		CALL SMSENVIOMENSAJEALT(	Var_EmisorGenerico,	Var_TelefonoCelular,	Fecha_Vacia,		Var_MensajeSMS,		Aud_FechaActual,
									Var_CampaniaID,		Fecha_Vacia,			Par_CuentaAhoID,	Var_ClienteID,		Cadena_Vacia,
									Cadena_Vacia,		Var_SalidaNO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
									Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
									Aud_NumTransaccion);

		IF (Par_NumErr <> Entero_Cero) THEN
			SET Var_Control := 'SMSENVIOMENSAJEALT';
			LEAVE ManejoErrores;
		END IF;

		-- La operacion se realizo exitosamente
		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= 'Alerta SMS registrada exitosamente';
		SET Var_Control	:= Cadena_Vacia;

	END ManejoErrores;

    -- Si Par_Salida = S (SI)
	IF(Par_Salida = Var_SalidaSI) THEN
		SELECT	Par_NumErr		AS NumErr,
				Par_ErrMen		AS ErrMen,
				Var_Control		AS control,
				Entero_Cero		AS consecutivo;
	END IF;

-- Fin del Stored Procedure
END TerminaStore$$