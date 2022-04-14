-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTARESUMCREDITOS000PRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTARESUMCREDITOS000PRO`;
DELIMITER $$


CREATE PROCEDURE `EDOCTARESUMCREDITOS000PRO`(
	-- SP que genera informacion de Resumen de Creditos para el estado de cuenta
    Par_AnioMes     INT(11),
    Par_SucursalID  INT(11),
    Par_FecIniMes   DATE,
    Par_FecFinMes   DATE
	)

TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_FechaCorte		    DATE;
	DECLARE Var_TipoCapital         INT(11);
	DECLARE Var_TipoInteres         INT(11);
	DECLARE Var_TipoMoratorio       INT(11);
	DECLARE Var_TipoComFaltaPago    INT(11);

    DECLARE Var_TipoOtrasComisiones INT(11);
	DECLARE Var_TipoIVAs            INT(11);
	DECLARE Var_FechaIniAnterior    DATE;
	DECLARE Var_FechaCorteAnterior  DATE;
	DECLARE Var_DiasPeriodo		INT(11);

	DECLARE Var_MonedaID		INT(11);

	-- Declaracion de Constantes
	DECLARE Con_Cadena_Vacia    VARCHAR(1);
	DECLARE Con_Fecha_Vacia     DATE;
	DECLARE Con_Entero_Cero     INT(11);
	DECLARE Con_Moneda_Cero     DECIMAL(14,2);
	DECLARE Con_SI				CHAR(1);

    DECLARE Con_NO				CHAR(1);
	DECLARE EstatusVigente		CHAR(1);
	DECLARE EstatusVencido		CHAR(1);
	DECLARE EstatusCastigado 	CHAR(1);
	DECLARE EstatusPagado 		CHAR(1);

    DECLARE EstatusAtrasado 	CHAR(1);
	DECLARE NatAbono			CHAR(1);
    DECLARE TipoCobMoraTasa		CHAR(1);
	DECLARE TipoCobMoraNveces	CHAR(1);

	-- Asignacion de Constantes
	SET Con_Cadena_Vacia	:= '';				-- Cadena vacia
	SET Con_Fecha_Vacia		:= '1900-01-01';	-- Fecha vacia
	SET Con_Entero_Cero		:= 0;				-- Entero cero
	SET Con_Moneda_Cero		:= 0.00;			-- Moneda cero
	SET Con_SI				:= 'S';				-- Constante: SI

	SET Con_NO				:= 'N';				-- Constante: NO
	SET EstatusVigente		:= 'V';				-- Estatus Credito: VIGENTE
	SET EstatusVencido		:= 'B';				-- Estatus Credito: VENCIDO
	SET EstatusCastigado 	:= 'K';				-- Estatus Credito: CASTIGADO
	SET EstatusPagado 		:= 'P';				-- Estatus Credito: PAGADO

	SET EstatusAtrasado		:= 'A';				-- Estatus Credito: ATRASADO
	SET NatAbono			:= 'A';				-- Naturaleza de movimiento: Abono
	SET TipoCobMoraTasa		:= 'T';				-- Tipo Cobra Moratorio: Tasa Fija Anualizada
	SET TipoCobMoraNveces	:= 'N';				-- Tipo Cobra Moratorio: N veces Tasa Ordinaria

	SET Var_TipoCapital 		:= 1;			-- Tipo Pago: Capital
	SET Var_TipoInteres 		:= 2;			-- Tipo Pago: Interes
	SET Var_TipoMoratorio 		:= 3;			-- Tipo Pago: Interes Moratorio
	SET Var_TipoComFaltaPago 	:= 4;			-- Tipo Pago: Comision
	SET Var_TipoOtrasComisiones := 5;			-- Tipo Pago: Otras Comisiones
	SET Var_TipoIVAs 			:= 6;			-- Tipo Pago: IVA

	SET Var_MonedaID := (SELECT MonedaBaseID FROM PARAMETROSSIS);

	-- Se obtiene la fecha inicial anterior
	SET Var_FechaIniAnterior := DATE_ADD(Par_FecIniMes,INTERVAL -1 MONTH);

	-- se obtiene la fecha de corte en SALDOSCREDITOS
	SET Var_FechaCorteAnterior := (SELECT MAX(FechaCorte)
							FROM SALDOSCREDITOS
							 WHERE FechaCorte >= Var_FechaIniAnterior AND FechaCorte < Par_FecIniMes);


	SET Var_FechaCorte:= (SELECT MAX(FechaCorte)
							FROM SALDOSCREDITOS
							 WHERE FechaCorte >= Par_FecIniMes AND FechaCorte <= Par_FecFinMes);

	DROP TABLE IF EXISTS TMP_EDOCTAPROXPAGO;
	CREATE TABLE `TMP_EDOCTAPROXPAGO` (
	  `Credito`   BIGINT(12) NOT NULL COMMENT 'Id del Credito',
	  `FechaPago` DATE DEFAULT NULL COMMENT 'FechaProximoPago',
	  PRIMARY KEY (`Credito`)
	);

	DROP TABLE IF EXISTS TMP_EDOCTADETALLEPAGCRE;
	CREATE TABLE `TMP_EDOCTADETALLEPAGCRE` (
	  `CreditoID` BIGINT(12) NOT NULL COMMENT 'Id del Credito',
	  `MontoTotPago` DECIMAL(18,2) DEFAULT NULL COMMENT 'Monto Total del Pago APLICADO',
	  `MontoCapOrd` DECIMAL(18,2) DEFAULT NULL COMMENT 'Monto Aplicado Capital Ordinario',
	  `MontoCapAtr` DECIMAL(18,2) DEFAULT NULL COMMENT 'Monto Aplicado Capital Atrasado',
	  `MontoCapVen` DECIMAL(18,2) DEFAULT NULL COMMENT 'Monto Aplicado Capital Vencido',
	  `MontoIntOrd` DECIMAL(18,2) DEFAULT NULL COMMENT 'Monto Aplicado Interes Ordinario',
	  `MontoIntAtr` DECIMAL(18,2) DEFAULT NULL COMMENT 'Monto Aplicado Interes Atrasado',
	  `MontoIntVen` DECIMAL(18,2) DEFAULT NULL COMMENT 'Monto Aplicado Interes Vencido',

	  `MontoIntMora` DECIMAL(18,2) DEFAULT NULL COMMENT 'Monto Aplicado Interes Mora',
	  `MontoIVA` DECIMAL(18,2) DEFAULT NULL COMMENT 'Monto Aplicado IVA',
	  `MontoComision` DECIMAL(18,2) DEFAULT NULL COMMENT 'Monto Aplicado Comisiones',
	  `MontoGastoAdmon` DECIMAL(18,2) DEFAULT NULL COMMENT 'Monto de Gastos de Administracion.\nLiquidacion Anticipada, Finiquito',
	  PRIMARY KEY (`CreditoID`)
	) ;


	SET Var_DiasPeriodo := (SELECT DATEDIFF(Par_FecFinMes, Par_FecIniMes) + 1);
	UPDATE EDOCTADATOSCTE
	SET DiasPeriodo = IFNULL(Var_DiasPeriodo, Con_Cadena_Vacia);


	INSERT INTO EDOCTARESUMCREDITOS
	SELECT  Par_AnioMes,    	Par_SucursalID,     	ClienteID,    		CreditoID,  		1 AS Orden,
			Con_Moneda_Cero,	Con_Moneda_Cero,		Con_Moneda_Cero,	Con_Moneda_Cero,	Con_Moneda_Cero,
			Con_Moneda_Cero,	Con_Moneda_Cero,		Con_Moneda_Cero,	Con_Moneda_Cero,	Con_Moneda_Cero,
			Con_Moneda_Cero,	Con_Moneda_Cero,		Con_Moneda_Cero,	Con_Cadena_Vacia,	Var_MonedaID,
			Con_Cadena_Vacia,	Con_Cadena_Vacia,		Con_Cadena_Vacia,	Con_Moneda_Cero,	Con_Moneda_Cero,
			Con_Cadena_Vacia,	Con_Cadena_Vacia,		Con_Moneda_Cero,	Con_Moneda_Cero,	Con_Moneda_Cero,
			Con_Moneda_Cero,	FechaVencimien,			Con_Fecha_Vacia,	Con_Moneda_Cero,	Con_Moneda_Cero,
			Con_Moneda_Cero,	Con_Moneda_Cero,		Con_Moneda_Cero,	Con_Moneda_Cero,	Con_Moneda_Cero,
			Con_Moneda_Cero,	Con_Moneda_Cero,   		Con_Moneda_Cero,  	Con_Cadena_Vacia,	Con_Cadena_Vacia,
			Con_Cadena_Vacia
	FROM CREDITOS
	WHERE Estatus IN (EstatusVigente, EstatusVencido, EstatusCastigado)
	   OR (Estatus = EstatusPagado
			AND  FechTerminacion >= Par_FecIniMes
			AND  FechTerminacion <= Par_FecFinMes );


	UPDATE EDOCTARESUMCREDITOS Edo, CREDITOS Cre, PRODUCTOSCREDITO Prod, CLIENTES Cli, SUCURSALES Suc
	SET Edo.ValorIVAInt = CASE WHEN Prod.CobraIVAInteres = Con_SI AND Cli.PagaIVA = Con_SI THEN IFNULL(Suc.IVA, Con_Moneda_Cero)
							   WHEN Prod.CobraIVAInteres = Con_SI AND Cli.PagaIVA = Con_NO THEN Con_Moneda_Cero
							   WHEN Prod.CobraIVAInteres = Con_NO AND Cli.PagaIVA = Con_SI THEN Con_Moneda_Cero
							   WHEN Prod.CobraIVAInteres = Con_NO AND Cli.PagaIVA = Con_NO THEN Con_Moneda_Cero
																					 ELSE Con_Moneda_Cero
						   END,
		Edo.ValorIVAMora = CASE WHEN Prod.CobraIVAInteres = Con_SI AND Cli.PagaIVA = Con_SI THEN IFNULL(Suc.IVA, Con_Moneda_Cero)
							   WHEN Prod.CobraIVAInteres = Con_SI AND Cli.PagaIVA = Con_NO THEN Con_Moneda_Cero
							   WHEN Prod.CobraIVAInteres = Con_NO AND Cli.PagaIVA = Con_SI THEN Con_Moneda_Cero
							   WHEN Prod.CobraIVAInteres = Con_NO AND Cli.PagaIVA = Con_NO THEN Con_Moneda_Cero
																					 ELSE Con_Moneda_Cero
						   END,
		Edo.ValorIVAAccesorios = CASE WHEN Cli.PagaIVA = Con_SI THEN IFNULL(Suc.IVA, Con_Moneda_Cero)
															 ELSE Con_Moneda_Cero
								 END
	WHERE Edo.CreditoID = Cre.CreditoID
	  AND Prod.ProducCreditoID = Cre.ProductoCreditoID
	  AND Edo.ClienteID = Cli.ClienteID
	  AND Cli.SucursalOrigen = Suc.SucursalID;


	UPDATE EDOCTARESUMCREDITOS Edo, SALDOSCREDITOS Sal
	SET Edo.SaldoMesAnterior = IFNULL((Sal.SalCapVigente + Sal.SalCapatrasado +
	Sal.SalCapVencido + Sal.SalCapVenNoExi), Con_Moneda_Cero)
	WHERE Sal.FechaCorte = Var_FechaCorteAnterior
	  AND Edo.CreditoID = Sal.CreditoID
	  AND Edo.Orden = 1;


	INSERT INTO EDOCTARESUMCREDITOS
	SELECT 	Par_AnioMes,    				Edo.SucursalID,     			Edo.ClienteID,    				Edo.CreditoID, 					2 AS Orden,
			Edo.SaldoMesAnterior,			Con_Moneda_Cero AS Capital,		Con_Moneda_Cero AS Interes,		Con_Moneda_Cero AS Moratorio,	Con_Moneda_Cero AS ComFaltaPago,
			Con_Moneda_Cero AS GastoAdmon,	Con_Moneda_Cero AS OtrasCom,	Con_Moneda_Cero AS IVAS,		Edo.ValorIVAInt ,				Edo.ValorIVAMora,
			Edo.ValorIVAAccesorios,			Con_Moneda_Cero,				Con_Moneda_Cero,				Con_Cadena_Vacia,				Var_MonedaID,
			Con_Cadena_Vacia,				Con_Cadena_Vacia,				Con_Cadena_Vacia,				Con_Moneda_Cero,				Con_Moneda_Cero,
			Con_Cadena_Vacia,				Con_Cadena_Vacia,				Con_Moneda_Cero,				Con_Moneda_Cero,				Con_Moneda_Cero,
			Con_Moneda_Cero,				FechaVencimiento,				Con_Fecha_Vacia,				Edo.InteresaPagar,				Edo.Comisiones,
			Con_Moneda_Cero,				Con_Moneda_Cero,				Con_Moneda_Cero,				Con_Moneda_Cero,				Con_Moneda_Cero,
			Con_Moneda_Cero,				Con_Moneda_Cero,   				Con_Moneda_Cero,  				Con_Cadena_Vacia,				Con_Cadena_Vacia,
			Con_Cadena_Vacia
	FROM EDOCTARESUMCREDITOS Edo
	WHERE Edo.Orden = 1;


	INSERT INTO EDOCTARESUMCREDITOS
	SELECT 	Par_AnioMes,    				Edo.SucursalID,     			Edo.ClienteID,    				Edo.CreditoID, 					3 AS Orden,
			Edo.SaldoMesAnterior,			Con_Moneda_Cero AS Capital,		Con_Moneda_Cero AS Interes,		Con_Moneda_Cero AS Moratorio,	Con_Moneda_Cero AS ComFaltaPago,
			Con_Moneda_Cero AS GastoAdmon,	Con_Moneda_Cero AS OtrasCom,	Con_Moneda_Cero AS IVAS,		Edo.ValorIVAInt,				Edo.ValorIVAMora,
			Edo.ValorIVAAccesorios,			Con_Moneda_Cero,				Con_Moneda_Cero,				Con_Cadena_Vacia,				Var_MonedaID,
            Con_Cadena_Vacia,				Con_Cadena_Vacia,				Con_Cadena_Vacia,				Con_Moneda_Cero,				Con_Moneda_Cero,
			Con_Cadena_Vacia,				Con_Cadena_Vacia,				Con_Moneda_Cero,				Con_Moneda_Cero,				Con_Moneda_Cero,
			Con_Moneda_Cero,				FechaVencimiento,				Con_Fecha_Vacia,				Edo.InteresaPagar,				Edo.Comisiones,
			Con_Moneda_Cero,				Con_Moneda_Cero,				Con_Moneda_Cero,				Con_Moneda_Cero,				Con_Moneda_Cero,
			Con_Moneda_Cero,				Con_Moneda_Cero,   				Con_Moneda_Cero,  				Con_Cadena_Vacia,
			Con_Cadena_Vacia,				Con_Cadena_Vacia
	FROM EDOCTARESUMCREDITOS Edo
	WHERE Edo.Orden = 1;


	INSERT INTO TMP_EDOCTADETALLEPAGCRE
	SELECT	 CreditoID
			,SUM(MontoTotPago) AS MontoTotPago
			,SUM(MontoCapOrd) AS MontoCapOrd
			,SUM(MontoCapAtr) AS MontoCapAtr
			,SUM(MontoCapVen) AS MontoCapVen
			,SUM(MontoIntOrd) AS MontoIntOrd
			,SUM(MontoIntAtr) AS MontoIntAtr
			,SUM(MontoIntVen) AS MontoIntVen
			,SUM(MontoIntMora) AS MontoIntMora
			,SUM(MontoIVA) AS MontoIVA
			,SUM(MontoComision) AS MontoComision
			,SUM(MontoGastoAdmon) AS MontoGastoAdmon
	FROM DETALLEPAGCRE
	WHERE FechaPago >= Par_FecIniMes
	AND FechaPago <=  Par_FecFinMes
	GROUP BY CreditoID;


	UPDATE  EDOCTARESUMCREDITOS Res, TMP_EDOCTADETALLEPAGCRE Tmp
	SET     Res.Capital = ROUND((Tmp.MontoCapOrd + Tmp.MontoCapAtr + Tmp.MontoCapVen), 2),
			Res.Interes = ROUND((Tmp.MontoIntOrd + MontoIntAtr + Tmp.MontoIntVen), 2),
			Res.Moratorios = ROUND(Tmp.MontoIntMora, 2),
			Res.ComFaltaPago = Con_Moneda_Cero,
			Res.OtrasCom = ROUND((Tmp.MontoComision + Tmp.MontoGastoAdmon), 2),

			Res.IVAS = ROUND(Tmp.MontoIVA, 2)
	WHERE Orden = 2
	AND Res.CreditoID = Tmp.CreditoID;


	UPDATE  EDOCTARESUMCREDITOS
	SET     Capital = EDOCTASUMACARGOS(CreditoID, Par_FecIniMes, Par_FecFinMes, Var_TipoCapital,ValorIVAInt,ValorIVAMora,ValorIVAAccesorios),
			Interes = EDOCTASUMACARGOS(CreditoID, Par_FecIniMes, Par_FecFinMes, Var_TipoInteres,ValorIVAInt,ValorIVAMora,ValorIVAAccesorios),
			Moratorios = EDOCTASUMACARGOS(CreditoID, Par_FecIniMes, Par_FecFinMes, Var_TipoMoratorio,ValorIVAInt,ValorIVAMora,ValorIVAAccesorios),
			ComFaltaPago = EDOCTASUMACARGOS(CreditoID, Par_FecIniMes, Par_FecFinMes, Var_TipoComFaltaPago,ValorIVAInt,ValorIVAMora,ValorIVAAccesorios),
			OtrasCom = EDOCTASUMACARGOS(CreditoID, Par_FecIniMes, Par_FecFinMes, Var_TipoOtrasComisiones,ValorIVAInt,ValorIVAMora,ValorIVAAccesorios),
			IVAS = EDOCTASUMACARGOS(CreditoID, Par_FecIniMes, Par_FecFinMes, Var_TipoIVAs,ValorIVAInt,ValorIVAMora,ValorIVAAccesorios)
	WHERE Orden = 3;


	UPDATE EDOCTARESUMCREDITOS Edo, SALDOSCREDITOS Sal
	SET Edo.TotalAdeudo = IFNULL(ROUND((Sal.SalCapVigente + Sal.SalCapatrasado + Sal.SalCapVencido + Sal.SalCapVenNoExi),2)
								+ROUND(((Sal.SalIntOrdinario + Sal.SalIntAtrasado + Sal.SalIntVencido + Sal.SalIntProvision + Sal.SalIntNoConta) * (Edo.ValorIVAInt + 1)) ,2)
								+ROUND(((Sal.SalMoratorios + Sal.SaldoMoraVencido + Sal.SaldoMoraCarVen) * (Edo.ValorIVAMora + 1)), 2)
								+ROUND((Sal.SalComFaltaPago * (Edo.ValorIVAAccesorios + 1)), 2)
								+ROUND((Sal.SaldoComServGar * (Edo.ValorIVAAccesorios + 1)), 2)
								+ROUND((Sal.SalOtrasComisi * (Edo.ValorIVAAccesorios + 1)), Con_Moneda_Cero), 2) ,
		Edo.MontoExigible = EDOCTASUMAAMORTIVEN(Edo.CreditoID, Par_FecFinMes, Edo.ValorIVAInt, Edo.ValorIVAMora, Edo.ValorIVAAccesorios),
		Edo.FechaProxPago = 'INMEDIATO'
	WHERE Sal.FechaCorte = Var_FechaCorte
	  AND Edo.CreditoID = Sal.CreditoID
	  AND Edo.Orden = 3;



	INSERT INTO TMP_EDOCTAPROXPAGO
	SELECT CreditoID, MIN(FechaExigible) AS FechaPago
	FROM AMORTICREDITO Amo
	WHERE Amo.FechaExigible > Par_FecFinMes
	GROUP BY CreditoID;


	UPDATE EDOCTARESUMCREDITOS Edo
		   INNER JOIN SALDOSCREDITOS Sal ON Edo.CreditoID = Sal.CreditoID
		   LEFT JOIN TMP_EDOCTAPROXPAGO FecPag ON Edo.CreditoID = FecPag.Credito
	SET Edo.MontoExigible = EDOCTASUMAAMORTIVIG(Edo.CreditoID, Par_FecFinMes, Edo.ValorIVAInt),
		Edo.FechaProxPago = IFNULL(CAST(DATE_FORMAT(FecPag.FechaPago, '%Y-%m-%d') AS CHAR), 'INMEDIATO')
	WHERE Sal.FechaCorte = Var_FechaCorte
	  AND Edo.Orden = 3
	  AND Edo.MontoExigible = Con_Entero_Cero;


	UPDATE EDOCTARESUMCREDITOS Edo, CREDITOS Cre, PRODUCTOSCREDITO Prod
	SET Edo.DescMoneda = Cre.MonedaID,
	Edo.FechaFormalizacion = Cre.FechaInicio,
	Edo.CAT = Cre.ValorCAT,
	Edo.ProductoCred = Prod.Descripcion,
	Edo.TipoPago = CASE WHEN Cre.FrecuenciaCAP ='S' THEN 'SEMANAL'
					WHEN Cre.FrecuenciaCAP ='C' THEN 'CATORCENAL'
					WHEN Cre.FrecuenciaCAP ='Q' THEN 'QUINCENAL'
					WHEN Cre.FrecuenciaCAP ='M' THEN 'MENSUAL'
					WHEN Cre.FrecuenciaCAP ='P' THEN 'PERIODO'
					WHEN Cre.FrecuenciaCAP ='B' THEN 'BIMESTRAL'
					WHEN Cre.FrecuenciaCAP ='T' THEN 'TRIMESTRAL'
					WHEN Cre.FrecuenciaCAP ='R' THEN 'TETRAMESTRAL'
					WHEN Cre.FrecuenciaCAP ='E' THEN 'SEMESTRAL'
					WHEN Cre.FrecuenciaCAP ='A' THEN 'ANUAL'
					WHEN Cre.FrecuenciaCAP ='L' THEN 'IRREGULAR'
					WHEN Cre.FrecuenciaCAP ='U' THEN 'UNICO' END,
	Edo.Estatus  = CASE Cre.Estatus
					WHEN 'I' THEN 'INACTIVO'
					WHEN 'A' THEN 'AUTORIZADO'
					WHEN 'V' THEN 'VIGENTE'
					WHEN 'P' THEN 'PAGADO'
					WHEN 'C' THEN 'CANCELADO'
					WHEN 'B' THEN 'VENCIDO'
					WHEN 'K' THEN 'CASTIGADO' END
	WHERE Edo.CreditoID = Cre.CreditoID
	AND Prod.ProducCreditoID = Cre.ProductoCreditoID
	AND Edo.Orden= 2;

	UPDATE EDOCTARESUMCREDITOS Edo, MONEDAS Mon
	SET Edo.DescMoneda= Mon.DescriCorta
	WHERE Edo.Orden = 2;

	UPDATE EDOCTARESUMCREDITOS  Edo,
			CREDITOS Cre,
			PRODUCTOSCREDITO Pro
	SET Edo.MontoOtorgado	= Cre.MontoCredito,
		Edo.TasaFija	=	Cre.TasaFija,
		Edo.TasaMoratoria = CASE WHEN Pro.TipCobComMorato = TipoCobMoraTasa THEN Cre.FactorMora
								WHEN Pro.TipCobComMorato = TipoCobMoraNveces THEN
										(Cre.TasaFija * Cre.FactorMora) ELSE Con_Moneda_Cero END
	WHERE Edo.CreditoID = Cre.CreditoID
		AND Pro.ProducCreditoID = Cre.ProductoCreditoID
		AND Edo.Orden = 2;


	UPDATE EDOCTARESUMCREDITOS Edo, AMORTICREDITO Cre
	SET Edo.TotalAtrasado= (Cre.SaldoCapAtrasa + Cre.SaldoCapVencido + Cre.SaldoInteresAtr + Cre.SaldoInteresVen + Cre.SaldoIntNoConta +
							Cre.SaldoMoratorios + Cre.SaldoMoraVencido + Cre.SaldoMoraCarVen +
							((Cre.SaldoMoratorios*Edo.ValorIVAMora) + (Cre.SaldoMoraVencido*Edo.ValorIVAMora) + (Cre.SaldoMoraCarVen*Edo.ValorIVAMora)))
	WHERE Edo.CreditoID=Cre.CreditoID AND Cre.Estatus= EstatusAtrasado AND Edo.Orden = 2;


	UPDATE EDOCTARESUMCREDITOS Edo
		   INNER JOIN MONEDAS Mon ON Edo.MonedaID= Mon.MonedaID
	SET Edo.DescMoneda = Mon.DescriCorta
	WHERE Edo.Orden = 1
	  AND Edo.MontoExigible = Con_Entero_Cero;

	DROP TEMPORARY TABLE IF EXISTS TMPULTIMOPAGO;
	CREATE TEMPORARY TABLE TMPULTIMOPAGO
	SELECT CreditoID,MAX(FechaAplicacion) AS FechaAplicacion
		FROM CREDITOSMOVS
		WHERE NatMovimiento = NatAbono AND TipoMovCreID IN (1,2,3,4)
		GROUP BY CreditoID;


	UPDATE EDOCTARESUMCREDITOS edo
		INNER JOIN TMPULTIMOPAGO tmp ON edo.CreditoID=tmp.CreditoID
			SET edo.FechaUltimoPago=tmp.FechaAplicacion;

	DROP TEMPORARY TABLE IF EXISTS TMPINTERESCOMCRED;
	CREATE TEMPORARY TABLE TMPINTERESCOMCRED(
	  CreditoID		BIGINT(12),
	  InteresaPagar	DECIMAL(14,2),
	  Comisiones	DECIMAL(14,2),
	PRIMARY KEY(CreditoID)
	);
	INSERT INTO TMPINTERESCOMCRED
	SELECT cre.CreditoID
		  ,SUM(CASE WHEN amor.Estatus IN (EstatusAtrasado,EstatusVencido) THEN
			(amor.SaldoInteresAtr + amor.SaldoInteresVen + amor.SaldoIntNoConta + amor.SaldoMoratorios + amor.SaldoMoraVencido + amor.SaldoMoraCarVen) END)
		  ,SUM(CASE WHEN amor.Estatus <> EstatusPagado THEN
			(amor.SaldoComFaltaPa + amor.SaldoComServGar + amor.SaldoOtrasComis) END)
	  FROM CREDITOS cre
	  INNER JOIN AMORTICREDITO amor ON cre.CreditoID = amor.CreditoID
	  WHERE cre.Estatus IN (EstatusVigente, EstatusVencido)
	  GROUP BY cre.CreditoID;

	UPDATE EDOCTARESUMCREDITOS edo
	  INNER JOIN TMPINTERESCOMCRED tmp ON edo.CreditoID=tmp.CreditoID
		SET edo.InteresaPagar = IFNULL(tmp.InteresaPagar, 0.0),
			edo.Comisiones = IFNULL(tmp.Comisiones, 0.0);



	DROP TEMPORARY TABLE IF EXISTS TMPEDOCTASUMASINTERMORAS;
	CREATE TEMPORARY TABLE TMPEDOCTASUMASINTERMORAS (
		CreditoID BIGINT(12) NOT NULL COMMENT 'Credito',
		ClienteID INT(11) DEFAULT NULL COMMENT 'Cliente',
		PagaIVA CHAR(1) DEFAULT NULL COMMENT 'Cliente Paga Iva',
		CobraIVAInteres CHAR(1) DEFAULT NULL COMMENT 'Si al Producto de Credito se le Cobra Iva al Interes',
		CobraIVAMora CHAR(1) DEFAULT NULL COMMENT 'Si al Producto de Credito se le Cobra Iva a Moratorios',
		IVAInteres DECIMAL(12 , 2 ) DEFAULT NULL COMMENT 'Iva a aplicar a Intereses',
		IVAMora DECIMAL(12 , 2 ) DEFAULT NULL COMMENT 'Iva a aplicar a Moratorios',
		SaldoMoratorios DECIMAL(12 , 2 ) DEFAULT NULL COMMENT 'Saldo Moratorios, en el alta nace con ceros',
		SaldoMoraVencido DECIMAL(12 , 2 ) DEFAULT NULL COMMENT 'Saldo de Interes Moratorio en atraso o vencido',
		SaldoMoraCarVen DECIMAL(12 , 2 ) DEFAULT NULL COMMENT 'Saldo de Moratorios deirvado de cartera vencida, en ctas de orden',
		SaldoInteresOrdPro DECIMAL(12 , 2 ) DEFAULT NULL COMMENT 'Saldo de Interes Ordinario, en el alta nace con ceros',
		SaldoInteresAtr DECIMAL(12 , 2 ) DEFAULT NULL COMMENT 'Saldo de Interes Atrasado, en el alta nace con ceros',
		SaldoInteresVen DECIMAL(12 , 2 ) DEFAULT NULL COMMENT 'Saldos de Interes Vencido, en el alta nace con ceros',
		SaldoIntNoConta DECIMAL(12 , 2 ) DEFAULT NULL COMMENT 'Saldo de Interes No Contabilizado',
		SaldoCapVigente DECIMAL(12 , 2 ) DEFAULT NULL COMMENT 'Saldo de Capital Vigente, en el alta nace con ceros',
		SaldoCapAtrasa DECIMAL(12 , 2 ) DEFAULT NULL COMMENT 'Saldo de Capital Atrasado, en el alta nace con ceros',
		SaldoCapVencido DECIMAL(12 , 2 ) DEFAULT NULL COMMENT 'Saldo de Capital Vencido, en el alta nace con ceros',
		SaldoCapVenNExi DECIMAL(12 , 2 ) DEFAULT NULL COMMENT 'Saldo de Capital Vencido no Exigible, en al alta nace con ceros',
		AmortiSaldoCapVencido DECIMAL(12 , 2 ) DEFAULT NULL COMMENT 'Amortizaciones Saldo de Capital Vencido, en el alta nace con ceros',
		IVAMoratorios DECIMAL(12 , 2 ) DEFAULT NULL COMMENT 'IVA Moratorios, en el alta nace con ceros',
		IVAMoraVencido DECIMAL(12 , 2 ) DEFAULT NULL COMMENT 'IVA de Interes Moratorio en atraso o vencido',
		IVAMoraCarVen DECIMAL(12 , 2 ) DEFAULT NULL COMMENT 'IVA de Moratorios deirvado de cartera vencida, en ctas de orden',
		IVAInteresOrdPro DECIMAL(12 , 2 ) DEFAULT NULL COMMENT 'IVA de Interes Ordinario, en el alta nace con ceros',
		IVAInteresAtr DECIMAL(12 , 2) DEFAULT NULL COMMENT 'IVA de Interes Atrasado, en el alta nace con ceros',
		IVAInteresVen DECIMAL(12 , 2 ) DEFAULT NULL COMMENT 'IVA de Interes Vencido, en el alta nace con ceros',
		IVAIntNoConta DECIMAL(12 , 2 ) DEFAULT NULL COMMENT 'IVA de Interes No Contabilizado'
	);
	INSERT INTO TMPEDOCTASUMASINTERMORAS
	SELECT ACre.CreditoID,   ACre.ClienteID,    Cli.PagaIVA,               ProdCre.CobraIVAInteres,     ProdCre.CobraIVAMora,
		   Suc.IVA,          Suc.IVA,           SUM(ACre.SaldoMoratorios), SUM(ACre.SaldoMoraVencido),  SUM(ACre.SaldoMoraCarVen),
		   SUM(ACre.SaldoInteresOrd + ACre.SaldoInteresPro),               SUM(ACre.SaldoInteresAtr),   SUM(ACre.SaldoInteresVen),
		   SUM(ACre.SaldoIntNoConta),           SUM(ACre.SaldoCapVigente), SUM(ACre.SaldoCapAtrasa),    SUM(ACre.SaldoCapVencido),
		   SUM(ACre.SaldoCapVenNExi),           SUM(ACre.SaldoCapVencido), Con_Moneda_Cero,             Con_Moneda_Cero,
		   Con_Moneda_Cero,                     Con_Moneda_Cero,           Con_Moneda_Cero,             Con_Moneda_Cero,
		   Con_Moneda_Cero
	  FROM EDOCTARESUMCREDITOS Edo, AMORTICREDITO ACre, CLIENTES Cli,
		   CREDITOS Cre, PRODUCTOSCREDITO ProdCre, SUCURSALES Suc
	 WHERE Edo.Orden = 1
	   AND ACre.ClienteID = Edo.ClienteID
	   AND ACre.CreditoID = Edo.CreditoID
	   AND Cli.ClienteID = ACre.ClienteID
	   AND Cre.CreditoID = ACre.CreditoID
	   AND ProdCre.ProducCreditoID = Cre.ProductoCreditoID
	   AND Suc.SucursalID = Cli.Sucursal
	 GROUP BY ACre.ClienteID , ACre.CreditoID, Cli.PagaIVA, ProdCre.CobraIVAInteres, ProdCre.CobraIVAMora, Suc.IVA;

	UPDATE TMPEDOCTASUMASINTERMORAS
	   SET IVAInteres = (CASE WHEN PagaIVA = Con_SI THEN (CASE WHEN CobraIVAInteres = Con_SI THEN IVAInteres ELSE Con_Moneda_Cero END) ELSE Con_Moneda_Cero END),
		   IVAMora = (CASE WHEN PagaIVA = Con_SI THEN (CASE WHEN CobraIVAMora = Con_SI THEN IVAMora ELSE Con_Moneda_Cero END) ELSE Con_Moneda_Cero END);

	UPDATE TMPEDOCTASUMASINTERMORAS
	   SET IVAMoratorios = (SaldoMoratorios * IVAMora),
		   IVAMoraVencido = (SaldoMoraVencido * IVAMora),
		   IVAMoraCarVen = (SaldoMoraCarVen * IVAMora),
		   IVAInteresOrdPro = (SaldoInteresOrdPro * IVAInteres),
		   IVAInteresAtr = (SaldoInteresAtr * IVAInteres),
		   IVAInteresVen = (SaldoInteresVen * IVAInteres),
		   IVAIntNoConta = (SaldoIntNoConta * IVAInteres);

	UPDATE EDOCTARESUMCREDITOS edo, TMPEDOCTASUMASINTERMORAS tmp
	   SET edo.SaldoIntMora = (tmp.SaldoMoratorios + tmp.SaldoMoraVencido + tmp.SaldoMoraCarVen) ,
		   edo.SaldoIntNormal = (tmp.SaldoInteresOrdPro + tmp.SaldoInteresAtr + tmp.SaldoInteresVen + tmp.SaldoIntNoConta),
		   edo.SaldoCapital = (tmp.SaldoCapVigente + tmp.SaldoCapAtrasa + tmp.SaldoCapVencido + tmp.SaldoCapVenNExi),
		   edo.AmorizaCapital = tmp.AmortiSaldoCapVencido,
		   edo.IvaInterMora = (tmp.IVAMoratorios + tmp.IVAMoraVencido + tmp.IVAMoraCarVen),
		   edo.IvaInterNormal = (tmp.IVAInteresOrdPro + tmp.IVAInteresAtr+ +tmp.IVAInteresVen + tmp.IVAIntNoConta)
	 WHERE edo.ClienteID = tmp.ClienteID
	   AND edo.CreditoID = tmp.CreditoID;

	DROP TEMPORARY TABLE IF EXISTS TMP_DATOSAMORTICRED;
	 CREATE TEMPORARY TABLE TMP_DATOSAMORTICRED(
		CreditoID 			BIGINT(12),
		AmortizacionID   	INT(11),
		PRIMARY KEY (CreditoID));


	INSERT INTO TMP_DATOSAMORTICRED()
	SELECT  Amo.CreditoID, MAX(Amo.AmortizacionID)
		FROM AMORTICREDITO Amo, EDOCTARESUMCREDITOS Res
		WHERE Amo.CreditoID = Res.CreditoID
		  AND Amo.Estatus = EstatusPagado
		GROUP BY Amo.CreditoID;

	UPDATE EDOCTARESUMCREDITOS Res,
			TMP_DATOSAMORTICRED Amo
		 SET AmortiMin = LPAD(TRIM(LEFT(Amo.AmortizacionID,10)),3, '000')
	WHERE Amo.CreditoID =  Res.CreditoID;

	-- Actualiza los numero de pagos
	UPDATE EDOCTARESUMCREDITOS Res,
			CREDITOS Cre
		SET AmortiMax = LPAD(TRIM(LEFT(Cre.NumAmortizacion,10)),3, '000')
	WHERE Cre.CreditoID = Res.CreditoID;

	UPDATE EDOCTARESUMCREDITOS
		SET Pagos = CONCAT(AmortiMin,' de ',AmortiMax);


	DROP TABLE IF EXISTS TMPINTERESCOMCRED;
	DROP TABLE IF EXISTS TMP_EDOCTADETALLEPAGCRE;
	DROP TABLE IF EXISTS TMP_EDOCTAPROXPAGO;
	DROP TABLE IF EXISTS TMPULTIMOPAGO;
	DROP TABLE IF EXISTS TMPEDOCTASUMASINTERMORAS;
	DROP TABLE IF EXISTS TMP_DATOSAMORTICRED;
END TerminaStore$$