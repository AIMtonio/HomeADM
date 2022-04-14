-- EDOCTAV2RESUMCAPTAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAV2RESUMCAPTAPRO`;
DELIMITER $$

CREATE PROCEDURE `EDOCTAV2RESUMCAPTAPRO`(
	Par_Salida					CHAR(1),
	INOUT Par_NumErr			INT(11),
	INOUT Par_ErrMen			VARCHAR(400),
	Par_EmpresaID				INT(11),					-- Parametro de Auditoria
	Aud_Usuario					INT(11),					-- Parametro de Auditoria
	Aud_FechaActual				DATETIME,					-- Parametro de Auditoria
	Aud_DireccionIP				VARCHAR(15),				-- Parametro de Auditoria
	Aud_ProgramaID				VARCHAR(50),				-- Parametro de Auditoria
	Aud_Sucursal				INT(11),					-- Parametro de Auditoria
	Aud_NumTransaccion			BIGINT(12)					-- Parametro de Auditoria
)
TerminaStore:BEGIN

	-- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		VARCHAR(1);
	DECLARE Fecha_Vacia			DATE;
	DECLARE Constante_Si		CHAR(1);
	DECLARE Entero_Cero			INT(11);
	DECLARE Moneda_Cero			DECIMAL(14,2);
	DECLARE EstatusActiva		CHAR(1);
	DECLARE Tip_CuetaAho		CHAR(2);
	DECLARE Tip_Inversion		CHAR(2);
	DECLARE Tip_Cede			CHAR(2);
	DECLARE TipoProdAhorro		INT(4);
	DECLARE TipoProdCede		INT(4);
	DECLARE TipoProdInvPlazo	INT(4);
	DECLARE TipoProdCredito		INT(4);
	DECLARE EstatusCancelado	CHAR(1);
	DECLARE EstatusBloqueado	CHAR(1);
	DECLARE EstatusInactiva		CHAR(1);
	DECLARE EstatusRegistrada	CHAR(1);
	DECLARE EstInvVigente		CHAR(1);
	DECLARE EstInvPagada		CHAR(1);
	DECLARE EstInvCancelada 	CHAR(1);
	DECLARE EstInvVencida		CHAR(1);
	DECLARE EstCedeVigente		CHAR(1);
	DECLARE EstCedePagada		CHAR(1);
	DECLARE EstCedeCancelada	CHAR(1);
	DECLARE NaturalezaCargo		CHAR(1);
    DECLARE NaturalezaAbono		CHAR(1);
    DECLARE OrigenMovCta        INT(11);
	DECLARE Var_AnioMes			INT(11);					-- VARIABLE QUE SE EXTRAE DE
	DECLARE Var_FolioProceso	BIGINT(12);					-- Folio del preoceso, se generacada ves que se  ejecuta el estado de cuenta
	DECLARE Var_FecIniMes		DATE;						-- FECHA DE INICIO DE MES
	DECLARE Var_FecFinMes		DATE;						-- FECHA DE FIN DE MES
	DECLARE Var_FecCorte		DATE;						-- FECHA DE CORTE DE LA TABLA `HIS-CUENTASAHO`;
	DECLARE Var_ClienteInstitu	INT(11);
	DECLARE Var_Control			VARCHAR(50);

	-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia			:=	'';						-- Cadena Vacia
	SET Fecha_Vacia				:=	'1900-01-01';			-- Fecha Vacia
	SET Constante_Si			:= 'S';
	SET Entero_Cero				:= 	0;						-- Entero Cero
	SET Moneda_Cero				:=	0.00;					-- Decimal Cero
	SET Tip_CuetaAho			:=	'CA';					-- Tipo de Instrumento Cuenta de Ahorro
	SET Tip_Inversion			:=	'IN';					-- Tipo de Instrumento Inversion a Plazo Fijo
	SET Tip_Cede				:=	'CE';					-- Tipo de Instrumento CEDE
	SET TipoProdAhorro			:= 	1;						-- Tipo de Proctos de Ahorro de la tabla EDOCTAV2PRODUCTOS
	SET TipoProdCede			:= 	2;						-- Tipo de Proctos de CEDES de la tabla EDOCTAV2PRODUCTOS
	SET TipoProdInvPlazo		:= 	3;						-- Tipo de Proctos de Inversions de la tabla EDOCTAV2PRODUCTOS
	SET TipoProdCredito			:= 	4;						-- Tipo de Proctos de Credito de la tabla EDOCTAV2PRODUCTOS
	SET EstatusActiva			:=	'A';					-- Estatus de la cuenta: ACTIVA
	SET EstatusCancelado		:=	'C';					-- Estatus de la cuenta: CANCELADA
	SET EstatusBloqueado		:=	'B';					-- Estatus de la cuenta: BLOQUEADA
	SET EstatusInactiva			:=	'I';					-- Estatus de la cuenta: INACTIVA
	SET EstatusRegistrada		:=	'R';					-- Estatus de la cuenta: REGISTRADA
	SET EstInvVigente			:= 	'N';					-- Estatus de la Inversion: Vigente (cargada a cuenta)
	SET EstInvPagada			:= 	'P';					-- Estatus de la Inversion: Pagada (abonada a cuenta)
	SET EstInvCancelada			:= 	'C';					-- Estatus de la Inversion: Cancelada
	SET EstInvVencida			:= 	'V';					-- Estatus de la Cede: Vencida
	SET EstCedeVigente			:= 	'N';					-- Estatus de la Cede: Vigente (cargada a cuenta)
	SET EstCedePagada			:= 	'P';					-- Estatus de la Cede: Pagada (abonada a cuenta)
	SET EstCedeCancelada		:= 	'C';					-- Estatus de la Cede: Cancelada
	SET NaturalezaCargo			:=	'C';					-- Naturaleza de movimiento: CARGO
	SET NaturalezaAbono			:= 'A';						-- Naturaleza de movimiento: ABONO
	SET OrigenMovCta            :=  1;						-- Origen de Movimiento: Cuenta de Ahorro

	ManejoErrores: BEGIN
	 DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-EDOCTAV2RESUMCAPTAPRO');
			SET Var_Control	= 'sqlException';
		END;

	SELECT		MesProceso,		FolioProceso,		FechaInicio,		FechaFin,		ClienteInstitucion
		INTO	Var_AnioMes,	Var_FolioProceso,	Var_FecIniMes,		Var_FecFinMes,	Var_ClienteInstitu
		FROM	EDOCTAV2PARAMS
		LIMIT	1;

	SET Var_FolioProceso 	:= IFNULL(Var_FolioProceso, Entero_Cero);

	
	-- Se obtiene la Fecha Corte del historico de acuerdo al periodo
	SELECT MAX(Fecha)
	INTO Var_FecCorte
	FROM `HIS-CUENTASAHO`
	WHERE Fecha <= Var_FecFinMes;


	DROP TEMPORARY TABLE IF EXISTS TMPEDOCTAHISCUENTAS;
	CREATE TEMPORARY TABLE TMPEDOCTAHISCUENTAS
	SELECT His.*
	FROM EDOCTAV2DATOSCTE Cli
		INNER JOIN `HIS-CUENTASAHO` His ON Cli.ClienteID = His.ClienteID AND His.Fecha = Var_FecCorte AND His.Estatus IN (EstatusActiva, EstatusBloqueado, EstatusCancelado)
		INNER JOIN EDOCTAV2PRODUCTOS PROD ON His.TipoCuentaID = PROD.ProductoID AND PROD.TipoProducto = TipoProdAhorro
	WHERE Cli.FolioProceso = Var_FolioProceso;

	CREATE INDEX IDX_TMPEDOCTAHISCUENTAS_01 ON TMPEDOCTAHISCUENTAS(ClienteID);
	CREATE INDEX IDX_TMPEDOCTAHISCUENTAS_02 ON TMPEDOCTAHISCUENTAS(CuentaAhoID);
	CREATE INDEX IDX_TMPEDOCTAHISCUENTAS_03 ON TMPEDOCTAHISCUENTAS(TipoCuentaID);


	-- Se insertan las cuentas de Ahorro
	 INSERT INTO EDOCTAV2RESUMCAPTA (
			AnioMes,			SucursalID,				ClienteID,			InstrumentoID,		MonedaID,
			MonedaDescri,		Etiqueta,				SaldoPromedio,		SaldoAnterior,		SaldoActual,
			TipoInstrumento,	FolioProceso,			EmpresaID,			Usuario,			FechaActual,
			DireccionIP,		ProgramaID,				Sucursal,			NumTransaccion	)
	SELECT  Var_AnioMes, 		Cta.SucursalID,			Cli.ClienteID,  	Cta.CuentaAhoID,    Cta.MonedaID,
			Cadena_Vacia,		Tc.Descripcion,   		Cta.SaldoProm,		Cta.SaldoIniMes,    Cta.Saldo,
			Tip_CuetaAho,		Var_FolioProceso,		Par_EmpresaID, 		Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion
	FROM EDOCTAV2DATOSCTE Cli
		INNER JOIN TMPEDOCTAHISCUENTAS Cta ON Cli.ClienteID = Cta.ClienteID
		INNER JOIN TIPOSCUENTAS Tc ON Cta.TipoCuentaID = Tc.TipoCuentaID
	WHERE Cli.FolioProceso = Var_FolioProceso;


	-- Se destruye la tabla despues de utilizarla
	DROP TEMPORARY TABLE IF EXISTS TMPEDOCTAHISCUENTAS;


	-- =================================================
	-- =====  INVERSIONES A PLAZO FIJO  ================


	-- Se obtiene la Fecha Corte del historico de acuerdo al periodo
	SET Var_FecCorte = Fecha_Vacia; 	-- se limpia la variable

	SELECT MAX(Inv.FechaCorte)
	INTO Var_FecCorte
	FROM HISINVERSIONES Inv
	WHERE Inv.FechaCorte <= Var_FecFinMes;


	DROP TEMPORARY TABLE IF EXISTS TMPEDOCTAHISINVERSIONES;
	CREATE TEMPORARY TABLE TMPEDOCTAHISINVERSIONES
	SELECT His.*
	FROM EDOCTAV2DATOSCTE Cli
		INNER JOIN HISINVERSIONES His ON Cli.ClienteID = His.ClienteID AND His.FechaCorte = Var_FecCorte
										AND ( His.Estatus = EstInvVigente 	OR (His.Estatus = EstInvPagada AND His.FechaVencimiento >= Var_FecIniMes AND His.FechaVencimiento <= Var_FecFinMes )
																			OR (His.Estatus = EstInvCancelada AND His.FechaVenAnt >= Var_FecIniMes AND His.FechaVenAnt <= Var_FecFinMes )
											)
		INNER JOIN EDOCTAV2PRODUCTOS PROD ON His.TipoInversionID = PROD.ProductoID AND PROD.TipoProducto = TipoProdInvPlazo
	WHERE Cli.FolioProceso = Var_FolioProceso;

	CREATE INDEX IDX_TMPEDOCTAHISINVERSIONES_01 ON TMPEDOCTAHISINVERSIONES(ClienteID);
	CREATE INDEX IDX_TMPEDOCTAHISINVERSIONES_02 ON TMPEDOCTAHISINVERSIONES(InversionID);
	CREATE INDEX IDX_TMPEDOCTAHISINVERSIONES_03 ON TMPEDOCTAHISINVERSIONES(TipoInversionID);


	INSERT INTO EDOCTAV2RESUMCAPTA (
			AnioMes,			SucursalID,				ClienteID,			InstrumentoID,		MonedaID,
			MonedaDescri,		Etiqueta,				SaldoPromedio,		SaldoAnterior,		SaldoActual,
			TipoInstrumento,	FolioProceso,			EmpresaID,			Usuario,			FechaActual,
			DireccionIP,		ProgramaID,				Sucursal,			NumTransaccion	)
	SELECT  Var_AnioMes, 		Entero_Cero,			Cli.ClienteID,  	Inv.InversionID,    Inv.MonedaID,
			Cadena_Vacia,		Prod.Descripcion,
			CASE WHEN Inv.FechaInicio < Var_FecIniMes AND Inv.Estatus = EstInvVigente   THEN Inv.Monto
				 WHEN Inv.FechaInicio < Var_FecIniMes AND Inv.Estatus = EstInvPagada    THEN ROUND( ( Inv.Monto * DAY(Inv.FechaVencimiento) )/ DAY(Var_FecFinMes), 2)
				 WHEN Inv.FechaInicio < Var_FecIniMes AND Inv.Estatus = EstInvCancelada THEN ROUND( ( Inv.Monto * DAY(Inv.FechaVenAnt) )/ DAY(Var_FecFinMes), 2)

				 WHEN Inv.FechaInicio >= Var_FecIniMes AND Inv.Estatus = EstInvVigente   THEN Inv.Monto
				 WHEN Inv.FechaInicio >= Var_FecIniMes AND Inv.Estatus = EstInvPagada    THEN ROUND( ( Inv.Monto * DATEDIFF(Inv.FechaVencimiento, Inv.FechaInicio) )/ (DATEDIFF(Var_FecFinMes, Inv.FechaInicio) + 1), 2)
				 WHEN Inv.FechaInicio >= Var_FecIniMes AND Inv.Estatus = EstInvCancelada THEN ROUND( ( Inv.Monto * DATEDIFF(Inv.FechaVenAnt, Inv.FechaInicio) )/ (DATEDIFF(Var_FecFinMes, Inv.FechaInicio) + 1), 2)
			END AS SaldoProm,
			CASE WHEN Inv.FechaInicio < Var_FecIniMes THEN Inv.Monto ELSE Entero_Cero END AS SaldoAnterior,
			CASE WHEN Inv.Estatus = EstInvVigente 	  THEN Inv.Monto ELSE Entero_Cero END AS SaldoActual,
			Tip_Inversion,		Var_FolioProceso,		Par_EmpresaID, 		Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion
	FROM EDOCTAV2DATOSCTE Cli
		INNER JOIN TMPEDOCTAHISINVERSIONES Inv ON Cli.ClienteID = Inv.ClienteID
		INNER JOIN CATINVERSION Prod ON Inv.TipoInversionID = Prod.TipoInversionID
	WHERE Cli.FolioProceso = Var_FolioProceso;


	-- se Actualiza la sucursal de Inversiones a plazo con la fecha de auditoria de la tabla de inversiones
	-- Ya que de momento no se tiene un Campo para la sucursal donde se creo la Inversion
	UPDATE EDOCTAV2RESUMCAPTA Res
		INNER JOIN INVERSIONES Inv ON Res.InstrumentoID = Inv.InversionID
	SET SucursalID = DATE(Inv.FechaActual)
	WHERE Res.FolioProceso = Var_FolioProceso
	  AND TipoInstrumento = Tip_Inversion;




	DROP TEMPORARY TABLE IF EXISTS TMPEDOCTAHISINVERSIONES;



	-- =================================================
	-- =====  CEDES  ================


	DROP TEMPORARY TABLE IF EXISTS TMPEDOCTACEDES;
	CREATE TEMPORARY TABLE TMPEDOCTACEDES
	SELECT His.*
	FROM EDOCTAV2DATOSCTE Cli
		INNER JOIN CEDES His ON Cli.ClienteID = His.ClienteID
							  AND His.FechaInicio <= Var_FecFinMes
							  AND ( His.Estatus = EstCedeVigente OR (His.Estatus = EstCedePagada AND His.FechaVencimiento >= Var_FecIniMes AND His.FechaVencimiento <= Var_FecFinMes )
																OR (His.Estatus = EstCedeCancelada AND His.FechaVenAnt >= Var_FecIniMes AND His.FechaVenAnt <= Var_FecFinMes )
											)
		INNER JOIN EDOCTAV2PRODUCTOS PROD ON His.TipoCedeID = PROD.ProductoID AND PROD.TipoProducto = TipoProdCede
	WHERE Cli.FolioProceso = Var_FolioProceso;

	CREATE INDEX IDX_TMPEDOCTACEDES_01 ON TMPEDOCTACEDES(ClienteID);
	CREATE INDEX IDX_TMPEDOCTACEDES_02 ON TMPEDOCTACEDES(CedeID);
	CREATE INDEX IDX_TMPEDOCTACEDES_03 ON TMPEDOCTACEDES(TipoCedeID);


	INSERT INTO EDOCTAV2RESUMCAPTA (
			AnioMes,			SucursalID,				ClienteID,			InstrumentoID,		MonedaID,
			MonedaDescri,		Etiqueta,				SaldoPromedio, 		SaldoAnterior,		SaldoActual,
			TipoInstrumento,	FolioProceso,			EmpresaID,			Usuario,			FechaActual,
			DireccionIP,		ProgramaID,				Sucursal,			NumTransaccion	)
	SELECT  Var_AnioMes, 		Ced.SucursalID,			Cli.ClienteID,  	Ced.CedeID,   		 Ced.MonedaID,
			Cadena_Vacia,		Prod.Descripcion,
			CASE WHEN Ced.FechaInicio < Var_FecIniMes AND Ced.Estatus = EstCedeVigente   THEN Ced.Monto
				 WHEN Ced.FechaInicio < Var_FecIniMes AND Ced.Estatus = EstCedePagada    THEN ROUND( ( Ced.Monto * DAY(Ced.FechaVencimiento) )/ DAY(Var_FecFinMes), 2)
				 WHEN Ced.FechaInicio < Var_FecIniMes AND Ced.Estatus = EstCedeCancelada THEN ROUND( ( Ced.Monto * DAY(Ced.FechaVenAnt) )/ DAY(Var_FecFinMes), 2)

				 WHEN Ced.FechaInicio >= Var_FecIniMes AND Ced.Estatus = EstCedeVigente   THEN Ced.Monto
				 WHEN Ced.FechaInicio >= Var_FecIniMes AND Ced.Estatus = EstCedePagada    THEN ROUND( ( Ced.Monto * DATEDIFF(Ced.FechaVencimiento, Ced.FechaInicio) )/ (DATEDIFF(Var_FecFinMes, Ced.FechaInicio) + 1), 2)
				 WHEN Ced.FechaInicio >= Var_FecIniMes AND Ced.Estatus = EstCedeCancelada THEN ROUND( ( Ced.Monto * DATEDIFF(Ced.FechaVenAnt, Ced.FechaInicio) )/ (DATEDIFF(Var_FecFinMes, Ced.FechaInicio) + 1), 2)
			END AS SaldoProm,
			CASE WHEN Ced.FechaInicio < Var_FecIniMes THEN Ced.Monto ELSE Entero_Cero END AS SaldoAnterior,
			CASE WHEN Ced.Estatus = EstCedeVigente 	  THEN Ced.Monto ELSE Entero_Cero END AS SaldoActual,
			Tip_Cede,			Var_FolioProceso,		Par_EmpresaID, 		Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion
	FROM EDOCTAV2DATOSCTE Cli
		INNER JOIN TMPEDOCTACEDES Ced ON Cli.ClienteID = Ced.ClienteID
		INNER JOIN TIPOSCEDES Prod ON Ced.TipoCedeID = Prod.TipoCedeID
	WHERE Cli.FolioProceso = Var_FolioProceso;


	DROP TEMPORARY TABLE IF EXISTS TMPEDOCTACEDES;


	-- Se acutaliza la Descripcion del Tipo de Moneda de Cuentas, Inversiones y Cedes
	UPDATE EDOCTAV2RESUMCAPTA AS Edo
    	INNER JOIN MONEDAS Mon ON Mon.MonedaId = Edo.MonedaID
    SET Edo.MonedaDescri = Mon.Descripcion
    WHERE Edo.FolioProceso = Var_FolioProceso;


    SET Par_NumErr	:= Entero_Cero;
	SET Par_ErrMen	:= CONCAT('Resumen de Captacion Terminado exitosamente con Folio: ', CAST(Var_FolioProceso AS CHAR));
	SET Var_Control	:= 'EDOCTAV2RESUMCAPTAPRO';

	END ManejoErrores;

	IF (Par_Salida = Constante_Si) THEN
		SELECT	Par_NumErr			AS NumErr,
				Par_ErrMen			AS ErrMen,
				Var_FolioProceso	AS control;
	END IF;


END TerminaStore$$
