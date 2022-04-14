-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTADETCRE000PRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTADETCRE000PRO`;
DELIMITER $$


CREATE PROCEDURE `EDOCTADETCRE000PRO`(
	-- Proceso que genera informacion de movimientos de creditos
    Par_AnioMes     INT(11),
    Par_SucursalID  INT(11),
    Par_FecIniMes   DATE,
    Par_FecFinMes   DATE
	)

TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_FechaCorte        	DATE;
	DECLARE Var_TipoCapital         INT(11);
	DECLARE Var_TipoInteres         INT(11);
	DECLARE Var_TipoMoratorio       INT(11);
	DECLARE Var_TipoComFaltaPago    INT(11);

	DECLARE Var_TipoOtrasComisiones INT(11);
	DECLARE Var_TipoIVAs            INT(11);

	-- Declaracion de Constantes
	DECLARE Con_Cadena_Vacia    	VARCHAR(1);
	DECLARE Con_Fecha_Vacia     	DATE;
	DECLARE Con_Entero_Cero     	INT(11);
	DECLARE Con_Moneda_Cero     	DECIMAL(14,2);
	DECLARE Con_PolizaCero			INT(1);

	DECLARE Est_Vigente				CHAR(1);
    DECLARE Est_Atrasado			CHAR(1);
    DECLARE Est_Vencido				CHAR(1);
    DECLARE Est_Castigado			CHAR(1);
    DECLARE Est_Pagado				CHAR(1);

    DECLARE NatCargo				CHAR(1);
	DECLARE NatAbono				CHAR(1);

	-- Asignacion de Constantes
	SET Con_Cadena_Vacia  	:= '';				-- Cadena vacia
	SET Con_Fecha_Vacia 	:= '1900-01-01';	-- Fecha Vacia
	SET Con_Entero_Cero 	:= 0;				-- Entero Cero
	SET Con_Moneda_Cero 	:= 0.00;			-- Moneda Cero
	SET Con_PolizaCero		:= 0;				-- Poliza cero

	SET Est_Vigente			:= 'V';				-- Estatus Amortizacion: VIGENTE
    SET Est_Atrasado		:= 'A';				-- Estatus Amortizacion: ATRASADA
    SET Est_Vencido			:= 'B';				-- Estatus Amortizacion: VENCIDA
    SET Est_Castigado		:= 'K';				-- Estatus Amortizacion: CASTIGADO
    SET Est_Pagado			:= 'P';				-- Estatus Amortizacion: PAGADA

    SET NatCargo			:= 'C';				-- Naturaleza de movimiento: Cargo
	SET NatAbono			:= 'A';				-- Naturaleza de movimiento: Abono

	-- Asignacion de valores
	SET Var_TipoCapital 			:= 1;
	SET Var_TipoInteres 			:= 2;
	SET Var_TipoMoratorio 			:= 3;
	SET Var_TipoComFaltaPago 		:= 4;
	SET Var_TipoOtrasComisiones 	:= 5;
	SET Var_TipoIVAs 				:= 6;


	INSERT INTO EDOCTADETCRE(
		AnioMes,			SucursalID,		ClienteID,		CreditoID,		FechaOperacion,
		TipoMovimi,			Descripcion,	Cargos,			Abonos,			PolizaID,
		NumAmortizaciones,	AmoCubiertas,	AmoPorCubrir,	CapitalCubierto)
	SELECT  Par_AnioMes,        Par_SucursalID,             Con_Entero_Cero,    CreditoID,       	FechaExigible,
			Var_TipoCapital,    'VTO.CREDITO.CAPITAL', 		Capital AS Cap,		Con_Moneda_Cero,	Con_PolizaCero,
			Con_Entero_Cero,	Con_Entero_Cero,			Con_Entero_Cero,	Con_Entero_Cero
	FROM AMORTICREDITO

	WHERE FechaExigible >= Par_FecIniMes AND FechaExigible <= Par_FecFinMes
	 AND (Estatus IN (Est_Vigente, Est_Atrasado, Est_Vencido, Est_Castigado)
		OR (Estatus = Est_Pagado AND FechaLiquida >= Par_FecIniMes))
	ORDER BY CreditoID, AmortizacionID;


	-- CARGOS

	INSERT INTO EDOCTADETCRE(
		AnioMes,			SucursalID,		ClienteID,		CreditoID,		FechaOperacion,
		TipoMovimi,			Descripcion,	Cargos,			Abonos,			PolizaID,
		NumAmortizaciones,	AmoCubiertas,	AmoPorCubrir,	CapitalCubierto)
	SELECT  Par_AnioMes,        Par_SucursalID,            	Con_Entero_Cero,    			Mov.CreditoID,       	 MAX(Amo.FechaVencim) ,
			Var_TipoInteres,    'VTO.CREDITO.INTERES',   	ROUND(SUM(Mov.Cantidad),2),     Con_Moneda_Cero, 		 IFNULL(Mov.PolizaID,Con_PolizaCero),
			Con_Entero_Cero,	Con_Entero_Cero,			Con_Entero_Cero,				Con_Entero_Cero
	FROM CREDITOSMOVS Mov
	INNER JOIN AMORTICREDITO Amo ON Amo.CreditoID = Mov.CreditoID AND Amo.AmortizacionID = Mov.AmortiCreID AND Amo.FechaVencim <= Par_FecFinMes
	WHERE Mov.FechaOperacion >= Par_FecIniMes
	  AND Mov.FechaOperacion <= Par_FecFinMes
	  AND Amo.FechaVencim <= Par_FecFinMes
	  AND Mov.TipoMovCreID IN (10,13, 14)
	  AND Mov.NatMovimiento = NatCargo
	  AND (Mov.Descripcion IN ('CIERRE DIARO CARTERA', 'CIERRE DIARIO CARTERA'))
	GROUP BY Mov.CreditoID, Mov.PolizaID, Mov.AmortiCreID;


	INSERT INTO EDOCTADETCRE(
		AnioMes,			SucursalID,		ClienteID,		CreditoID,		FechaOperacion,
		TipoMovimi,			Descripcion,	Cargos,			Abonos,			PolizaID,
		NumAmortizaciones,	AmoCubiertas,	AmoPorCubrir,	CapitalCubierto)
	SELECT  Par_AnioMes,        Par_SucursalID,            		Con_Entero_Cero,    			Mov.CreditoID,       	MAX(Mov.FechaOperacion),
			Var_TipoInteres,    'DEVENGUE.CREDITO.INTERES',   	ROUND(SUM(Mov.Cantidad),2),     Con_Moneda_Cero,  		IFNULL(Mov.PolizaID,Con_PolizaCero),
            Con_Entero_Cero,	Con_Entero_Cero,				Con_Entero_Cero,				Con_Entero_Cero
	FROM CREDITOSMOVS Mov
	INNER JOIN AMORTICREDITO Amo ON Amo.CreditoID = Mov.CreditoID AND Amo.AmortizacionID = Mov.AmortiCreID AND Amo.FechaVencim > Par_FecFinMes
	WHERE Mov.FechaOperacion >= Par_FecIniMes
	  AND Mov.FechaOperacion <= Par_FecFinMes
	  AND Amo.FechaVencim > Par_FecFinMes
	  AND Mov.TipoMovCreID IN (10,13, 14)
	  AND Mov.NatMovimiento = NatCargo
	  AND (Mov.Descripcion IN ('CIERRE DIARO CARTERA', 'CIERRE DIARIO CARTERA'))
	GROUP BY Mov.CreditoID, Mov.PolizaID, Mov.AmortiCreID;


	INSERT INTO EDOCTADETCRE(
		AnioMes,			SucursalID,		ClienteID,		CreditoID,		FechaOperacion,
		TipoMovimi,			Descripcion,	Cargos,			Abonos,			PolizaID,
		NumAmortizaciones,	AmoCubiertas,	AmoPorCubrir,	CapitalCubierto)
	SELECT  Par_AnioMes,        Par_SucursalID,            		Con_Entero_Cero,    			Mov.CreditoID,       				MAX(Mov.FechaOperacion),
			Var_TipoInteres,    'VTO.CREDITO.IVA.INTERES',   	ROUND((SUM(Mov.Cantidad)*(IFNULL(Res.ValorIVAInt, 0.0))), 2),       Con_Moneda_Cero,
			IFNULL(Mov.PolizaID,Con_PolizaCero),				Con_Entero_Cero,				Con_Entero_Cero,					Con_Entero_Cero,
            Con_Entero_Cero
	FROM CREDITOSMOVS  Mov
	INNER JOIN EDOCTARESUMCREDITOS Res ON Res.CreditoID = Mov.CreditoID AND Orden = 1
	WHERE Mov.FechaOperacion >= Par_FecIniMes
	  AND Mov.FechaOperacion <= Par_FecFinMes
	  AND Mov.TipoMovCreID IN (10,13, 14)
	  AND Mov.NatMovimiento = NatCargo
	  AND (Mov.Descripcion IN ('CIERRE DIARO CARTERA', 'CIERRE DIARIO CARTERA'))
	GROUP BY Mov.CreditoID, Res.ValorIVAInt, Mov.PolizaID, Mov.AmortiCreID;



	INSERT INTO EDOCTADETCRE(
		AnioMes,			SucursalID,		ClienteID,		CreditoID,		FechaOperacion,
		TipoMovimi,			Descripcion,	Cargos,			Abonos,			PolizaID,
		NumAmortizaciones,	AmoCubiertas,	AmoPorCubrir,	CapitalCubierto)
	SELECT  Par_AnioMes,        Par_SucursalID,            	Con_Entero_Cero,    			CreditoID,       		MAX(FechaOperacion),
			Var_TipoInteres,    'INTERES MORATORIO',   		ROUND(SUM(Cantidad), 2),      	Con_Moneda_Cero,  		IFNULL(PolizaID,Con_PolizaCero),
			Con_Entero_Cero,	Con_Entero_Cero,			Con_Entero_Cero,				Con_Entero_Cero
	FROM CREDITOSMOVS
	WHERE FechaOperacion >= Par_FecIniMes
	  AND FechaOperacion <= Par_FecFinMes
	  AND TipoMovCreID IN (15, 16, 17)
	  AND NatMovimiento = NatCargo
	  AND (Descripcion IN ('CIERRE DIARO CARTERA', 'CIERRE DIARIO CARTERA')  AND Referencia ='GENERACION INTERES MORATORIO')
	GROUP BY CreditoID, PolizaID;


	INSERT INTO EDOCTADETCRE(
		AnioMes,			SucursalID,		ClienteID,		CreditoID,		FechaOperacion,
		TipoMovimi,			Descripcion,	Cargos,			Abonos,			PolizaID,
		NumAmortizaciones,	AmoCubiertas,	AmoPorCubrir,	CapitalCubierto)
	SELECT  Par_AnioMes,        Par_SucursalID,            		Con_Entero_Cero,    		Mov.CreditoID,       					MAX(Mov.FechaOperacion),
			Var_TipoInteres,    'VTO.CREDITO.IVA.MORATORIO',   	ROUND((SUM(Mov.Cantidad)*(IFNULL(Res.ValorIVAMora, 0.0))),2),      	Con_Moneda_Cero,
			IFNULL(Mov.PolizaID,Con_PolizaCero),				Con_Entero_Cero,			Con_Entero_Cero,						Con_Entero_Cero,
            Con_Entero_Cero
	FROM CREDITOSMOVS  Mov
	INNER JOIN EDOCTARESUMCREDITOS Res ON Res.CreditoID = Mov.CreditoID AND Orden = 1
	WHERE Mov.FechaOperacion >= Par_FecIniMes
	  AND Mov.FechaOperacion <= Par_FecFinMes
	  AND Mov.TipoMovCreID IN (15, 16, 17)
	  AND Mov.NatMovimiento = NatCargo
	  AND (Mov.Descripcion IN ('CIERRE DIARO CARTERA', 'CIERRE DIARIO CARTERA')  AND Mov.Referencia ='GENERACION INTERES MORATORIO')
	GROUP BY Mov.CreditoID, Res.ValorIVAMora, Mov.PolizaID;



	INSERT INTO EDOCTADETCRE(
		AnioMes,			SucursalID,		ClienteID,		CreditoID,		FechaOperacion,
		TipoMovimi,			Descripcion,	Cargos,			Abonos,			PolizaID,
		NumAmortizaciones,	AmoCubiertas,	AmoPorCubrir,	CapitalCubierto)
	SELECT  Par_AnioMes,        Par_SucursalID,            	Con_Entero_Cero,    			CreditoID,       	MAX(FechaOperacion),
			Var_TipoInteres,    'COM.FAL.PAGO',   			ROUND(SUM(Cantidad), 2),      	Con_Moneda_Cero,  	IFNULL(PolizaID,Con_PolizaCero),
			Con_Entero_Cero,	Con_Entero_Cero,			Con_Entero_Cero,				Con_Entero_Cero
	FROM CREDITOSMOVS
	WHERE FechaOperacion >= Par_FecIniMes
	  AND FechaOperacion <= Par_FecFinMes
	  AND TipoMovCreID IN (40)
	  AND NatMovimiento = NatCargo
	  AND (Descripcion IN ('CIERRE DIARO CARTERA', 'CIERRE DIARIO CARTERA'))
	GROUP BY CreditoID, PolizaID, AmortiCreID;



	INSERT INTO EDOCTADETCRE(
		AnioMes,			SucursalID,		ClienteID,		CreditoID,		FechaOperacion,
		TipoMovimi,			Descripcion,	Cargos,			Abonos,			PolizaID,
		NumAmortizaciones,	AmoCubiertas,	AmoPorCubrir,	CapitalCubierto)
	SELECT  Par_AnioMes,        Par_SucursalID,            	Con_Entero_Cero,    			CreditoID,       	MAX(FechaOperacion),
			Var_TipoInteres,    'COM.APERTURA',   			ROUND(SUM(Cantidad), 2),      	Con_Moneda_Cero,  	IFNULL(PolizaID,Con_PolizaCero),
			Con_Entero_Cero,	Con_Entero_Cero,			Con_Entero_Cero,				Con_Entero_Cero
	FROM CREDITOSMOVS
	WHERE FechaOperacion >= Par_FecIniMes
	  AND FechaOperacion <= Par_FecFinMes
	  AND TipoMovCreID IN (41)
	  AND NatMovimiento = NatCargo
	  AND (Descripcion IN ('CIERRE DIARO CARTERA', 'CIERRE DIARIO CARTERA'))
	GROUP BY CreditoID, PolizaID, AmortiCreID;


	INSERT INTO EDOCTADETCRE(
		AnioMes,			SucursalID,		ClienteID,		CreditoID,		FechaOperacion,
		TipoMovimi,			Descripcion,	Cargos,			Abonos,			PolizaID,
		NumAmortizaciones,	AmoCubiertas,	AmoPorCubrir,	CapitalCubierto)
	SELECT  Par_AnioMes,        Par_SucursalID,            	Con_Entero_Cero,    			CreditoID,       	MAX(FechaOperacion),
			Var_TipoInteres,    'COM.GAST.ADMINISTRACION',  ROUND( SUM(Cantidad), 2),      	Con_Moneda_Cero,  	IFNULL(PolizaID,Con_PolizaCero),
			Con_Entero_Cero,	Con_Entero_Cero,			Con_Entero_Cero,				Con_Entero_Cero
	FROM CREDITOSMOVS
	WHERE FechaOperacion >= Par_FecIniMes
	  AND FechaOperacion <= Par_FecFinMes
	  AND TipoMovCreID IN (42)
	  AND NatMovimiento = NatCargo
	  AND (Descripcion IN ('CIERRE DIARO CARTERA', 'CIERRE DIARIO CARTERA'))
	GROUP BY CreditoID, PolizaID, AmortiCreID;


	-- Notas de cargo
	INSERT INTO EDOCTADETCRE(
		AnioMes,			SucursalID,		ClienteID,		CreditoID,		FechaOperacion,
		TipoMovimi,			Descripcion,	Cargos,			Abonos,			PolizaID,
		NumAmortizaciones,	AmoCubiertas,	AmoPorCubrir,	CapitalCubierto)
	SELECT  Par_AnioMes,        		Par_SucursalID,            	Con_Entero_Cero,    			CreditoID,       	MAX(FechaOperacion),
			Var_TipoOtrasComisiones,	'NOTA DE CARGO',			ROUND( SUM(Cantidad), 2),      	Con_Moneda_Cero,  	IFNULL(PolizaID,Con_PolizaCero),
			Con_Entero_Cero,			Con_Entero_Cero,			Con_Entero_Cero,				Con_Entero_Cero
	FROM CREDITOSMOVS
	WHERE FechaOperacion >= Par_FecIniMes
	  AND FechaOperacion <= Par_FecFinMes
	  AND TipoMovCreID IN (53, 54, 55)
	  AND NatMovimiento = NatCargo
	GROUP BY CreditoID, PolizaID, AmortiCreID;


	INSERT INTO EDOCTADETCRE(
		AnioMes,			SucursalID,		ClienteID,		CreditoID,		FechaOperacion,
		TipoMovimi,			Descripcion,	Cargos,			Abonos,			PolizaID,
		NumAmortizaciones,	AmoCubiertas,	AmoPorCubrir,	CapitalCubierto)
	SELECT  Par_AnioMes,        Par_SucursalID,            		Con_Entero_Cero,    		Mov.CreditoID,       MAX(Mov.FechaOperacion),
			Var_TipoInteres,    'VTO.CREDITO.IVA.COMISIONES',   ROUND((SUM(Mov.Cantidad)*(IFNULL(Res.ValorIVAAccesorios, 0.0))), 2),      	Con_Moneda_Cero,
			 IFNULL(Mov.PolizaID,Con_PolizaCero),				Con_Entero_Cero,			Con_Entero_Cero,	Con_Entero_Cero,			Con_Entero_Cero
	FROM CREDITOSMOVS  Mov
	INNER JOIN EDOCTARESUMCREDITOS Res ON Res.CreditoID = Mov.CreditoID AND Orden = 1
	WHERE Mov.FechaOperacion >= Par_FecIniMes
	  AND Mov.FechaOperacion <= Par_FecFinMes
	  AND Mov.TipoMovCreID IN (40,41,42,56)
	  AND Mov.NatMovimiento = NatCargo
	  AND (Mov.Descripcion IN ('CIERRE DIARO CARTERA', 'CIERRE DIARIO CARTERA'))
	GROUP BY Mov.CreditoID, Mov.PolizaID, Res.ValorIVAAccesorios, Mov.AmortiCreID;


	DELETE FROM EDOCTADETCRE WHERE Cargos = 0 AND Abonos = 0;

	-- ABONOS

	INSERT INTO EDOCTADETCRE(
		AnioMes,			SucursalID,		ClienteID,		CreditoID,		FechaOperacion,
		TipoMovimi,			Descripcion,	Cargos,			Abonos,			PolizaID,
		NumAmortizaciones,	AmoCubiertas,	AmoPorCubrir,	CapitalCubierto)
	SELECT  Par_AnioMes,        Par_SucursalID,     			Con_Entero_Cero, 			Mov.CreditoID,     		Mov.FechaOperacion,
			Var_TipoCapital,    CONCAT('PAGO (CAPITAL) CUOTA ',Amo.AmortizacionID,'/',Cre.NumAmortizacion),   		Con_Moneda_Cero, ROUND(SUM(Mov.Cantidad), 2),
			IFNULL(Mov.PolizaID,Con_PolizaCero),				Con_Entero_Cero,			Con_Entero_Cero,		Con_Entero_Cero,		Con_Entero_Cero
	FROM CREDITOSMOVS Mov
	INNER JOIN AMORTICREDITO Amo ON Mov.CreditoID = Amo.CreditoID AND Mov.AmortiCreID = Amo.AmortizacionID
	INNER JOIN CREDITOS Cre ON Mov.CreditoID=Cre.CreditoID AND Amo.CreditoID=Cre.CreditoID
	WHERE Mov.FechaOperacion >= Par_FecIniMes
	  AND Mov.FechaOperacion <= Par_FecFinMes
	  AND Amo.FechaExigible <= Par_FecFinMes
	  AND Mov.TipoMovCreID IN (1,2,3,4)
	  AND Mov.NatMovimiento = NatAbono
	  AND (Mov.Descripcion = 'PAGO DE CREDITO' OR Mov.Descripcion = 'BONIFICACION')
	GROUP BY Mov.CreditoID, Mov.FechaOperacion, Amo.AmortizacionID, Cre.NumAmortizacion, Mov.PolizaID;


	INSERT INTO EDOCTADETCRE(
		AnioMes,			SucursalID,		ClienteID,		CreditoID,		FechaOperacion,
		TipoMovimi,			Descripcion,	Cargos,			Abonos,			PolizaID,
		NumAmortizaciones,	AmoCubiertas,	AmoPorCubrir,	CapitalCubierto)
	SELECT  Par_AnioMes,        Par_SucursalID,     				Con_Entero_Cero, 		Mov.CreditoID,     		Mov.FechaOperacion,
			Var_TipoCapital,   CONCAT('PRE-PAGO (CAPITAL) CUOTA ',Amo.AmortizacionID,'/',	Cre.NumAmortizacion),  	Con_Moneda_Cero, ROUND(SUM(Mov.Cantidad), 2),
			IFNULL(Mov.PolizaID,Con_PolizaCero),					Con_Entero_Cero,		Con_Entero_Cero,		Con_Entero_Cero,		Con_Entero_Cero
	FROM CREDITOSMOVS Mov
	INNER JOIN AMORTICREDITO Amo ON Mov.CreditoID = Amo.CreditoID AND Mov.AmortiCreID = Amo.AmortizacionID
	INNER JOIN CREDITOS Cre ON Mov.CreditoID=Cre.CreditoID AND Amo.CreditoID=Cre.CreditoID
	WHERE Mov.FechaOperacion >= Par_FecIniMes
	  AND Mov.FechaOperacion <= Par_FecFinMes
	  AND Amo.FechaExigible > Par_FecFinMes
	  AND Mov.TipoMovCreID IN (1,2,3,4)
	  AND Mov.NatMovimiento = NatAbono
	  AND (Mov.Descripcion = 'PAGO DE CREDITO' OR Mov.Descripcion = 'BONIFICACION')
	GROUP BY Mov.CreditoID, Mov.FechaOperacion, Amo.AmortizacionID, Cre.NumAmortizacion, Mov.PolizaID;


	INSERT INTO EDOCTADETCRE(
		AnioMes,			SucursalID,		ClienteID,		CreditoID,		FechaOperacion,
		TipoMovimi,			Descripcion,	Cargos,			Abonos,			PolizaID,
		NumAmortizaciones,	AmoCubiertas,	AmoPorCubrir,	CapitalCubierto)
	SELECT  Par_AnioMes,        Par_SucursalID,     		Con_Entero_Cero, 			CreditoID,     		FechaOperacion,
			Var_TipoCapital,    'CONDONACION (CAPITAL)',   	Con_Moneda_Cero, ROUND(SUM(Cantidad), 2),
			IFNULL(PolizaID,Con_PolizaCero),				Con_Entero_Cero,			Con_Entero_Cero,	Con_Entero_Cero,
            Con_Entero_Cero
	FROM CREDITOSMOVS
	WHERE FechaOperacion >= Par_FecIniMes
	  AND FechaOperacion <= Par_FecFinMes
	  AND TipoMovCreID IN (1,2,3,4)
	  AND NatMovimiento = NatAbono
	  AND Descripcion LIKE '%CONDONACION%'
	GROUP BY CreditoID, FechaOperacion, PolizaID;


	INSERT INTO EDOCTADETCRE(
		AnioMes,			SucursalID,		ClienteID,		CreditoID,		FechaOperacion,
		TipoMovimi,			Descripcion,	Cargos,			Abonos,			PolizaID,
		NumAmortizaciones,	AmoCubiertas,	AmoPorCubrir,	CapitalCubierto)
	SELECT  Par_AnioMes,        Par_SucursalID,     			Con_Entero_Cero, 			Cmov.CreditoID,     	Cmov.FechaOperacion,
			Var_TipoInteres,    CONCAT('PAGO (INTERES) CUOTA ',IFNULL(Cmov.AmortiCreID, Con_Cadena_Vacia),'/',IFNULL(Cre.NumAmortizacion, Con_Cadena_Vacia)),   		Con_Moneda_Cero, ROUND(SUM(Cmov.Cantidad), 2),
			IFNULL(PolizaID,Con_PolizaCero),					Con_Entero_Cero,			Con_Entero_Cero,		Con_Entero_Cero,		Con_Entero_Cero
	FROM CREDITOSMOVS Cmov
	INNER JOIN CREDITOS Cre ON Cmov.CreditoID=Cre.CreditoID
	WHERE Cmov.FechaOperacion >= Par_FecIniMes
	  AND Cmov.FechaOperacion <= Par_FecFinMes
	  AND Cmov.TipoMovCreID IN (10,11,12,13,14)
	  AND Cmov.NatMovimiento = NatAbono
	  AND (Cmov.Descripcion = 'PAGO DE CREDITO' OR Cmov.Descripcion = 'BONIFICACION')
	GROUP BY Cmov.CreditoID, Cmov.FechaOperacion, Cmov.AmortiCreID, Cre.NumAmortizacion, Cmov.PolizaID;


	INSERT INTO EDOCTADETCRE(
		AnioMes,			SucursalID,		ClienteID,		CreditoID,		FechaOperacion,
		TipoMovimi,			Descripcion,	Cargos,			Abonos,			PolizaID,
		NumAmortizaciones,	AmoCubiertas,	AmoPorCubrir,	CapitalCubierto)
	SELECT  Par_AnioMes,        Par_SucursalID,     		Con_Entero_Cero, 			CreditoID,     		FechaOperacion,
			Var_TipoInteres,    'CONDONACION (INTERES)',   	Con_Moneda_Cero, ROUND(SUM(Cantidad), 2),
			IFNULL(PolizaID,Con_PolizaCero),				Con_Entero_Cero,			Con_Entero_Cero,	Con_Entero_Cero,
            Con_Entero_Cero
	FROM CREDITOSMOVS
	WHERE FechaOperacion >= Par_FecIniMes
	  AND FechaOperacion <= Par_FecFinMes
	  AND TipoMovCreID IN (10,11,12,13,14)
	  AND NatMovimiento = NatAbono
	  AND Descripcion LIKE '%CONDONACION%'
	GROUP BY CreditoID, FechaOperacion, PolizaID;


	INSERT INTO EDOCTADETCRE(
		AnioMes,			SucursalID,		ClienteID,		CreditoID,		FechaOperacion,
		TipoMovimi,			Descripcion,	Cargos,			Abonos,			PolizaID,
		NumAmortizaciones,	AmoCubiertas,	AmoPorCubrir,	CapitalCubierto)
	SELECT  Par_AnioMes,        Par_SucursalID,        	Con_Entero_Cero, 				Cmov.CreditoID,     		Cmov.FechaOperacion,
			Var_TipoMoratorio,  CONCAT('PAGO (MORATORIOS) CUOTA ',IFNULL(Cmov.AmortiCreID, Con_Cadena_Vacia),'/',IFNULL(Cre.NumAmortizacion, Con_Cadena_Vacia)),
			Con_Moneda_Cero, ROUND(SUM(Cmov.Cantidad), 2), IFNULL(Cmov.PolizaID,Con_PolizaCero),
			Con_Entero_Cero,	Con_Entero_Cero,		Con_Entero_Cero,				Con_Entero_Cero
	FROM CREDITOSMOVS Cmov
	INNER JOIN CREDITOS Cre ON Cmov.CreditoID=Cre.CreditoID
	WHERE Cmov.FechaOperacion >= Par_FecIniMes
	  AND Cmov.FechaOperacion <= Par_FecFinMes
	  AND Cmov.TipoMovCreID IN  (15, 16, 17)
	  AND Cmov.NatMovimiento = NatAbono
	  AND (Cmov.Descripcion = 'PAGO DE CREDITO' OR Cmov.Descripcion = 'BONIFICACION')
	GROUP BY Cmov.CreditoID, Cmov.FechaOperacion, Cmov.AmortiCreID, Cre.NumAmortizacion, Cmov.PolizaID;


	INSERT INTO EDOCTADETCRE(
		AnioMes,			SucursalID,		ClienteID,		CreditoID,		FechaOperacion,
		TipoMovimi,			Descripcion,	Cargos,			Abonos,			PolizaID,
		NumAmortizaciones,	AmoCubiertas,	AmoPorCubrir,	CapitalCubierto)
	SELECT  Par_AnioMes,        Par_SucursalID,        			Con_Entero_Cero,		 CreditoID,     		FechaOperacion,
			Var_TipoMoratorio,  'CONDONACION (MORATORIOS)',   	Con_Moneda_Cero, 		ROUND(SUM(Cantidad), 2),
			IFNULL(PolizaID,Con_PolizaCero),					Con_Entero_Cero,		Con_Entero_Cero,		Con_Entero_Cero,
            Con_Entero_Cero
	FROM CREDITOSMOVS
	WHERE FechaOperacion >= Par_FecIniMes
	  AND FechaOperacion <= Par_FecFinMes
	  AND TipoMovCreID IN  (15, 16, 17)
	  AND NatMovimiento = NatAbono
	  AND Descripcion LIKE '%CONDONACION%'
	GROUP BY CreditoID, FechaOperacion, PolizaID;


	INSERT INTO EDOCTADETCRE(
		AnioMes,			SucursalID,		ClienteID,		CreditoID,		FechaOperacion,
		TipoMovimi,			Descripcion,	Cargos,			Abonos,			PolizaID,
		NumAmortizaciones,	AmoCubiertas,	AmoPorCubrir,	CapitalCubierto)
	SELECT  Par_AnioMes,            Par_SucursalID,        	Con_Entero_Cero, 		CreditoID,     		FechaOperacion,
			Var_TipoComFaltaPago,  'PAGO (COM.FAL.PAGO)',  	Con_Moneda_Cero, ROUND(SUM(Cantidad), 2), 	IFNULL(PolizaID,Con_PolizaCero),
			Con_Entero_Cero,		Con_Entero_Cero,		Con_Entero_Cero,		Con_Entero_Cero
	FROM CREDITOSMOVS
	WHERE FechaOperacion >= Par_FecIniMes
	  AND FechaOperacion <= Par_FecFinMes
	  AND TipoMovCreID IN  (40)
	  AND NatMovimiento = NatAbono
	  AND (Descripcion = 'PAGO DE CREDITO' OR Descripcion = 'BONIFICACION')
	GROUP BY CreditoID, FechaOperacion, PolizaID;


	INSERT INTO EDOCTADETCRE(
		AnioMes,			SucursalID,		ClienteID,		CreditoID,		FechaOperacion,
		TipoMovimi,			Descripcion,	Cargos,			Abonos,			PolizaID,
		NumAmortizaciones,	AmoCubiertas,	AmoPorCubrir,	CapitalCubierto)
	SELECT  Par_AnioMes,            Par_SucursalID,        Con_Entero_Cero, 		CreditoID,     		FechaOperacion,
			Var_TipoComFaltaPago,  	'CONDONACION (COM.FAL.PAGO)',   				Con_Moneda_Cero, ROUND(SUM(Cantidad), 2),
            IFNULL(PolizaID,Con_PolizaCero),				Con_Entero_Cero,		Con_Entero_Cero,	Con_Entero_Cero,
            Con_Entero_Cero
	FROM CREDITOSMOVS
	WHERE FechaOperacion >= Par_FecIniMes
	  AND FechaOperacion <= Par_FecFinMes
	  AND TipoMovCreID IN  (40)
	  AND NatMovimiento = NatAbono
	  AND Descripcion LIKE '%CONDONACION%'
	GROUP BY CreditoID, FechaOperacion, PolizaID;


	INSERT INTO EDOCTADETCRE(
		AnioMes,			SucursalID,		ClienteID,		CreditoID,		FechaOperacion,
		TipoMovimi,			Descripcion,	Cargos,			Abonos,			PolizaID,
		NumAmortizaciones,	AmoCubiertas,	AmoPorCubrir,	CapitalCubierto)
	SELECT  Par_AnioMes,            	Par_SucursalID,        		Con_Entero_Cero, 			CreditoID,     		FechaOperacion,
			Var_TipoOtrasComisiones,  	'PAGO (COM.APERTURA)',   	Con_Moneda_Cero, ROUND(SUM(Cantidad), 2), IFNULL(PolizaID,Con_PolizaCero),
			Con_Entero_Cero,			Con_Entero_Cero,			Con_Entero_Cero,			Con_Entero_Cero
	FROM CREDITOSMOVS
	WHERE FechaOperacion >= Par_FecIniMes
	  AND FechaOperacion <= Par_FecFinMes
	  AND TipoMovCreID IN  (41)
	  AND NatMovimiento = NatAbono
	  AND (Descripcion = 'PAGO DE CREDITO' OR Descripcion = 'BONIFICACION')
	GROUP BY CreditoID, FechaOperacion, PolizaID;


	INSERT INTO EDOCTADETCRE(
		AnioMes,			SucursalID,		ClienteID,		CreditoID,		FechaOperacion,
		TipoMovimi,			Descripcion,	Cargos,			Abonos,			PolizaID,
		NumAmortizaciones,	AmoCubiertas,	AmoPorCubrir,	CapitalCubierto)
	SELECT  Par_AnioMes,            	Par_SucursalID,        			Con_Entero_Cero, 		CreditoID,     		FechaOperacion,
			Var_TipoOtrasComisiones,  	'CONDONACION (COM.APERTURA)',   Con_Moneda_Cero, ROUND(SUM(Cantidad), 2), 	IFNULL(PolizaID,Con_PolizaCero),
			Con_Entero_Cero,			Con_Entero_Cero,				Con_Entero_Cero,		Con_Entero_Cero
	FROM CREDITOSMOVS
	WHERE FechaOperacion >= Par_FecIniMes
	  AND FechaOperacion <= Par_FecFinMes
	  AND TipoMovCreID IN  (41)
	  AND NatMovimiento = NatAbono
	  AND Descripcion LIKE '%CONDONACION%'
	GROUP BY CreditoID, FechaOperacion, PolizaID;


	INSERT INTO EDOCTADETCRE(
		AnioMes,			SucursalID,		ClienteID,		CreditoID,		FechaOperacion,
		TipoMovimi,			Descripcion,	Cargos,			Abonos,			PolizaID,
		NumAmortizaciones,	AmoCubiertas,	AmoPorCubrir,	CapitalCubierto)
	SELECT  Par_AnioMes,            	Par_SucursalID,        				Con_Entero_Cero, 			CreditoID,     		FechaOperacion,
			Var_TipoOtrasComisiones,  	'PAGO (COM.GAST.ADMINISTRACION)',   Con_Moneda_Cero, ROUND(SUM(Cantidad), 2),  	IFNULL(PolizaID,Con_PolizaCero),
			Con_Entero_Cero,			Con_Entero_Cero,					Con_Entero_Cero,			Con_Entero_Cero
	FROM CREDITOSMOVS
	WHERE FechaOperacion >= Par_FecIniMes
	  AND FechaOperacion <= Par_FecFinMes
	  AND TipoMovCreID IN  (42)
	  AND NatMovimiento = NatAbono
	  AND (Descripcion = 'PAGO DE CREDITO' OR Descripcion = 'BONIFICACION')
	GROUP BY CreditoID, FechaOperacion, PolizaID;


	INSERT INTO EDOCTADETCRE(
		AnioMes,			SucursalID,		ClienteID,		CreditoID,		FechaOperacion,
		TipoMovimi,			Descripcion,	Cargos,			Abonos,			PolizaID,
		NumAmortizaciones,	AmoCubiertas,	AmoPorCubrir,	CapitalCubierto)
	SELECT  Par_AnioMes,            	Par_SucursalID,        						Con_Entero_Cero, 			CreditoID,     		FechaOperacion,
			Var_TipoOtrasComisiones,  'CONDONACION (COM.GAST.ADMINISTRACION)',    	Con_Moneda_Cero, ROUND(SUM(Cantidad), 2),  		IFNULL(PolizaID,Con_PolizaCero),
			Con_Entero_Cero,			Con_Entero_Cero,							Con_Entero_Cero,			Con_Entero_Cero
	FROM CREDITOSMOVS
	WHERE FechaOperacion >= Par_FecIniMes
	  AND FechaOperacion <= Par_FecFinMes
	  AND TipoMovCreID IN  (42)
	  AND NatMovimiento = NatAbono
	  AND Descripcion LIKE '%CONDONACION%'
	GROUP BY CreditoID, FechaOperacion, PolizaID;


	-- Notas de cargo
	INSERT INTO EDOCTADETCRE(
		AnioMes,			SucursalID,		ClienteID,		CreditoID,		FechaOperacion,
		TipoMovimi,			Descripcion,	Cargos,			Abonos,			PolizaID,
		NumAmortizaciones,	AmoCubiertas,	AmoPorCubrir,	CapitalCubierto)
	SELECT  Par_AnioMes,            	Par_SucursalID,        				Con_Entero_Cero, 			CreditoID,     		FechaOperacion,
			Var_TipoOtrasComisiones,  	'PAGO (NOTA DE CARGO)',				Con_Moneda_Cero, ROUND(SUM(Cantidad), 2),  	IFNULL(PolizaID,Con_PolizaCero),
			Con_Entero_Cero,			Con_Entero_Cero,					Con_Entero_Cero,			Con_Entero_Cero
	FROM CREDITOSMOVS
	WHERE FechaOperacion >= Par_FecIniMes
	  AND FechaOperacion <= Par_FecFinMes
	  AND TipoMovCreID IN  (53, 54, 55)
	  AND NatMovimiento = NatAbono
	  AND (Descripcion = 'PAGO DE CREDITO' OR Descripcion = 'BONIFICACION')
	GROUP BY CreditoID, FechaOperacion, PolizaID;


	INSERT INTO EDOCTADETCRE(
		AnioMes,			SucursalID,		ClienteID,		CreditoID,		FechaOperacion,
		TipoMovimi,			Descripcion,	Cargos,			Abonos,			PolizaID,
		NumAmortizaciones,	AmoCubiertas,	AmoPorCubrir,	CapitalCubierto)
	SELECT  Par_AnioMes,            	Par_SucursalID,        						Con_Entero_Cero, 			CreditoID,     		FechaOperacion,
			Var_TipoOtrasComisiones,  'CONDONACION (NOTA DE CARGO)',				Con_Moneda_Cero, ROUND(SUM(Cantidad), 2),  		IFNULL(PolizaID,Con_PolizaCero),
			Con_Entero_Cero,			Con_Entero_Cero,							Con_Entero_Cero,			Con_Entero_Cero
	FROM CREDITOSMOVS
	WHERE FechaOperacion >= Par_FecIniMes
	  AND FechaOperacion <= Par_FecFinMes
	  AND TipoMovCreID IN  (53, 54, 55)
	  AND NatMovimiento = NatAbono
	  AND Descripcion LIKE '%CONDONACION%'
	GROUP BY CreditoID, FechaOperacion, PolizaID;


	INSERT INTO EDOCTADETCRE(
		AnioMes,			SucursalID,		ClienteID,		CreditoID,		FechaOperacion,
		TipoMovimi,			Descripcion,	Cargos,			Abonos,			PolizaID,
		NumAmortizaciones,	AmoCubiertas,	AmoPorCubrir,	CapitalCubierto)
	SELECT  Par_AnioMes,        Par_SucursalID,     		Con_Entero_Cero, 			Cmov.CreditoID,     		Cmov.FechaOperacion,
			Var_TipoIVAs,    	CONCAT('PAGO (IVA) CUOTA ',IFNULL(Cmov.AmortiCreID, Con_Cadena_Vacia),'/',IFNULL(Cre.NumAmortizacion, Con_Cadena_Vacia)),   			Con_Moneda_Cero, ROUND(SUM(Cmov.Cantidad), 2),
			IFNULL(Cmov.PolizaID,Con_PolizaCero),			Con_Entero_Cero,			Con_Entero_Cero,			Con_Entero_Cero,
            Con_Entero_Cero
	FROM CREDITOSMOVS Cmov
	INNER JOIN CREDITOS Cre ON Cmov.CreditoID=Cre.CreditoID
	WHERE Cmov.FechaOperacion >= Par_FecIniMes
	  AND Cmov.FechaOperacion <= Par_FecFinMes
	  AND Cmov.TipoMovCreID IN  (20,21,22,23,24,56)
	  AND Cmov.NatMovimiento = NatAbono
	  AND (Cmov.Descripcion = 'PAGO DE CREDITO' OR Cmov.Descripcion = 'BONIFICACION')
	GROUP BY Cmov.CreditoID, Cmov.FechaOperacion, Cmov.AmortiCreID, Cre.NumAmortizacion, Cmov.PolizaID;


	UPDATE EDOCTADETCRE Edo, CREDITOS Cre
	SET Edo.ClienteID = Cre.ClienteID
	WHERE Edo.CreditoID = Cre.CreditoID;


	UPDATE EDOCTADETCRE Edo, CLIENTES Cli
	SET Edo.SucursalID = Cli.SucursalOrigen
	WHERE Edo.ClienteID = Cli.ClienteID;

	DROP TABLE IF EXISTS TMPAMORTIZACIONESCRE;
	CREATE TABLE TMPAMORTIZACIONESCRE(
	  CreditoID			BIGINT(12),
	  TotalCuotas		INT,
	  Cubiertas			INT(4),
	  PorCubrir     	INT(4),
	  CapitalCubierto	DECIMAL(14,2),
	PRIMARY KEY(CreditoID));

	INSERT INTO TMPAMORTIZACIONESCRE(
		CreditoID,		TotalCuotas,		Cubiertas,		PorCubrir,		CapitalCubierto)
	SELECT cre.CreditoID
		  ,COUNT(amor.AmortizacionID)
		  ,SUM(CASE WHEN amor.Estatus= Est_Pagado THEN 1 ELSE 0 END)
		  ,SUM(CASE WHEN amor.Estatus <> Est_Pagado THEN 1 ELSE 0 END)
		  ,MAX(cre.MontoCredito) - SUM(CASE WHEN amor.Estatus <> 'P' THEN  (amor.SaldoCapVigente + amor.SaldoCapAtrasa + amor.SaldoCapVencido + amor.SaldoCapVenNExi) END)
	  FROM CREDITOS cre
	  INNER JOIN AMORTICREDITO amor ON cre.CreditoID = amor.CreditoID
	  WHERE cre.Estatus IN (Est_Vigente, Est_Vencido)
	  GROUP BY cre.CreditoID;


	UPDATE EDOCTADETCRE edo
	  INNER JOIN TMPAMORTIZACIONESCRE tmp ON edo.CreditoID=tmp.CreditoID
		SET edo.AmoCubiertas=tmp.Cubiertas,
		  edo.AmoPorCubrir=tmp.PorCubrir,
		  edo.CapitalCubierto=tmp.CapitalCubierto,
		  edo.NumAmortizaciones = TotalCuotas;

		DROP TEMPORARY TABLE IF EXISTS TMP_CARGOABONOCREDITOS;
		CREATE TEMPORARY TABLE TMP_CARGOABONOCREDITOS(
			CreditoID     BIGINT(12),
			CargosMes     DECIMAL(14,2),
			AbonoMes      DECIMAL(14,2),
			PRIMARY KEY (CreditoID));


		INSERT INTO TMP_CARGOABONOCREDITOS(
			CreditoID,		CargosMes,		AbonoMes)
		SELECT CreditoID,	SUM(Cargos),	SUM(Abonos)
		  FROM EDOCTADETCRE
		 GROUP BY CreditoID;

		  UPDATE EDOCTARESUMCREDITOS Res,
				TMP_CARGOABONOCREDITOS Edo
		   SET Res.Abono = Edo.AbonoMes,
			   Res.Cargo = Edo.CargosMes
		 WHERE Res.CreditoID = Edo.CreditoID;

		-- Tabla temporal para registrar las Comisiones por Falta de Pago efectuados por el cliente
		DROP TEMPORARY TABLE IF EXISTS TMP_COMFALTAPAGOCREDITOS;
		CREATE TEMPORARY TABLE TMP_COMFALTAPAGOCREDITOS(
			CreditoID     BIGINT(12),
			Comisiones    DECIMAL(14,2),
			PRIMARY KEY (CreditoID));

		-- Se obtienen las Comisiones por Falta de Pago efectuados por el cliente
		INSERT INTO TMP_COMFALTAPAGOCREDITOS(
			CreditoID,		Comisiones)
		SELECT CreditoID,	SUM(Abonos)
			FROM EDOCTADETCRE
			WHERE TipoMovimi = Var_TipoComFaltaPago
			GROUP BY CreditoID;

		-- Se actualiza en EDOCTARESUMCREDITOS el monto de las Comisiones por Falta de Pago
		 UPDATE EDOCTARESUMCREDITOS Res,
				TMP_COMFALTAPAGOCREDITOS Tmp
			SET Res.ComFaltaPago = Tmp.Comisiones
		WHERE Res.CreditoID = Tmp.CreditoID
			AND Res.Orden = 2;

		-- Se actualiza en EDOCTARESUMCREDITOS el monto de las Otras Comisiones
		 UPDATE EDOCTARESUMCREDITOS Res,
				TMP_COMFALTAPAGOCREDITOS Tmp
			SET Res.OtrasCom = Res.OtrasCom - Tmp.Comisiones
		WHERE Res.CreditoID = Tmp.CreditoID
			AND Res.Orden = 2;

	DROP TEMPORARY TABLE IF EXISTS TMP_COMFALTAPAGOCREDITOS;
	DROP TABLE IF EXISTS TMPAMORTIZACIONESCRE;

END TerminaStore$$
