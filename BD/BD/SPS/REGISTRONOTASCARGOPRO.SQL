-- SP REGISTRONOTASCARGOPRO

DELIMITER ;

DROP PROCEDURE IF EXISTS REGISTRONOTASCARGOPRO;

DELIMITER $$

CREATE PROCEDURE `REGISTRONOTASCARGOPRO`(
	-- SP para dar de alta una nota de cargo con sus respectivos movimientos contables
	Par_CreditoID						BIGINT(20),					-- Identificador del credito
	Par_AmortizacionID					INT(11),					-- Identificador de la amortizacion
	Par_TipoNotaCargoID					INT(11),					-- Identificador del tipo de nota de cargo. Tabla TIPOSNOTASCARGO
	Par_Monto							DECIMAL(14,2),				-- Monto de la nota de cargo
	Par_IVA								DECIMAL(14,2),				-- Monto de iva de la nota de cargo

	Par_Motivo							VARCHAR(2000),				-- Motivo por el cual se realizo la nota de cargo al credito por parte del usuario
	Par_Capital							DECIMAL(14,2),				-- Monto de capital de la amortizacion al momento del alta de la nota
	Par_Interes							DECIMAL(14,2),				-- Monto de interes de la amortizacion al momento del alta de la nota
	Par_IVAInteres						DECIMAL(14,2),				-- Monto de iva de interes de la amortizacion al momento del alta de la nota
	Par_Moratorio						DECIMAL(14,2),				-- Monto de moratorio de la amortizacion al momento del alta de la nota

	Par_IVAMoratorio					DECIMAL(14,2),				-- Monto de iva de moratorio de la amortizacion al momento del alta de la nota
	Par_OtrasComisiones					DECIMAL(14,2),				-- Monto de otras comisiones de la amortizacion al momento del alta de la nota
	Par_IVAComisiones					DECIMAL(14,2),				-- Monto de iva de comisiones de la amortizacion al momento del alta de la nota

	Par_TranPagoCredito					BIGINT(20),					-- Numero de transaccion del pago de credito al que se le aplico una nota de pago no reconocido
	Par_AmortizacionPago				INT(11),					-- Identificador de la amortizacion de un pago de credito

	Par_Salida							CHAR(1),					-- Parametro para salida de datos
	INOUT Par_NumErr					INT(11),					-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen					VARCHAR(400),				-- Parametro de entrada/salida de mensaje de control de respuesta de acuerdo al desarrollador

	Par_EmpresaID 						INT(11),					-- Parametros de auditoria
	Aud_Usuario							INT(11),					-- Parametros de auditoria
	Aud_FechaActual						DATETIME,					-- Parametros de auditoria
	Aud_DireccionIP						VARCHAR(15),				-- Parametros de auditoria
	Aud_ProgramaID						VARCHAR(50),				-- Parametros de auditoria
	Aud_Sucursal						INT(11), 					-- Parametros de auditoria
	Aud_NumTransaccion					BIGINT(20)					-- Parametros de auditoria
)
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_Control					VARCHAR(50);				-- Variable de control
	DECLARE Var_PolizaID				BIGINT(20);					-- Variable para almacenar el identificador de una poliza
	DECLARE Var_FechaSistema			DATE;						-- Variable para almacenar la fecha del sistema
	DECLARE Var_FechaOper				DATE;						-- Variable para almacenar la fecha de operacion
	DECLARE Var_FechaApl				DATE;						-- Variable para almacenar la fecha de aplicacion
	DECLARE Var_EsHabil					CHAR(1);					-- Variable para almacenar si una fecha es habil
	DECLARE Var_MonedaID				INT(11);					-- Variable para almacenar el identificador de una moneda
	DECLARE Var_ProdCredID				INT(11);					-- Variable para almacenar el identificador de un producto de credito
	DECLARE Var_Referencia				VARCHAR(50);				-- Variable para almacenar una referencia para aplicacion de nota de cargo
	DECLARE Var_Descripcion				VARCHAR(40);				-- Variable para almacenar la descripcion de un movimiento de credito
	DECLARE Var_CuentaAhoID				BIGINT(12);					-- Variable para almacenar el identificador de una cuenta de ahorro
	DECLARE Var_ClienteID				INT(11);					-- Variable para almacenar el identificador de un cliente
	DECLARE Var_Consecutivo				BIGINT(20);					-- Variable para almacenar un consecutivo que retornan los procesos contables
	DECLARE Var_ConteoPoliza			INT(11);					-- Variable para almacenar un conteo de registros de detalle de poliza
	DECLARE Var_ClasifCre				CHAR(1);					-- Variable para almacenar la clasificacion de un credito
	DECLARE Var_SubClasifID				INT(11);					-- Variable para almacenar la subclasificacion de un credito
	DECLARE Var_SucCliente				INT(11);					-- Variable para almacenar el identificador de la sucursal de un cliente
	DECLARE Var_CuentaPuente			VARCHAR(50);				-- Variable para almacenar la cuenta puente para notas de cargo de pagos no reconocido
	DECLARE Var_CuentaConta				VARCHAR(50);				-- Variable para almacenar la cuenta contable para notas de cargo de pagos no reconocido
	DECLARE Var_CentroCostoID			INT(11);					-- Variable para almacenar el identificador de un centro de costos
	DECLARE Var_TipoMovNotCar			INT(11);					-- Variable para almacenar un tipo de movimiento de credito

	-- Declaracion de constantes
	DECLARE Entero_Cero					INT(11);					-- Entero cero
	DECLARE Entero_Uno					INT(11);					-- Entero uno
	DECLARE Entero_Dos					INT(11);					-- Entero dos
	DECLARE Cadena_Vacia				CHAR(1);					-- Cadena vacia
	DECLARE Fecha_Vacia					DATE;						-- Fecha vacia
	DECLARE Var_SalidaSI				CHAR(1);					-- Salida si
	DECLARE Var_SalidaNO				CHAR(1);					-- Salida no
	DECLARE Var_EstVigente				CHAR(1);					-- Estatus Vigente
	DECLARE Var_AltaPoliza_NO			CHAR(1);					-- Indica que no se se da de alta el encabezado de poliza
	DECLARE Var_AltaPolCre_SI			CHAR(1);					-- Indica que si se da de alta la poliza de credito
	DECLARE Var_AltaMovCre_SI			CHAR(1);					-- Indica que si se da de alta un movimiento de credito
	DECLARE Var_AltaMovCre_NO			CHAR(1);					-- Indica que no se da de alta un movimiento de credito
	DECLARE Var_AltaMovAho_NO			CHAR(1);					-- Indica que no se da de alta un movimiento de ahorro
	DECLARE Var_NatCargo				CHAR(1);					-- Naturaleza Cargo
	DECLARE Var_NatAbono				CHAR(1);					-- Naturaleza Abono
	DECLARE Var_TipoPolAuto				CHAR(1);					-- Tipo poliza A : Automatica
	DECLARE Var_MovNotCarCIva			INT(11);					-- Movimiento Aplicacion de Nota de Cargo con Iva
	DECLARE Var_MovNotCarSIva			INT(11);					-- Movimiento Aplicacion de Nota de Cargo sin Iva
	DECLARE Var_MovNotCarRev			INT(11);					-- Movimiento Aplicacion de Nota de Cargo pagos no reconocidos
	DECLARE Var_TipNotCarRev			INT(11);					-- Tipo de nota de cargo de pagos no reconocidos
	DECLARE Var_LlaveParamCta			VARCHAR(20);				-- Llave parametro para obtener la cuenta puente para notas de cargo de pagos no reconocidos
	DECLARE Var_Procedimiento			VARCHAR(20);				-- Nombre del procedimiento que ejecuta el alta del detalle en poliza
	DECLARE Var_TipoInstCre				INT(11);					-- Tipo de instrumento Credito
	DECLARE Var_ConcApNotaCar			INT(11);					-- Concepto contable aplicacion nota de cargo
	DECLARE Var_ConActivoNotas			INT(11);					-- Concepto de cartera activo notas de cargo
	DECLARE Var_ConCtaOrdNotas			INT(11);					-- Concepto de cartera cuenta orden notas de cargo
	DECLARE Var_ConCtaCorNotas			INT(11);					-- Concepto de cartera cuenta correlativa notas de cargo

	-- Asignacion de constantes
	SET Entero_Cero						:= 0;						-- Asignacion de entero cero
	SET Entero_Uno						:= 1;						-- Entero uno
	SET Entero_Dos						:= 2;						-- Entero dos
	SET Cadena_Vacia					:= '';						-- Asignacion de cadena vacia
	SET Fecha_Vacia						:= '1900-01-01';			-- Asignacion de fecha vacia
	SET Var_SalidaSI					:= 'S';						-- Salida si
	SET Var_SalidaNO					:= 'N';						-- Salida no
	SET Var_EstVigente					:= 'V';						-- Estatus Vigente
	SET Var_AltaPoliza_NO				:= 'N';						-- Indica que no se se da de alta el encabezado de poliza
	SET Var_AltaPolCre_SI				:= 'S';						-- Indica que si se da de alta la poliza de credito
	SET Var_AltaMovCre_SI				:= 'S';						-- Indica que si se da de alta un movimiento de credito
	SET Var_AltaMovCre_NO				:= 'N';						-- Indica que no se da de alta un movimiento de credito
	SET Var_AltaMovAho_NO				:= 'N';						-- Indica que no se da de alta un movimiento de ahorro
	SET Var_NatCargo					:= 'C';						-- Naturaleza Cargo
	SET Var_NatAbono					:= 'A';						-- Naturaleza Abono
	SET Var_TipoPolAuto					:= 'A';						-- Tipo poliza A : Automatica
	SET Var_MovNotCarCIva				:= 53;						-- Movimiento Aplicacion de Nota de Cargo con Iva
	SET Var_MovNotCarSIva				:= 54;						-- Movimiento Aplicacion de Nota de Cargo sin Iva
	SET Var_MovNotCarRev				:= 55;						-- Movimiento Aplicacion de Nota de Cargo pagos no reconocidos
	SET Var_TipNotCarRev				:= 1;						-- Tipo de nota de cargo de pagos no reconocidos
	SET Var_LlaveParamCta				:= 'CtaPuenteNotasCargo';	-- Llave parametro para obtener la cuenta puente para notas de cargo de pagos no reconocidos
	SET Var_Procedimiento				:= 'CONTACREDITOPRO';		-- Asignacion del nombre del procedimiento que ejecuta el alta del detalle en poliza
	SET Var_TipoInstCre					:= 11;						-- Tipo de instrumento Credito
	SET Var_ConcApNotaCar				:= 1106;					-- Concepto contable aplicacion nota de cargo
	SET Var_ConActivoNotas				:= 133;						-- Concepto de cartera activo notas de cargo
	SET Var_ConCtaOrdNotas				:= 136;						-- Concepto de cartera cuenta orden notas de cargo
	SET Var_ConCtaCorNotas				:= 137;						-- Concepto de cartera cuenta correlativa notas de cargo

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
										'Disculpe las molestias que esto le ocasiona. Ref: SP-REGISTRONOTASCARGOPRO');
			SET Var_Control = 'sqlException';
		END;

		-- Alta de la nota de cargo
		CALL NOTASCARGOALT (	Par_CreditoID,			Par_AmortizacionID,		Par_TipoNotaCargoID,		Par_Monto,				Par_IVA,
								Par_Motivo,				Par_Capital,			Par_Interes,				Par_IVAInteres,			Par_Moratorio,
								Par_IVAMoratorio,		Par_OtrasComisiones,	Par_IVAComisiones,			Par_TranPagoCredito,	Par_AmortizacionPago,
								Var_SalidaNO,			Par_NumErr,				Par_ErrMen,					Par_EmpresaID,			Aud_Usuario,
								Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,			Aud_NumTransaccion	);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- INICIO Registro contable

		SELECT		FechaSistema
			INTO	Var_FechaSistema
			FROM	PARAMETROSSIS;

		SELECT		FechaSucursal
			INTO	Var_FechaOper
			FROM	SUCURSALES
			WHERE	SucursalID = Aud_Sucursal;

		SET Var_FechaOper	:= IFNULL(Var_FechaOper, Fecha_Vacia);

		CALL DIASFESTIVOSCAL(	Var_FechaOper,		Entero_Cero,		Var_FechaApl,		Var_EsHabil,		Par_EmpresaID,
								Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
								Aud_NumTransaccion);

		SELECT		CRE.ProductoCreditoID,		CRE.ClienteID,			CRE.CuentaID,		CRE.MonedaID,		DES.Clasificacion,
					DES.SubClasifID,			CLI.SucursalOrigen
			INTO	Var_ProdCredID,				Var_ClienteID,			Var_CuentaAhoID,	Var_MonedaID,		Var_ClasifCre,
					Var_SubClasifID,			Var_SucCliente
			FROM	CREDITOS CRE
			INNER JOIN PRODUCTOSCREDITO PRO ON PRO.ProducCreditoID = CRE.ProductoCreditoID
			INNER JOIN DESTINOSCREDITO DES ON DES.DestinoCreID = CRE.DestinoCreID
			INNER JOIN CLIENTES CLI ON CLI.ClienteID = CRE.ClienteID
			WHERE	CRE.CreditoID = Par_CreditoID;

		SET Var_ProdCredID	:= IFNULL(Var_ProdCredID, Entero_Cero);
		SET Var_ClienteID	:= IFNULL(Var_ClienteID, Entero_Cero);
		SET Var_CuentaAhoID	:= IFNULL(Var_CuentaAhoID, Entero_Cero);
		SET Var_MonedaID	:= IFNULL(Var_MonedaID, Entero_Cero);
		SET Var_ClasifCre	:= IFNULL(Var_ClasifCre, Cadena_Vacia);
		SET Var_SubClasifID	:= IFNULL(Var_SubClasifID, Entero_Cero);
		SET Var_SucCliente	:= IFNULL(Var_SucCliente, Entero_Cero);

		SET Var_Referencia	:= CONCAT('Cred.', CAST(Par_CreditoID AS CHAR));
		SET Var_Descripcion	:= 'APLICACION DE NOTA DE CARGO';

		IF (Par_Monto > Entero_Cero) THEN

			-- Generacion de numero de poliza
			CALL MAESTROPOLIZASALT (	Var_PolizaID,		Par_EmpresaID,		Var_FechaSistema,	Var_TipoPolAuto,	Var_ConcApNotaCar,
										Var_Descripcion,	Var_SalidaNO,		Par_NumErr,			Par_ErrMen,			Aud_Usuario,
										Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			IF (Par_TipoNotaCargoID = Var_TipNotCarRev) THEN -- Solo se hace si el tipo de nota de cargo es de pagos no reconocidos

				SELECT		ValorParametro
					INTO	Var_CuentaPuente
					FROM	PARAMGENERALES
					WHERE	LlaveParametro = Var_LlaveParamCta;

				SET Var_CuentaPuente	:= IFNULL(Var_CuentaPuente, Cadena_Vacia);

				IF (Var_CuentaPuente = Cadena_Vacia) THEN
					SET Par_NumErr 	:= 001;
					SET Par_ErrMen	:= 'La cuenta puente para notas de cargo de pagos no reconocidos no esta parametrizada en los parametros generales';
					SET Var_Control := 'controlID';
					LEAVE ManejoErrores;
				END IF;

				SELECT		CuentaCompleta
					INTO	Var_CuentaConta
					FROM	CUENTASCONTABLES
					WHERE	CuentaCompleta	= Var_CuentaPuente;

				SET Var_CuentaConta	:= IFNULL(Var_CuentaConta, Cadena_Vacia);

				IF (Var_CuentaConta = Cadena_Vacia) THEN
					SET Par_NumErr 	:= 002;
					SET Par_ErrMen	:= 'La cuenta puente para notas de cargo de pagos no reconocidos no esta parametrizada en el catalogo de cuentas contables';
					SET Var_Control := 'controlID';
					LEAVE ManejoErrores;
				END IF;

				SELECT		FNCENTROCOSTOS(Aud_Sucursal)
					INTO	Var_CentroCostoID;

				-- Cargo Activo Pago no Reconocido
				CALL CONTACREDITOSPRO	(	Par_CreditoID,			Par_AmortizacionID,		Var_CuentaAhoID,		Var_ClienteID,		Var_FechaOper,
											Var_FechaApl,			Par_Monto,				Var_MonedaID,			Var_ProdCredID,		Var_ClasifCre,
											Var_SubClasifID,		Var_SucCliente,			Var_Descripcion,		Var_Referencia,		Var_AltaPoliza_NO,
											Entero_Cero,			Var_PolizaID,			Var_AltaPolCre_SI,		Var_AltaMovCre_SI,	Var_ConActivoNotas,
											Var_MovNotCarRev,		Var_NatCargo,			Var_AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,
											Cadena_Vacia,			Var_SalidaNO,			Par_NumErr,				Par_ErrMen,			Var_Consecutivo,
											Par_EmpresaID,			Cadena_Vacia,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
											Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion	);

				-- Abono Cuenta Puente
				CALL DETALLEPOLIZAALT (	Par_EmpresaID,					Var_PolizaID,		Var_FechaApl,		Var_CentroCostoID,	Var_CuentaPuente,
										CONVERT(Par_CreditoID, CHAR),	Var_MonedaID,		Entero_Cero,		Par_Monto,			Var_Descripcion,
										Var_Referencia,					Var_Procedimiento,	Var_TipoInstCre,	Cadena_Vacia,		Entero_Cero,
										Cadena_Vacia,					Var_SalidaNO,		Par_NumErr,			Par_ErrMen,			Aud_Usuario,
										Aud_FechaActual,				Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			ELSE

				SELECT		IF (CobraIVA = Var_SalidaSI, Var_MovNotCarCIva, Var_MovNotCarSIva)
					INTO	Var_TipoMovNotCar
					FROM	TIPOSNOTASCARGO
					WHERE	TipoNotaCargoID = Par_TipoNotaCargoID;

				SET Var_TipoMovNotCar	:= IFNULL(Var_TipoMovNotCar, Entero_Cero);

				-- Cargo Corr. Cta. Ord. Nota de Cargo
				CALL CONTACREDITOSPRO	(	Par_CreditoID,			Par_AmortizacionID,		Var_CuentaAhoID,		Var_ClienteID,		Var_FechaOper,
											Var_FechaApl,			Par_Monto,				Var_MonedaID,			Var_ProdCredID,		Var_ClasifCre,
											Var_SubClasifID,		Var_SucCliente,			Var_Descripcion,		Var_Referencia,		Var_AltaPoliza_NO,
											Entero_Cero,			Var_PolizaID,			Var_AltaPolCre_SI,		Var_AltaMovCre_SI,	Var_ConCtaCorNotas,
											Var_TipoMovNotCar,		Var_NatCargo,			Var_AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,
											Cadena_Vacia,			Var_SalidaNO,			Par_NumErr,				Par_ErrMen,			Var_Consecutivo,
											Par_EmpresaID,			Cadena_Vacia,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
											Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion	);

				IF (Par_NumErr <> Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;

				-- Abono Cta. Ord. Nota de Cargo
				CALL CONTACREDITOSPRO	(	Par_CreditoID,			Par_AmortizacionID,		Var_CuentaAhoID,		Var_ClienteID,		Var_FechaOper,
											Var_FechaApl,			Par_Monto,				Var_MonedaID,			Var_ProdCredID,		Var_ClasifCre,
											Var_SubClasifID,		Var_SucCliente,			Var_Descripcion,		Var_Referencia,		Var_AltaPoliza_NO,
											Entero_Cero,			Var_PolizaID,			Var_AltaPolCre_SI,		Var_AltaMovCre_NO,	Var_ConCtaOrdNotas,
											Var_TipoMovNotCar,		Var_NatAbono,			Var_AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,
											Cadena_Vacia,			Var_SalidaNO,			Par_NumErr,				Par_ErrMen,			Var_Consecutivo,
											Par_EmpresaID,			Cadena_Vacia,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
											Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion	);

				IF (Par_NumErr <> Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;

			END IF;

			SELECT		COUNT(PolizaID)
				INTO	Var_ConteoPoliza
				FROM	DETALLEPOLIZA
				WHERE	PolizaID = Var_PolizaID;

			IF (Var_ConteoPoliza > Entero_Dos) THEN
				SET Par_NumErr 	:= 003;
				SET Par_ErrMen	:= 'El numero de registros de movimientos de notas de cargo es incorrecto';
				SET Var_Control := 'controlID';
				LEAVE ManejoErrores;
			END IF;

		END IF;

		-- FIN Registro contable

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= 'Proceso de Registro de Notas de Cargo ejecutado Exitosamente';
		SET Var_Control	:= 'creditoID';
	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida = Var_SalidaSI) THEN
		SELECT	Par_NumErr				AS NumErr,
				Par_ErrMen				AS ErrMen,
				Var_Control				AS control,
				Par_NumErr				AS consecutivo;
	END IF;

END TerminaStore$$