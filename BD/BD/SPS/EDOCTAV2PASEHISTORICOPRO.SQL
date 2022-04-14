-- EDOCTAV2PASEHISTORICOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAV2PASEHISTORICOPRO`;
DELIMITER $$

CREATE PROCEDURE `EDOCTAV2PASEHISTORICOPRO`(
	-- SP PARA GUARDAR LA INFORMACION DE LAS TABLAS DE EXTRACCION DEL ESTADO DE CUENTA BIENESTAR EN TABLAS DE HISTORICO
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
	-- DECLARACION DE VARIABLES
	DECLARE Var_Control					VARCHAR(50);		-- Variable para control de excepciones

	-- DECLARACION DE CONSTANTES
	DECLARE	Cadena_Vacia				VARCHAR(1);			-- Cadena Vacia
	DECLARE	Fecha_Vacia					DATE;				-- Fecha Vacia
	DECLARE	Entero_Cero					INT(11);			-- Entero Cero
	DECLARE Entero_Uno					INT(1);				-- Entero Uno
	DECLARE Var_SI						CHAR(1);			-- Etiquete Si

	-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia					:= '';				-- Cadena Vacia
	SET Fecha_Vacia						:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero						:= 0;				-- Entero Cero
	SET Entero_Uno						:= 1;				-- Entero Uno
	SET Var_SI							:= 'S';				-- Etiquete Si

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-EDOCTAV2PASEHISTORICOPRO');
			SET Var_Control = 'sqlException';
		END;

		-- HISTORICO DATOS CLIENTE
		INSERT INTO `HIS-EDOCTAV2DATOSCTE` (	AnioMes,				SucursalID,			ClienteID,		NombreSucursalCte,		TipoPer,
												TipoPersona,			Calle,				NumInt,			NumExt,					Colonia,
												MunicipioDelegacion,	Localidad,			Estado,			CodigoPostal,			RFC,
												DireccionCompleta,		FechaGeneracion,	RegHacienda,	ComisionTotalAhorro,	ComisionTotalCredito,
												PDFGenerado,			FolioProceso,		EmpresaID,		Usuario,				FechaActual,
												DireccionIP,			ProgramaID,			Sucursal,		NumTransaccion	)
									SELECT		AnioMes,				SucursalID,			ClienteID,		NombreSucursalCte,		TipoPer,
												TipoPersona,			Calle,				NumInt,			NumExt,					Colonia,
												MunicipioDelegacion,	Localidad,			Estado,			CodigoPostal,			RFC,
												DireccionCompleta,		FechaGeneracion,	RegHacienda,	ComisionTotalAhorro,	ComisionTotalCredito,
												PDFGenerado,			FolioProceso,		EmpresaID,		Usuario,				FechaActual,
												DireccionIP,			ProgramaID,			Sucursal,		NumTransaccion
										FROM	EDOCTAV2DATOSCTE;

		-- HISTORICO RESUMEN CAPTACION
		INSERT INTO `HIS-EDOCTAV2RESUMCAPT`	(	AnioMes,			ClienteID,			SucursalID,		InstrumentoID,		MonedaID,
												MonedaDescri,		Etiqueta,			SaldoPromedio,	SaldoAnterior,		SaldoActual,
												TipoInstrumento,	FolioProceso,		EmpresaID,		Usuario,			FechaActual,
												DireccionIP,		ProgramaID,			Sucursal,		NumTransaccion	)
									SELECT		AnioMes,			ClienteID,			SucursalID,		InstrumentoID,		MonedaID,
												MonedaDescri,		Etiqueta,			SaldoPromedio,	SaldoAnterior,		SaldoActual,
												TipoInstrumento,	FolioProceso,		EmpresaID,		Usuario,			FechaActual,
												DireccionIP,		ProgramaID,			Sucursal,		NumTransaccion
										FROM	EDOCTAV2RESUMCAPTA;


		-- HISTORICO RESUMEN CREDITO
		INSERT INTO `HIS-EDOCTAV2RESUMCRED`	(	AnioMes,			SucursalID,			ClienteID,		CreditoID,			Producto,
												SaldoInsoluto,		FechaProxPago,		FechaLeyenda,	MontoProximoPago,	FolioProceso,
												EmpresaID,			Usuario,			FechaActual,	DireccionIP,		ProgramaID,
												Sucursal,			NumTransaccion	)
									SELECT		AnioMes,			SucursalID,			ClienteID,		CreditoID,			Producto,
												SaldoInsoluto,		FechaProxPago,		FechaLeyenda,	MontoProximoPago,	FolioProceso,
												EmpresaID,			Usuario,			FechaActual,	DireccionIP,		ProgramaID,
												Sucursal,			NumTransaccion
										FROM	EDOCTAV2RESUMCREDITOS;

		-- HISTORICO AHORRO Header
		INSERT INTO `HIS-EDOCTAV2HEADERCTA`	(	AnioMes,			ClienteID,			SucursalID,		CuentaAhoID,		ProductoDesc,
												Clabe,				SaldoMinimo,		ISRRetenido,	GatNominal,			GatReal,
												TasaBruta,			InteresPerido,		MontoComision,	IvaComision,		MonedaID,
												MonedaDescri,		DepositosMes,		RetirosMes,		Estatus,			FolioProceso,
												EmpresaID,			Usuario,			FechaActual,	DireccionIP,		ProgramaID,
												Sucursal,			NumTransaccion	)
									SELECT		AnioMes,			ClienteID,			SucursalID,		CuentaAhoID,		ProductoDesc,
												Clabe,				SaldoMinimo,		ISRRetenido,	GatNominal,			GatReal,
												TasaBruta,			InteresPerido,		MontoComision,	IvaComision,		MonedaID,
												MonedaDescri,		DepositosMes,		RetirosMes,		Estatus,			FolioProceso,
												EmpresaID,			Usuario,			FechaActual,	DireccionIP,		ProgramaID,
												Sucursal,			NumTransaccion
										FROM	EDOCTAV2HEADERCTA;

		-- HISTORICO AHORRO Detalle
		INSERT INTO `HIS-EDOCTAV2DETACTA`	(	AnioMes,			ClienteID,			SucursalID,		CuentaAhoID,		FechaMovimiento,
												Referencia,			Concepto,			Cargo,			Abono,				Orden,
												FolioProceso,		EmpresaID,			Usuario,		FechaActual,		DireccionIP,
												ProgramaID,			Sucursal,			NumTransaccion	)
									SELECT		AnioMes,			ClienteID,			SucursalID,		CuentaAhoID,		FechaMovimiento,
												Referencia,			Concepto,			Cargo,			Abono,				Orden,
												FolioProceso,		EmpresaID,			Usuario,		FechaActual,		DireccionIP,
												ProgramaID,			Sucursal,			NumTransaccion
										FROM	EDOCTAV2DETACTA;

		-- HISTORICO CEDES Header

		-- HISTORICO CEDES Detalle

		-- HISTORICO CREDITO Header
		INSERT INTO `HIS-EDOCTAV2HEADERCRE`	(	AnioMes,			SucursalID,			ClienteID,			CreditoID,			ProducCreditoID,
												NombreProducto,		ImporteCredito,		FechaVencimiento,	SaldoInsoluto,		SaldoInicial,
												PagoAmortizaciones,	CAT,				TasaOrdinaria,		TasaMoratoria,		InteresPagados,
												MontTotalComPag,	IVATotalComPag,		FechaProxPag,		CapitalProxpago,	InteresProxPago,
												IvaProxPago,		FolioProceso,		EmpresaID,			Usuario,			FechaActual,
												DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion	)
									SELECT		AnioMes,			SucursalID,			ClienteID,			CreditoID,			ProducCreditoID,
												NombreProducto,		ImporteCredito,		FechaVencimiento,	SaldoInsoluto,		SaldoInicial,
												PagoAmortizaciones,	CAT,				TasaOrdinaria,		TasaMoratoria,		InteresPagados,
												MontTotalComPag,	IVATotalComPag,		FechaProxPag,		CapitalProxpago,	InteresProxPago,
												IvaProxPago,		FolioProceso,		EmpresaID,			Usuario,			FechaActual,
												DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion
										FROM	EDOCTAV2HEADERCRED;

		-- HISTORICO CREDITO Detalle
		INSERT INTO `HIS-EDOCTAV2DETCRE`	(	AnioMes,			ClienteID,			SucursalID,			CreditoID,			FechaOperacion,
												Referencia,			Concepto,			Cargos,				Abonos,				Orden,
												FolioProceso,		EmpresaID,			Usuario,			FechaActual,		DireccionIP,
												ProgramaID,			Sucursal,			NumTransaccion	)
									SELECT		AnioMes,			ClienteID,			SucursalID,			CreditoID,			FechaOperacion,
												Referencia,			Concepto,			Cargos,				Abonos,				Orden,
												FolioProceso,		EmpresaID,			Usuario,			FechaActual,		DireccionIP,
												ProgramaID,			Sucursal,			NumTransaccion
										FROM	EDOCTAV2DETCRE;

		-- HISTORICO CARGOS OBJETADOS
		INSERT INTO `HIS-EDOCTAV2CAROBJETADOS`	(	AnioMes,			SucursalID,			ClienteID,		Instrumento,		FechaIncidencia,
													Descripcion,		MontoObjetado,		FechaReporte,	CargoObjetadoID,	FolioProceso,
													EmpresaID,			Usuario,			FechaActual,	DireccionIP,		ProgramaID,
													Sucursal,			NumTransaccion	)
										SELECT		AnioMes,			SucursalID,			ClienteID,		Instrumento,		FechaIncidencia,
													Descripcion,		MontoObjetado,		FechaReporte,	CargoObjetadoID,	FolioProceso,
													EmpresaID,			Usuario,			FechaActual,	DireccionIP,		ProgramaID,
													Sucursal,			NumTransaccion
											FROM	EDOCTAV2CAROBJETADOS;

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= 'Proceso de Pase a Historico del Estado de Cuenta Ejecutado con Exito';
		SET Var_Control	:= Cadena_Vacia;

	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida = Var_SI) THEN
		SELECT	Par_NumErr				AS NumErr,
				Par_ErrMen				AS ErrMen,
				Var_Control				AS control;
	END IF;

END TerminaStore$$