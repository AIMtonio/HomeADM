-- SP NOTASCARGOALT

DELIMITER ;

DROP PROCEDURE IF EXISTS NOTASCARGOALT;

DELIMITER $$

CREATE PROCEDURE `NOTASCARGOALT`(
	-- Stored procedure para dar de alta los registros de la tabla de notas de cargo
	Par_CreditoID						BIGINT(20),			-- Identificador del credito
	Par_AmortizacionID					INT(11),			-- Identificador de la amortizacion
	Par_TipoNotaCargoID					INT(11),			-- Identificador del tipo de nota de cargo. Tabla TIPOSNOTASCARGO
	Par_Monto							DECIMAL(14,2),		-- Monto de la nota de cargo
	Par_IVA								DECIMAL(14,2),		-- Monto de iva de la nota de cargo

	Par_Motivo							VARCHAR(2000),		-- Motivo por el cual se realizo la nota de cargo al credito por parte del usuario
	Par_Capital							DECIMAL(14,2),		-- Monto de capital de la amortizacion al momento del alta de la nota
	Par_Interes							DECIMAL(14,2),		-- Monto de interes de la amortizacion al momento del alta de la nota
	Par_IVAInteres						DECIMAL(14,2),		-- Monto de iva de interes de la amortizacion al momento del alta de la nota
	Par_Moratorio						DECIMAL(14,2),		-- Monto de moratorio de la amortizacion al momento del alta de la nota

	Par_IVAMoratorio					DECIMAL(14,2),		-- Monto de iva de moratorio de la amortizacion al momento del alta de la nota
	Par_OtrasComisiones					DECIMAL(14,2),		-- Monto de otras comisiones de la amortizacion al momento del alta de la nota
	Par_IVAComisiones					DECIMAL(14,2),		-- Monto de iva de comisiones de la amortizacion al momento del alta de la nota

	Par_TranPagoCredito					BIGINT(20),			-- Numero de transaccion del pago de credito al que se le aplico una nota de pago no reconocido
	Par_AmortizacionPago				INT(11),			-- Identificador de la amortizacion de un pago de credito

	Par_Salida							CHAR(1),			-- Parametro para salida de datos
	INOUT Par_NumErr					INT(11),			-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen					VARCHAR(400),		-- Parametro de entrada/salida de mensaje de control de respuesta de acuerdo al desarrollador

	Par_EmpresaID 						INT(11),			-- Parametros de auditoria
	Aud_Usuario							INT(11),			-- Parametros de auditoria
	Aud_FechaActual						DATETIME,			-- Parametros de auditoria
	Aud_DireccionIP						VARCHAR(15),		-- Parametros de auditoria
	Aud_ProgramaID						VARCHAR(50),		-- Parametros de auditoria
	Aud_Sucursal						INT(11), 			-- Parametros de auditoria
	Aud_NumTransaccion					BIGINT(20)			-- Parametros de auditoria
)
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_Control					VARCHAR(50);		-- Variable de control
	DECLARE Var_FechaSistema			DATE;				-- Variable para almacenar la fecha del sistema
	DECLARE Var_NotaCargoID				BIGINT(20);			-- Variable para almacenar el identificador de una nota de cargo
	DECLARE Var_CreditoID				BIGINT(12);			-- Variable para almacenar el identificador de un credito
	DECLARE Var_AmortizacionID			INT(11);			-- Variable para almacenar el identificador de una amortizacion
	DECLARE Var_TipoNotCargoID			INT(11);			-- Variable para almacenar el identificador de un tipo de notas de cargo
	DECLARE Var_Estatus					CHAR(1);			-- Variable para almacenar el estatus de un credito

	-- Declaracion de constantes
	DECLARE Entero_Cero					INT(11);			-- Entero cero
	DECLARE Entero_Uno					INT(1);				-- Entero uno
	DECLARE Cadena_Vacia				CHAR(1);			-- Cadena vacia
	DECLARE Fecha_Vacia					DATE;				-- Fecha vacia
	DECLARE Var_SalidaSI				CHAR(1);			-- Salida si
	DECLARE Var_SalidaNO				CHAR(1);			-- Salida no
	DECLARE Var_EstRegistrada			CHAR(1);			-- Estatus R : Registrada
	DECLARE Var_EstVigente				CHAR(1);			-- Estatus V : Vigente
	DECLARE Var_EstVencido				CHAR(1);			-- Estatus B : Vencido
	DECLARE Var_EstAtrasado				CHAR(1);			-- Estatus A : Atrasado
	DECLARE Var_EstActiva				CHAR(1);			-- Estatus A : Activa

	-- Asignacion de constantes
	SET Entero_Cero						:= 0;				-- Asignacion de entero cero
	SET Entero_Uno						:= 1;				-- Entero uno
	SET Cadena_Vacia					:= '';				-- Asignacion de cadena vacia
	SET Fecha_Vacia						:= '1900-01-01';	-- Asignacion de fecha vacia
	SET Var_SalidaSI					:= 'S';				-- Salida si
	SET Var_SalidaNO					:= 'N';				-- Salida no
	SET Var_EstRegistrada				:= 'R';				-- Estatus R : Registrada
	SET Var_EstVigente					:= 'V';				-- Estatus V : Vigente
	SET Var_EstVencido					:= 'B';				-- Estatus B : Vencido
	SET Var_EstAtrasado					:= 'A';				-- Estatus A : Atrasado
	SET Var_EstActiva					:= 'A';				-- Estatus A : Activa

	-- Valores por default
	SET Par_CreditoID					:= IFNULL(Par_CreditoID, Entero_Cero);
	SET Par_AmortizacionID				:= IFNULL(Par_AmortizacionID, Entero_Cero);
	SET Par_TipoNotaCargoID				:= IFNULL(Par_TipoNotaCargoID, Entero_Cero);
	SET Par_Monto						:= IFNULL(Par_Monto, Entero_Cero);
	SET Par_Motivo						:= IFNULL(Par_Motivo, Cadena_Vacia);

	SET Par_Capital						:= IFNULL(Par_Capital, Entero_Cero);
	SET Par_Interes						:= IFNULL(Par_Interes, Entero_Cero);
	SET Par_IVAInteres					:= IFNULL(Par_IVAInteres, Entero_Cero);
	SET Par_Moratorio					:= IFNULL(Par_Moratorio, Entero_Cero);
	SET Par_IVAMoratorio				:= IFNULL(Par_IVAMoratorio, Entero_Cero);

	SET Par_OtrasComisiones				:= IFNULL(Par_OtrasComisiones, Entero_Cero);
	SET Par_IVAComisiones				:= IFNULL(Par_IVAComisiones, Entero_Cero);

	SET Par_EmpresaID					:= IFNULL(Par_EmpresaID, Entero_Cero);
	SET Aud_Usuario						:= IFNULL(Aud_Usuario, Entero_Cero);
	SET Aud_FechaActual					:= NOW();
	SET Aud_DireccionIP					:= IFNULL(Aud_DireccionIP, Cadena_Vacia);
	SET Aud_ProgramaID					:= IFNULL(Aud_ProgramaID, Cadena_Vacia);
	SET Aud_Sucursal					:= IFNULL(Aud_Sucursal, Entero_Cero);
	SET Aud_NumTransaccion				:= IFNULL(Aud_NumTransaccion, Entero_Cero);

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-NOTASCARGOALT');
			SET Var_Control = 'sqlException';
		END;

		-- Validaciones
		IF (Par_CreditoID = Entero_Cero) THEN
			SET Par_NumErr 	:= 001;
			SET Par_ErrMen	:= 'El identificador del credito esta vacio';
			SET Var_Control := 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		SELECT		CreditoID
			INTO	Var_CreditoID
			FROM	CREDITOS
			WHERE	CreditoID = Par_CreditoID;

		SET Var_CreditoID	:= IFNULL(Var_CreditoID, Entero_Cero);

		IF (Var_CreditoID = Entero_Cero) THEN
			SET Par_NumErr 	:= 002;
			SET Par_ErrMen	:= 'El credito indicado no existe';
			SET Var_Control := 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_AmortizacionID = Entero_Cero) THEN
			SET Par_NumErr 	:= 003;
			SET Par_ErrMen	:= 'El identificador de la amortizacion esta vacio';
			SET Var_Control := 'amortizacionID';
			LEAVE ManejoErrores;
		END IF;

		SELECT		AmortizacionID,			Estatus
			INTO	Var_AmortizacionID,		Var_Estatus
			FROM	AMORTICREDITO
			WHERE	AmortizacionID = Par_AmortizacionID
			  AND	CreditoID = Var_CreditoID;

		SET Var_AmortizacionID	:= IFNULL(Var_AmortizacionID, Entero_Cero);
		SET Var_Estatus			:= IFNULL(Var_Estatus, Cadena_Vacia);

		IF (Var_AmortizacionID = Entero_Cero) THEN
			SET Par_NumErr 	:= 004;
			SET Par_ErrMen	:= 'La amortizacion indicada no existe';
			SET Var_Control := 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		IF (Var_Estatus NOT IN (Var_EstVigente, Var_EstVencido, Var_EstAtrasado)) THEN
			SET Par_NumErr 	:= 005;
			SET Par_ErrMen	:= 'La amortizacion indicada no se encuentra en un estatus valido';
			SET Var_Control := 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_TipoNotaCargoID = Entero_Cero) THEN
			SET Par_NumErr 	:= 006;
			SET Par_ErrMen	:= 'El identificador del tipo de nota de cargo esta vacio';
			SET Var_Control := 'tipoNotaCargoID';
			LEAVE ManejoErrores;
		END IF;

		SELECT		TipoNotaCargoID
			INTO	Var_TipoNotCargoID
			FROM	TIPOSNOTASCARGO
			WHERE	TipoNotaCargoID = Par_TipoNotaCargoID
			  AND	Estatus = Var_EstActiva;

		SET Var_TipoNotCargoID	:= IFNULL(Var_TipoNotCargoID, Entero_Cero);

		IF (Var_TipoNotCargoID = Entero_Cero) THEN
			SET Par_NumErr 	:= 007;
			SET Par_ErrMen	:= 'El tipo de nota de cargo indicado no existe o no se encuentra activo';
			SET Var_Control := 'tipoNotaCargoID';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_Monto = Entero_Cero) THEN
			SET Par_NumErr 	:= 008;
			SET Par_ErrMen	:= 'El monto de la nota de cargo esta vacio';
			SET Var_Control := 'monto';
			LEAVE ManejoErrores;
		END IF;

		SELECT		FechaSistema
			INTO	Var_FechaSistema
			FROM	PARAMETROSSIS;

		CALL FOLIOSAPLICAACT('NOTASCARGO', Var_NotaCargoID);

		INSERT INTO NOTASCARGO (	NotaCargoID,		CreditoID,			AmortizacionID,			FechaRegistro,			TipoNotaCargoID,
									Monto,				IVA,				Motivo,					Referencia,				Capital,
									Interes,			IVAInteres,			Moratorio,				IVAMoratorio,			OtrasComisiones,
									IVAComisiones,		TotalPago,			Estatus,				TranPagoCredito,		AmortizacionPago,
									EmpresaID,			Usuario,			FechaActual,			DireccionIP,			ProgramaID,
									Sucursal,			NumTransaccion	)
						VALUES (	Var_NotaCargoID,	Var_CreditoID,		Var_AmortizacionID,		Var_FechaSistema,		Var_TipoNotCargoID,
									Par_Monto,			Par_IVA,			Par_Motivo,				Entero_Cero,			Par_Capital,
									Par_Interes,		Par_IVAInteres,		Par_Moratorio,			Par_IVAMoratorio,		Par_OtrasComisiones,
									Par_IVAComisiones,	Entero_Cero,		Var_EstRegistrada,		Par_TranPagoCredito,	Par_AmortizacionPago,
									Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
									Aud_Sucursal,		Aud_NumTransaccion	);

		-- El registro se inserto exitosamente
		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= CONCAT('Nota de Cargo dada de Alta Exitosamente: ', CAST(Var_NotaCargoID AS CHAR));
		SET Var_Control	:= 'usuarioID';
	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida = Var_SalidaSI) THEN
		SELECT	Par_NumErr				AS NumErr,
				Par_ErrMen				AS ErrMen,
				Var_Control				AS control,
				Var_NotaCargoID			AS consecutivo;
	END IF;

END TerminaStore$$