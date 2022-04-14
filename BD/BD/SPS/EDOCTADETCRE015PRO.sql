-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTADETCRE015PRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTADETCRE015PRO`;
DELIMITER $$


CREATE PROCEDURE `EDOCTADETCRE015PRO`(
	/* SP que genera informacion de los detalles de saldos y movimientos
     de los creditos para el estado de cuenta de SOFI EXPRESS */
    Par_AnioMes     	INT(11),		-- Año y Mes Estado Cuenta
    Par_SucursalID  	INT(11),		-- Numero de Sucursal
    Par_FecIniMes   	DATE,			-- Fecha Inicio Mes
    Par_FecFinMes   	DATE			-- Fecha Fin Mes
)

TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_FechaCorte        	DATE;		-- Almacena la fecha de corte para la aconsulta de saldos
DECLARE Var_FechaIniAnterior   	DATE;		-- Almacena la fecha de inicio del mes anterior
DECLARE Var_FechaFinMesAnt      DATE;		-- Almacena la fecha final del mes anterior
DECLARE Var_FechaCorteAnterior  DATE;		-- Almacena la fecha de corte del mes anterior
DECLARE Var_TipoMovAhoDetCre	VARCHAR(200);-- Tipo de Movimiento de Cuenta de Ahorro a colocar en detalle de credito

-- Declaracion de Constantes
DECLARE Con_Cadena_Vacia    	VARCHAR(1);		-- Cadena vacia
DECLARE Con_Fecha_Vacia     	DATE;			-- Fecha Vacia
DECLARE Con_Entero_Cero     	INT(11);		-- Entero Cero
DECLARE Con_Moneda_Cero     	DECIMAL(14,2);	-- Moneda Cero
DECLARE Con_PolizaCero			INT(1);			-- Poliza Cero

DECLARE Var_TipoCapital     	INT(11);		-- Tipo Cargo: Capital
DECLARE Var_TipoInteres     	INT(11);		-- Tipo Cargo: Interes
DECLARE Var_TipoIVAs            INT(11);		-- Tipo Cargo: IVA
DECLARE Var_TipoPagoCapital     INT(11);		-- Tipo Pago: Capital
DECLARE Var_TipoPagoComision 	INT(11);		-- Tipo Pago: Comision

DECLARE Var_TipoPagoInteres		INT(11);		-- Tipo Pago: Interes
DECLARE Var_TipoPagoIVA			INT(11);		-- Tipo Pago: IVA
DECLARE Var_TipoSaldoInicial	INT(11);		-- Tipo Pago: IVA
DECLARE NatCargo				CHAR(1);		-- Naturaleza de movimiento: Cargo
DECLARE NatAbono				CHAR(1);		-- Naturaleza de movimiento: Abono

DECLARE Var_TipoComision		CHAR(1);		-- Tipo Cargo: Comision
DECLARE Var_DiasPeriodo			INT(11);		-- Cantidad de dias en el periodo de generacion del estado de cuenta
DECLARE Con_Entero_Uno			INT(11);		-- Entero Uno
DECLARE Con_TipoMovAhoDetCre	VARCHAR(50);	-- Llave parametro para obtener el tipo de movimiento de Cta. de Aho. para colocar en el Det. del Cred.
DECLARE Con_ProxCapital			CHAR(1);

DECLARE Con_ProxIntereses		CHAR(1);
DECLARE Con_ProxIVAs			CHAR(1);
DECLARE Con_MontoProxTotal		CHAR(1);
DECLARE Var_TipoComisiCtaAho	INT(11);		-- Tipo Cargo: Comision obtenida a partir de movimientos de cuentas de ahorro
DECLARE Var_TipoPagComCtaAho	INT(11);		-- Tipo Pago: Comision obtenida a partir de movimientos de cuentas de ahorro

-- Asignacion de Constantes
SET Con_Cadena_Vacia  	:= '';					-- Cadena vacia
SET Con_Fecha_Vacia 	:= '1900-01-01'; 		-- Fecha Vacia
SET Con_Entero_Cero 	:= 0;					-- Entero Cero
SET Con_Moneda_Cero 	:= 0.00;				-- Moneda Cero
SET Con_PolizaCero		:= 0;					-- Poliza Cero

SET Var_TipoCapital 		:= 3;				-- Tipo Cargo: Capital
SET Var_TipoInteres			:= 5;				-- Tipo Cargo: Interes
SET Var_TipoIVAs 			:= 6;				-- Tipo Cargo: IVA
SET Var_TipoPagoCapital 	:= 7;				-- Tipo Pago: Capital
SET Var_TipoPagoComision 	:= 8;				-- Tipo Pago: Comision

SET Var_TipoPagoInteres		:= 9;				-- Tipo Pago: Interes
SET Var_TipoPagoIVA 		:= 10;				-- Tipo Pago: IVA
SET Var_TipoSaldoInicial	:= 0;				-- Tipo: Saldo Inicial
SET NatCargo				:= 'C';				-- Naturaleza de movimiento: Cargo
SET NatAbono				:= 'A';				-- Naturaleza de movimiento: Abono

SET Var_TipoComision		:= 4;				-- Tipo Cargo: Comision
SET Con_Entero_Uno			:= 1;				-- Entero Uno
SET Con_TipoMovAhoDetCre	:= 'SFPEdoCtaTipoMovAhoADetCre';		-- Llave parametro para obtener el movimiento de Cta. de Aho. para colocar en el detalle del credito.
SET Con_ProxCapital			:= 'C';				-- Tipo de monto de proximo pago: Capital
SET Con_ProxIntereses		:= 'I';				-- Tipo de monto de proximo pago: Interes


SET Con_ProxIVAs			:= 'V';				-- Tipo de monto de proximo pago: IVAS
SET Con_MontoProxTotal		:= 'T';				-- Tipo de monto de proximo pago: Total
SET Var_TipoComisiCtaAho	:= 1;				-- Tipo Cargo: Comision obtenida a partir de movimientos de cuentas de ahorro
SET Var_TipoPagComCtaAho	:= 2;				-- Tipo Pago: Comision obtenida a partir de movimientos de cuentas de ahorro

-- Se obtiene la fecha inicial anterior
SET Var_FechaIniAnterior = DATE_ADD(Par_FecIniMes,INTERVAL -1 MONTH);

-- se obtiene la fecha de corte en SALDOSCREDITOS
SET Var_FechaCorteAnterior := (SELECT MAX(FechaCorte)
						FROM SALDOSCREDITOS
						 WHERE FechaCorte >= Var_FechaIniAnterior AND FechaCorte < Par_FecIniMes);

SET Var_FechaCorteAnterior := IFNULL(Var_FechaCorteAnterior,Con_Fecha_Vacia);

-- Se obtiene la cantidad de dias transcurridos durante el periodo en el que se ejecuto el estado de cuenta
SET Var_DiasPeriodo := DATEDIFF(Par_FecFinMes, Par_FecIniMes) + Con_Entero_Uno;

-- Se obtiene la lista de tipos de movimientos de cuentas de ahorro que deben colocarse en el detalle del credito
SET Var_TipoMovAhoDetCre := 	(SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = Con_TipoMovAhoDetCre);

	-- Comienza Llenado de Encabezado de Seccion de Detalle de Credito
	INSERT INTO EDOCTAHEADERDETCRE
    SELECT 	Par_AnioMes,		SucursalID, 			ClienteID, 			CreditoID, 				ProductoCred,
			Con_Cadena_Vacia,	Con_Fecha_Vacia,		Con_Moneda_Cero, 	Con_Entero_Cero, 		Con_Cadena_Vacia,
            Con_Moneda_Cero,	Con_Moneda_Cero,		Con_Moneda_Cero,	ComFaltaPago + OtrasCom, Con_Entero_Cero,
            Con_Moneda_Cero,	Con_Moneda_Cero,		Con_Moneda_Cero,	Con_Moneda_Cero,		Con_Entero_Cero,
            Con_Moneda_Cero
	FROM EDOCTARESUMCREDITOS
    GROUP BY CreditoID, SucursalID, ClienteID, ProductoCred, ComFaltaPago, OtrasCom;

	-- Se actualizan los datos en EDOCTAHEADERDETCRE
    UPDATE EDOCTAHEADERDETCRE Edo,
		   CREDITOS Cre,
		   PRODUCTOSCREDITO Pro
	SET FechaFormaliza= Cre.FechaMinistrado,
		MontoAut = Cre.MontoCredito,
		Plazo = TIMESTAMPDIFF(MONTH,FechaInicio,FechaVencimien),
		Periodicidad = CASE Cre.FrecuenciaCap
					WHEN 'S' THEN 'Semanal'
					WHEN 'C' THEN 'Catorcenal'
					WHEN 'Q' THEN 'Quincenal'
					WHEN 'M' THEN 'Mensual'
					WHEN 'P' THEN 'Periodos'
					WHEN 'B' THEN 'Bimestral'
					WHEN 'T' THEN 'Trimestral'
					WHEN 'R' THEN 'Tetramestral'
					WHEN 'E' THEN 'Semestral'
					WHEN 'A' THEN 'Anual'
					WHEN 'L' THEN 'Mixtas'
					WHEN 'U' THEN 'Unico'
                    END,
		TasaOrdinaria = Cre.TasaFija,
		CAT = Cre.ValorCAT,
        TasaMoratoria = CASE WHEN Pro.TipCobComMorato	= 'N' THEN	Cre.TasaFija*Cre.FactorMora
							 WHEN Pro.TipCobComMorato	= 'T' THEN  Cre.FactorMora
							 ELSE Cre.FactorMora END ,
		FrecuenciaPago = Con_Entero_Cero
  WHERE Edo.CreditoID = Cre.CreditoID
  AND Cre.ProductoCreditoID	= Pro.ProducCreditoID;

	-- Tabla temporal para almacenar las comisiones cobradas
	DROP TEMPORARY TABLE IF EXISTS TMP_EDOCTACOMISION;
	CREATE TEMPORARY TABLE TMP_EDOCTACOMISION (
		CreditoID  		BIGINT(12),
        MontoCobrado 	DECIMAL(14,2),
        PRIMARY KEY (CreditoID));

	INSERT INTO TMP_EDOCTACOMISION
	SELECT Mov.CreditoID, IFNULL(ROUND(SUM(Mov.Cantidad),2),Con_Moneda_Cero)
		  FROM EDOCTAHEADERDETCRE Cre,
			   CREDITOSMOVS Mov
		 WHERE Mov.CreditoID = Cre.CreditoID
			AND Mov.FechaOperacion >= Par_FecIniMes
			AND Mov.FechaOperacion <= Par_FecFinMes
			AND Mov.TipoMovCreID IN (40,41,42)
			AND Mov.NatMovimiento  = NatAbono
			GROUP BY Mov.CreditoID;

	-- Se actualiza el monto de las comisiones cobradas
	UPDATE EDOCTAHEADERDETCRE Cre,
			TMP_EDOCTACOMISION Com
	   SET Cre.Comisiones = Com.MontoCobrado
	 WHERE Cre.CreditoID = Com.CreditoID;

	DROP TEMPORARY TABLE IF EXISTS TMP_EDOCTACOMISIONAHO;
	CREATE TEMPORARY TABLE TMP_EDOCTACOMISIONAHO (
		CreditoID		BIGINT(12),
		MontoComision	DECIMAL(14,2),
		PRIMARY KEY (CreditoID));

	INSERT INTO TMP_EDOCTACOMISIONAHO
	SELECT	IF(ReferenciaMov LIKE 'Cred.%', CAST(SUBSTRING(ReferenciaMov,6) AS UNSIGNED), CAST(ReferenciaMov AS UNSIGNED)),
			IFNULL(ROUND(SUM(CantidadMov),2),Con_Moneda_Cero)
	FROM `HIS-CUENAHOMOV`
	WHERE NatMovimiento = NatCargo
	  AND FIND_IN_SET(TipoMovAhoID,Var_TipoMovAhoDetCre) > Con_Entero_Cero
	  AND Fecha >= Par_FecIniMes
	  AND Fecha <= Par_FecFinMes
	  AND DescripcionMov NOT LIKE '%IVA%'
	GROUP BY ReferenciaMov;

	UPDATE EDOCTAHEADERDETCRE Cre,
			TMP_EDOCTACOMISIONAHO Com
	SET Cre.Comisiones = Cre.Comisiones + Com.MontoComision
	WHERE Cre.CreditoID = Com.CreditoID;

	--  Se actualiza el nombre de el producto en EDOCTAHEADERDETCRE
	UPDATE EDOCTAHEADERDETCRE Cre,
			EDOCTARESUMCREDITOS Res
		   SET Cre.NombreProd =  Res.ProductoCred
		 WHERE Cre.CreditoID = Res.CreditoID;

	--  Se actualiza el desgloce del monto a pagar en EDOCTAHEADERDETCRE
	UPDATE EDOCTAHEADERDETCRE
		SET MontoCapital = FNEXIGIBLEPERIODOEDOCTASFP(CreditoID, Par_FecFinMes, Con_ProxCapital),
			MontoIntereses = FNEXIGIBLEPERIODOEDOCTASFP(CreditoID, Par_FecFinMes, Con_ProxIntereses),
			IVAs = FNEXIGIBLEPERIODOEDOCTASFP(CreditoID, Par_FecFinMes, Con_ProxIVAs),
			MontoPagoTotal = FNEXIGIBLEPERIODOEDOCTASFP(CreditoID, Par_FecFinMes, Con_MontoProxTotal);

	--  Se actualiza el monto base del calculo de interes ordinario en EDOCTAHEADERDETCRE
	DROP TEMPORARY TABLE IF EXISTS TMP_EDOCTAMONCALCINTORD;
	CREATE TEMPORARY TABLE TMP_EDOCTAMONCALCINTORD(
		CreditoID				BIGINT(12),
		MonBaseCalIntOrd		DECIMAL(14,2),
		PRIMARY KEY (CreditoID));

	INSERT INTO TMP_EDOCTAMONCALCINTORD()
	SELECT Edo.CreditoID, IFNULL(ROUND(SUM(Sal.SalCapVigente)/(DATEDIFF(MAX(Sal.FechaCorte), MIN(Sal.FechaCorte)) + Con_Entero_Uno),2), Con_Moneda_Cero)
		FROM SALDOSCREDITOS Sal
		INNER JOIN EDOCTARESUMCREDITOS Edo
			WHERE Edo.CreditoID = Sal.CreditoID
			  AND Sal.FechaCorte >= Par_FecIniMes
			  AND Sal.FechaCorte <= Par_FecFinMes
			GROUP BY Edo.CreditoID;

	UPDATE EDOCTAHEADERDETCRE Cre,
			TMP_EDOCTAMONCALCINTORD Tmp
			SET Cre.MonBaseCalIntOrd = Tmp.MonBaseCalIntOrd
		WHERE Cre.CreditoID = Tmp.CreditoID;

	--  Se actualiza el monto base del calculo de interes moratorio en EDOCTAHEADERDETCRE
	DROP TEMPORARY TABLE IF EXISTS TMP_EDOCTAMONCALCINTMORA;
	CREATE TEMPORARY TABLE TMP_EDOCTAMONCALCINTMORA(
		CreditoID				BIGINT(12),
		MonBaseCalIntMora		DECIMAL(14,2),
		PRIMARY KEY (CreditoID));

	INSERT INTO TMP_EDOCTAMONCALCINTMORA()
	SELECT Edo.CreditoID, IFNULL(ROUND(SUM(Sal.SalCapAtrasado+Sal.SalCapVencido)/(DATEDIFF(MAX(Sal.FechaCorte), MIN(Sal.FechaCorte)) + Con_Entero_Uno),2), Con_Moneda_Cero)
		FROM SALDOSCREDITOS Sal
		INNER JOIN EDOCTARESUMCREDITOS Edo
			WHERE Edo.CreditoID = Sal.CreditoID
			  AND Sal.FechaCorte >= Par_FecIniMes
			  AND Sal.FechaCorte <= Par_FecFinMes
			GROUP BY Edo.CreditoID;

	UPDATE EDOCTAHEADERDETCRE Cre,
			TMP_EDOCTAMONCALCINTMORA Tmp
			SET Cre.MonBaseCalIntMora = Tmp.MonBaseCalIntMora
		WHERE Cre.CreditoID = Tmp.CreditoID;

	-- =============================== INICIO CARGOS ========================== --
	-- CAPITAL ATRASADO
	INSERT INTO EDOCTADETCRE
	SELECT  Par_AnioMes,        Par_SucursalID,            	Con_Entero_Cero,    				Mov.CreditoID,        Mov.FechaOperacion ,
			Var_TipoCapital,    'CAPITAL ATRASADO',   		ROUND(SUM(Mov.Cantidad),2),      	Con_Moneda_Cero, 	  IFNULL(Mov.PolizaID,Con_PolizaCero),
			Con_Entero_Cero,	Con_Entero_Cero,			Con_Entero_Cero,					Con_Entero_Cero
	FROM CREDITOSMOVS Mov
	INNER JOIN AMORTICREDITO Amo
		ON Amo.CreditoID = Mov.CreditoID
		AND Amo.AmortizacionID = Mov.AmortiCreID
	WHERE Mov.FechaOperacion >= Par_FecIniMes
	  AND Mov.FechaOperacion <= Par_FecFinMes
	  AND Mov.TipoMovCreID IN (1,2,3,4)
	  AND Mov.NatMovimiento = NatCargo
	  AND Mov.Descripcion = 'TRASPASO A ATRA'
	GROUP BY Mov.CreditoID, Mov.AmortiCreID, Mov.FechaOperacion, Mov.PolizaID;

	-- INTERES
	INSERT INTO EDOCTADETCRE
	SELECT  Par_AnioMes,     	Par_SucursalID,            	Con_Entero_Cero,    			Mov.CreditoID,        	Mov.FechaOperacion ,
			Var_TipoInteres,    'INTERES',   				ROUND(SUM(Mov.Cantidad),2),		Con_Moneda_Cero,		IFNULL(Mov.PolizaID,Con_PolizaCero),
			Con_Entero_Cero,	Con_Entero_Cero,			Con_Entero_Cero,				Con_Entero_Cero
	FROM CREDITOSMOVS Mov
	INNER JOIN AMORTICREDITO Amo
		ON Amo.CreditoID = Mov.CreditoID
		AND Amo.AmortizacionID = Mov.AmortiCreID
	WHERE Mov.FechaOperacion >= Par_FecIniMes
	  AND Mov.FechaOperacion <= Par_FecFinMes
	  AND Mov.TipoMovCreID IN (10,11,12,13,14,15,16,17)
	  AND Mov.NatMovimiento = NatAbono
	 AND (Mov.Descripcion  LIKE 'PAGO%' OR Mov.Descripcion LIKE 'PREPAGO%')
	GROUP BY Mov.CreditoID, Mov.AmortiCreID, Mov.FechaOperacion, Mov.PolizaID;

	-- IVA DE INTERESES
	INSERT INTO EDOCTADETCRE
	SELECT  Par_AnioMes,     	Par_SucursalID,            	Con_Entero_Cero,    				Mov.CreditoID,        	Mov.FechaOperacion ,
			Var_TipoIVAs,       'IVA',   					ROUND(SUM(Mov.Cantidad),2),      	Con_Moneda_Cero, 		IFNULL(Mov.PolizaID,Con_PolizaCero),
			Con_Entero_Cero,	Con_Entero_Cero,			Con_Entero_Cero,					Con_Entero_Cero
	FROM CREDITOSMOVS Mov
	INNER JOIN AMORTICREDITO Amo
		ON Amo.CreditoID = Mov.CreditoID
        AND Amo.AmortizacionID = Mov.AmortiCreID
	WHERE Mov.FechaOperacion >= Par_FecIniMes
	  AND Mov.FechaOperacion <= Par_FecFinMes
	  AND Mov.TipoMovCreID IN (20,21,22,23,24)
	  AND Mov.NatMovimiento = NatAbono
	  AND (Mov.Descripcion  LIKE 'PAGO%' OR Mov.Descripcion LIKE 'PREPAGO%')
	GROUP BY Mov.CreditoID, Mov.AmortiCreID, Mov.FechaOperacion, Mov.PolizaID;

    -- Se registran los movimientos de Desembolso de Creditos realizados en el periodo
    INSERT INTO EDOCTADETCRE
    SELECT  Par_AnioMes,        Par_SucursalID,            	Con_Entero_Cero,    				Mov.CreditoID,        Mov.FechaOperacion,
			Var_TipoCapital,    'DESEMBOLSO DE CREDITO',   	ROUND(SUM(Mov.Cantidad),2),      	Con_Moneda_Cero, 	  IFNULL(Mov.PolizaID,Con_PolizaCero),
			Con_Entero_Cero,	Con_Entero_Cero,			Con_Entero_Cero,					Con_Entero_Cero
	FROM CREDITOSMOVS Mov
	INNER JOIN AMORTICREDITO Amo
		ON Amo.CreditoID = Mov.CreditoID
		AND Amo.AmortizacionID = Mov.AmortiCreID
	WHERE Mov.FechaOperacion >= Par_FecIniMes
		AND Mov.FechaOperacion <= Par_FecFinMes
		AND Mov.TipoMovCreID = 1
        AND Mov.NatMovimiento = NatCargo
		AND Mov.Descripcion LIKE 'DESEMBOLSO%'
        GROUP BY Mov.CreditoID, Mov.FechaOperacion, Mov.PolizaID;

 	-- INTERES NORMAL
    INSERT INTO EDOCTADETCRE
    SELECT  Par_AnioMes,		Par_SucursalID,            	Con_Entero_Cero,    			CreditoID,       	 	FechaCorte,
			Var_TipoInteres,    'INTERES',   				ROUND(SUM(SalIntOrdinario+SalIntAtrasado+SalIntVencido+SalIntProvision+SalIntNoConta) ,2),
            Con_Moneda_Cero,	IFNULL(NumTransaccion,Con_PolizaCero),					Con_Entero_Cero,			Con_Entero_Cero,
            Con_Entero_Cero,	Con_Entero_Cero
		FROM SALDOSCREDITOS
		WHERE FechaCorte = Par_FecFinMes
        AND (SalIntOrdinario+SalIntAtrasado+SalIntVencido+SalIntProvision+SalIntNoConta)>Con_Entero_Cero
	GROUP BY CreditoID, FechaCorte, NumTransaccion;

	-- IVA INTERES NORMAL
    INSERT INTO EDOCTADETCRE
    SELECT  Par_AnioMes,		Par_SucursalID,            	Con_Entero_Cero,    			Mov.CreditoID,       	 	Mov.FechaCorte,
			Var_TipoInteres,    'IVA',   					ROUND((SUM(Mov.SalIntOrdinario+Mov.SalIntAtrasado+Mov.SalIntVencido+Mov.SalIntProvision+Mov.SalIntNoConta))*Res.ValorIVAInt,2),
            Con_Moneda_Cero,	IFNULL(Mov.NumTransaccion,Con_PolizaCero),					Con_Entero_Cero,			Con_Entero_Cero,
            Con_Entero_Cero,	Con_Entero_Cero
		FROM SALDOSCREDITOS Mov,
			EDOCTARESUMCREDITOS Res
		WHERE Mov.FechaCorte = Par_FecFinMes
        AND (Mov.SalIntOrdinario+Mov.SalIntAtrasado+Mov.SalIntVencido+Mov.SalIntProvision+Mov.SalIntNoConta)>Con_Entero_Cero
        AND Res.CreditoID = Mov.CreditoID
	GROUP BY Res.CreditoID, Mov.FechaCorte, Res.ValorIVAInt, Mov.NumTransaccion;


    -- INTERES MORATORIO
	INSERT INTO EDOCTADETCRE
    SELECT  Par_AnioMes,		Par_SucursalID,            Con_Entero_Cero,    			CreditoID,       	 	FechaCorte,
			Var_TipoInteres,    'MORATORIOS',   			ROUND(SUM(SalMoratorios+SaldoMoraVencido+SaldoMoraCarVen),2),
            Con_Moneda_Cero,	IFNULL(NumTransaccion,Con_PolizaCero),					Con_Entero_Cero,		Con_Entero_Cero,
            Con_Entero_Cero,	Con_Entero_Cero
		FROM SALDOSCREDITOS
		WHERE FechaCorte = Par_FecFinMes
        AND (SalMoratorios+SaldoMoraVencido+SaldoMoraCarVen)>Con_Entero_Cero
	GROUP BY CreditoID, FechaCorte, NumTransaccion;

     -- IVA INTERES MORATORIO
    INSERT INTO EDOCTADETCRE
    SELECT  Par_AnioMes,		Par_SucursalID,            Con_Entero_Cero,    			Mov.CreditoID,       	 	Mov.FechaCorte ,
			Var_TipoInteres,    'IVA',   					ROUND((SUM(Mov.SalMoratorios+Mov.SaldoMoraVencido+Mov.SaldoMoraCarVen))*Res.ValorIVAMora,2),
            Con_Moneda_Cero,	IFNULL(Mov.NumTransaccion,Con_PolizaCero),				Con_Entero_Cero,			Con_Entero_Cero,
            Con_Entero_Cero,	Con_Entero_Cero
		FROM SALDOSCREDITOS Mov,
			EDOCTARESUMCREDITOS Res
		WHERE FechaCorte = Par_FecFinMes
        AND (Mov.SalMoratorios+Mov.SaldoMoraVencido+Mov.SaldoMoraCarVen)>Con_Entero_Cero
        AND Res.CreditoID = Mov.CreditoID
	GROUP BY Res.CreditoID, Mov.CreditoID, Mov.FechaCorte, Res.ValorIVAMora, Mov.NumTransaccion;

	-- COMISION POR ADMINISTRACION
	INSERT INTO EDOCTADETCRE
	SELECT  Par_AnioMes,		Par_SucursalID,							Con_Entero_Cero,					Mov.CreditoID,			Mov.FechaOperacion,
			Var_TipoComision,	'COMISION POR ADMINISTRACION',			ROUND(SUM(Mov.Cantidad),2),			Con_Moneda_Cero,		IFNULL(Mov.PolizaID,Con_PolizaCero),
			Con_Entero_Cero,	Con_Entero_Cero,						Con_Entero_Cero,					Con_Entero_Cero
	FROM CREDITOSMOVS Mov
	INNER JOIN AMORTICREDITO Amo
		ON Amo.CreditoID = Mov.CreditoID
		AND Amo.AmortizacionID = Mov.AmortiCreID
	WHERE Mov.FechaOperacion >= Par_FecIniMes
	  AND Mov.FechaOperacion <= Par_FecFinMes
	  AND Mov.TipoMovCreID IN (42)
	  AND Mov.NatMovimiento = NatAbono
	  AND (Mov.Descripcion  LIKE 'PAGO%' OR Mov.Descripcion LIKE 'PREPAGO%')
	GROUP BY Mov.CreditoID, Mov.AmortiCreID, Mov.FechaOperacion, Mov.PolizaID;

	-- OTRAS COMISIONES
	INSERT INTO EDOCTADETCRE
	SELECT  Par_AnioMes,		Par_SucursalID,							Con_Entero_Cero,					Mov.CreditoID,			Mov.FechaOperacion,
			Var_TipoComision,	'OTRAS COMISIONES',						ROUND(SUM(Mov.Cantidad),2),			Con_Moneda_Cero,		IFNULL(Mov.PolizaID,Con_PolizaCero),
			Con_Entero_Cero,	Con_Entero_Cero,						Con_Entero_Cero,					Con_Entero_Cero
	FROM CREDITOSMOVS Mov
	INNER JOIN AMORTICREDITO Amo
		ON Amo.CreditoID = Mov.CreditoID
		AND Amo.AmortizacionID = Mov.AmortiCreID
	WHERE Mov.FechaOperacion >= Par_FecIniMes
	  AND Mov.FechaOperacion <= Par_FecFinMes
	  AND Mov.TipoMovCreID IN (43)
	  AND Mov.NatMovimiento = NatAbono
	  AND (Mov.Descripcion  LIKE 'PAGO%' OR Mov.Descripcion LIKE 'PREPAGO%')
	GROUP BY Mov.CreditoID, Mov.AmortiCreID, Mov.FechaOperacion, Mov.PolizaID;

	-- COMISIONES LOCALIZADAS EN MOVIMIENTOS DE CUENTAS DE AHORRO
	INSERT INTO EDOCTADETCRE
	SELECT	Par_AnioMes,			Par_SucursalID,					Con_Entero_Cero,
			IF(ReferenciaMov LIKE 'Cred.%', CAST(SUBSTRING(ReferenciaMov,6) AS UNSIGNED), CAST(ReferenciaMov AS UNSIGNED)),
			Fecha,
			Var_TipoComisiCtaAho,
			IF(TipoMovAhoID = 83 OR TipoMovAhoID = 84, CONCAT(DescripcionMov, ' DE CREDITO'), DescripcionMov),
			ROUND(SUM(CantidadMov),2),			Con_Moneda_Cero,		IFNULL(PolizaID,Con_PolizaCero),
			Con_Entero_Cero,		Con_Entero_Cero,				Con_Entero_Cero,					Con_Entero_Cero
	FROM `HIS-CUENAHOMOV`
	WHERE NatMovimiento = NatCargo
	  AND FIND_IN_SET(TipoMovAhoID,Var_TipoMovAhoDetCre) > Con_Entero_Cero
	  AND Fecha >= Par_FecIniMes
	  AND Fecha <= Par_FecFinMes
	GROUP BY ReferenciaMov, Fecha, DescripcionMov, PolizaID, TipoMovAhoID;
	-- =============================== FIN CARGOS ========================== --

	-- =============================== INICIO ABONOS ========================== --
	-- PAGO A CAPITAL
	INSERT INTO EDOCTADETCRE
	SELECT  Par_AnioMes,        	Par_SucursalID,            	Con_Entero_Cero,    		Mov.CreditoID,        			Mov.FechaOperacion ,
			Var_TipoPagoCapital,    'PAGO A CAPITAL',   		Con_Moneda_Cero,			ROUND(SUM(Mov.Cantidad),2), 	IFNULL(Mov.PolizaID,Con_PolizaCero),
			Con_Entero_Cero,		Con_Entero_Cero,			Con_Entero_Cero,			Con_Entero_Cero
	FROM CREDITOSMOVS Mov
	INNER JOIN AMORTICREDITO Amo
		ON Amo.CreditoID = Mov.CreditoID
		AND Amo.AmortizacionID = Mov.AmortiCreID
	WHERE Mov.FechaOperacion >= Par_FecIniMes
	  AND Mov.FechaOperacion <= Par_FecFinMes
	  AND Mov.TipoMovCreID IN (1,2,3,4)
	  AND Mov.NatMovimiento = NatAbono
	  AND (Mov.Descripcion  LIKE 'PAGO%' OR Mov.Descripcion LIKE 'PREPAGO%')
	GROUP BY Mov.CreditoID, Mov.AmortiCreID, Mov.FechaOperacion, Mov.PolizaID;


	-- PAGO A CAPITAL ATRASADO
	INSERT INTO EDOCTADETCRE
	SELECT  Par_AnioMes,        	Par_SucursalID,            		Con_Entero_Cero,    		Mov.CreditoID,        				Mov.FechaOperacion ,
			Var_TipoPagoCapital,    'PAGO A CAPITAL ATRASADO',  	Con_Moneda_Cero,  			ROUND(SUM(Mov.Cantidad),2),       	IFNULL(Mov.PolizaID,Con_PolizaCero),
			Con_Entero_Cero,		Con_Entero_Cero,				Con_Entero_Cero,			Con_Entero_Cero
	FROM CREDITOSMOVS Mov
	INNER JOIN AMORTICREDITO Amo
		ON Amo.CreditoID = Mov.CreditoID
        AND Amo.AmortizacionID = Mov.AmortiCreID
	WHERE Mov.FechaOperacion >= Par_FecIniMes
	  AND Mov.FechaOperacion <= Par_FecFinMes
	  AND Mov.TipoMovCreID = 1
	  AND Mov.NatMovimiento = NatAbono
	  AND Mov.Descripcion =  'TRASPASO A ATRA'
	GROUP BY Mov.CreditoID, Mov.AmortiCreID, Mov.FechaOperacion, Mov.PolizaID;

	-- PAGO DE INTERES
	INSERT INTO EDOCTADETCRE
	SELECT  Par_AnioMes,     		Par_SucursalID,            	Con_Entero_Cero,    	Mov.CreditoID,        				Mov.FechaOperacion ,
			Var_TipoPagoInteres,    'PAGO A INTERES',   		Con_Moneda_Cero, 		ROUND(SUM(Mov.Cantidad),2),       	IFNULL(Mov.PolizaID,Con_PolizaCero),
			Con_Entero_Cero,		Con_Entero_Cero,			Con_Entero_Cero,		Con_Entero_Cero
			FROM CREDITOSMOVS Mov
	INNER JOIN AMORTICREDITO Amo
		ON Amo.CreditoID = Mov.CreditoID
		AND Amo.AmortizacionID = Mov.AmortiCreID
	WHERE Mov.FechaOperacion >= Par_FecIniMes
	  AND Mov.FechaOperacion <= Par_FecFinMes
	  AND Mov.TipoMovCreID IN (10,11,12,13,14,15,16,17)
	  AND Mov.NatMovimiento = NatAbono
	  AND (Mov.Descripcion  LIKE 'PAGO%' OR Mov.Descripcion LIKE 'PREPAGO%')
	GROUP BY Mov.CreditoID, Mov.AmortiCreID, Mov.FechaOperacion, Mov.PolizaID;


	-- PAGO DE IVA
	INSERT INTO EDOCTADETCRE
	SELECT  Par_AnioMes,     		Par_SucursalID,				Con_Entero_Cero,    			Mov.CreditoID,        			Mov.FechaOperacion ,
			Var_TipoPagoIVA,       'PAGO A IVA',        		Con_Moneda_Cero,				ROUND(SUM(Mov.Cantidad),2),  	IFNULL(Mov.PolizaID,Con_PolizaCero),
			Con_Entero_Cero,		Con_Entero_Cero,			Con_Entero_Cero,				Con_Entero_Cero
	FROM CREDITOSMOVS Mov
	INNER JOIN AMORTICREDITO Amo
		ON Amo.CreditoID = Mov.CreditoID
        AND Amo.AmortizacionID = Mov.AmortiCreID
	WHERE Mov.FechaOperacion >= Par_FecIniMes
	  AND Mov.FechaOperacion <= Par_FecFinMes
	  AND Mov.TipoMovCreID IN (20,21,22,23,24)
	  AND Mov.NatMovimiento = NatAbono
	  AND (Mov.Descripcion  LIKE 'PAGO%' OR Mov.Descripcion LIKE 'PREPAGO%')
	GROUP BY Mov.CreditoID, Mov.AmortiCreID, Mov.FechaOperacion, Mov.PolizaID;


	-- INTERESES
    INSERT INTO EDOCTADETCRE
    SELECT  Par_AnioMes,		Par_SucursalID,            	Con_Entero_Cero,    			Mov.CreditoID,
			Par_FecIniMes, 		Var_TipoInteres,   			'INTERES',   					Con_Moneda_Cero,
            IFNULL(ROUND(SUM(Mov.SalIntOrdinario+Mov.SalIntAtrasado+Mov.SalIntVencido+Mov.SalIntProvision+Mov.SalIntNoConta),2)
			+ROUND((SUM(Mov.SalIntOrdinario+Mov.SalIntAtrasado+Mov.SalIntVencido+Mov.SalIntProvision+Mov.SalIntNoConta))*Res.ValorIVAInt,2)
			+ROUND(SUM(Mov.SalMoratorios+Mov.SaldoMoraVencido+Mov.SaldoMoraCarVen),2)
			+ROUND((SUM(Mov.SalMoratorios+Mov.SaldoMoraVencido+Mov.SaldoMoraCarVen))*Res.ValorIVAMora,2),Con_Moneda_Cero) AS Interes,
            IFNULL(Mov.NumTransaccion,Con_PolizaCero),		Con_Entero_Cero,				Con_Entero_Cero,
            Con_Entero_Cero,	Con_Entero_Cero
		FROM SALDOSCREDITOS Mov,
			EDOCTARESUMCREDITOS Res
		WHERE Mov.FechaCorte = Var_FechaCorteAnterior
        AND (Mov.SalIntOrdinario+Mov.SalIntAtrasado+Mov.SalIntVencido+Mov.SalIntProvision+Mov.SalIntNoConta
			+Mov.SalMoratorios+Mov.SaldoMoraVencido+Mov.SaldoMoraCarVen)>Con_Entero_Cero
        AND Res.CreditoID	= Mov.CreditoID
	GROUP BY Res.CreditoID, Res.ValorIVAInt, Mov.NumTransaccion, Mov.CreditoID, Res.ValorIVAMora;



	-- PAGO A COMISION POR ADMINISTRACION
	INSERT INTO EDOCTADETCRE
	SELECT  Par_AnioMes,			Par_SucursalID,							Con_Entero_Cero,		Mov.CreditoID,					Mov.FechaOperacion,
			Var_TipoPagoComision,	'PAGO A COMISION POR ADMINISTRACION',	Con_Moneda_Cero,		ROUND(SUM(Mov.Cantidad),2),		IFNULL(Mov.PolizaID,Con_PolizaCero),
			Con_Entero_Cero,		Con_Entero_Cero,						Con_Entero_Cero,		Con_Entero_Cero
	FROM CREDITOSMOVS Mov
	INNER JOIN AMORTICREDITO Amo
		ON Amo.CreditoID = Mov.CreditoID
		AND Amo.AmortizacionID = Mov.AmortiCreID
	WHERE Mov.FechaOperacion >= Par_FecIniMes
	  AND Mov.FechaOperacion <= Par_FecFinMes
	  AND Mov.TipoMovCreID IN (42)
	  AND Mov.NatMovimiento = NatAbono
	  AND (Mov.Descripcion  LIKE 'PAGO%' OR Mov.Descripcion LIKE 'PREPAGO%')
	GROUP BY Mov.CreditoID, Mov.AmortiCreID, Mov.FechaOperacion, Mov.PolizaID;


	-- OTRAS COMISIONES
	INSERT INTO EDOCTADETCRE
	SELECT  Par_AnioMes,			Par_SucursalID,							Con_Entero_Cero,		Mov.CreditoID,					Mov.FechaOperacion,
			Var_TipoPagoComision,	'OTRAS COMISIONES',						Con_Moneda_Cero,		ROUND(SUM(Mov.Cantidad),2),		IFNULL(Mov.PolizaID,Con_PolizaCero),
			Con_Entero_Cero,		Con_Entero_Cero,						Con_Entero_Cero,		Con_Entero_Cero
	FROM CREDITOSMOVS Mov
	INNER JOIN AMORTICREDITO Amo
		ON Amo.CreditoID = Mov.CreditoID
		AND Amo.AmortizacionID = Mov.AmortiCreID
	WHERE Mov.FechaOperacion >= Par_FecIniMes
	  AND Mov.FechaOperacion <= Par_FecFinMes
	  AND Mov.TipoMovCreID IN (43)
	  AND Mov.NatMovimiento = NatAbono
	  AND (Mov.Descripcion  LIKE 'PAGO%' OR Mov.Descripcion LIKE 'PREPAGO%')
	GROUP BY Mov.CreditoID, Mov.AmortiCreID, Mov.FechaOperacion, Mov.PolizaID;

	-- PAGO POR COMISIONES LOCALIZADAS EN MOVIMIENTOS DE CUENTAS DE AHORRO
	INSERT INTO EDOCTADETCRE
	SELECT	Par_AnioMes,			Par_SucursalID,						Con_Entero_Cero,
			IF(ReferenciaMov LIKE 'Cred.%', CAST(SUBSTRING(ReferenciaMov,6) AS UNSIGNED), CAST(ReferenciaMov AS UNSIGNED)),
			Fecha,
			Var_TipoPagComCtaAho,
			IF(TipoMovAhoID = 83 OR TipoMovAhoID = 84, CONCAT('COBRO DE ', DescripcionMov, ' DE CREDITO'), CONCAT('COBRO DE ', DescripcionMov)),
			Con_Moneda_Cero,		ROUND(SUM(CantidadMov),2),			IFNULL(PolizaID,Con_PolizaCero),
			Con_Entero_Cero,		Con_Entero_Cero,					Con_Entero_Cero,					Con_Entero_Cero
	FROM `HIS-CUENAHOMOV`
	WHERE NatMovimiento = NatCargo
	  AND FIND_IN_SET(TipoMovAhoID,Var_TipoMovAhoDetCre) > Con_Entero_Cero
	  AND Fecha >= Par_FecIniMes
	  AND Fecha <= Par_FecFinMes
	GROUP BY ReferenciaMov, Fecha, DescripcionMov, PolizaID, TipoMovAhoID;
	-- =============================== FIN ABONOS ========================== --

	-- Tabla creada para registrar el saldo inicial del credito para mostrarlo en los
    -- detalles de saldos y movimientos del periodo
	DROP TEMPORARY TABLE IF EXISTS TMP_SALDOINICIAL;
    CREATE TEMPORARY TABLE TMP_SALDOINICIAL(
		CreditoID     BIGINT(12),
        Mov_Saldo     DECIMAL(14,2),
		PRIMARY KEY (CreditoID));

	INSERT INTO TMP_SALDOINICIAL()
	SELECT Edo.CreditoID, Con_Moneda_Cero
		FROM EDOCTARESUMCREDITOS Edo;

    -- Se obtiene el saldo inicial del credito para mostrarlo en los
    -- detalles de saldos y movimientos del periodo
    UPDATE TMP_SALDOINICIAL Tmp,
    		SALDOSCREDITOS Sal,
    		EDOCTARESUMCREDITOS Edo
	SET Tmp.Mov_Saldo = IFNULL(ROUND((Sal.SalCapVigente + Sal.SalCapatrasado + Sal.SalCapVencido + Sal.SalCapVenNoExi),2)
								+ROUND(((Sal.SalIntOrdinario + Sal.SalIntAtrasado + Sal.SalIntVencido + Sal.SalIntProvision + Sal.SalIntNoConta) * (Edo.ValorIVAInt + 1)) ,2)
								+ROUND(((Sal.SalMoratorios + Sal.SaldoMoraVencido + Sal.SaldoMoraCarVen) * (Edo.ValorIVAMora + 1)), 2)
								+ROUND((Sal.SalComFaltaPago * (Edo.ValorIVAAccesorios + 1)), 2)
								+ROUND((Sal.SaldoComServGar * (Edo.ValorIVAAccesorios + 1)), 2)
								+ROUND((Sal.SalOtrasComisi * (Edo.ValorIVAAccesorios + 1)), 2), Con_Moneda_Cero)
		WHERE Tmp.CreditoID = Edo.CreditoID
		  AND Edo.CreditoID = Sal.CreditoID
		  AND Sal.FechaCorte = Var_FechaCorteAnterior;

	-- Se actualiza en el campo SaldoMesAnterior el saldo inicial del periodo
	UPDATE EDOCTARESUMCREDITOS Edo,
		TMP_SALDOINICIAL Sal
        SET Edo.SaldoMesAnterior = Sal.Mov_Saldo
        WHERE Edo.CreditoID = Sal.CreditoID;

	-- Se registra el detalle SALDO INICIAL del credito para mostrarlo
    -- en los detalles de saldos y movimientos del periodo
	INSERT INTO EDOCTADETCRE
    SELECT  Par_AnioMes,        	Par_SucursalID,            Con_Entero_Cero,   	Edo.CreditoID,       Par_FecIniMes,
			Var_TipoSaldoInicial,  	'SALDO INICIAL',   		   Sal.Mov_Saldo,      	Con_Moneda_Cero, 	 Con_Entero_Cero,
			Con_Entero_Cero,		Con_Entero_Cero,		   Con_Entero_Cero,		Con_Entero_Cero
	  FROM TMP_SALDOINICIAL Sal,
			EDOCTARESUMCREDITOS Edo
	 WHERE Sal.CreditoID = Edo.CreditoID
       GROUP BY Edo.CreditoID, Sal.Mov_Saldo;

	-- Se actualiza el numero del cliente en la tabla EDOCTADETCRE
	UPDATE EDOCTADETCRE Edo, CREDITOS Cre
		SET Edo.ClienteID = Cre.ClienteID
	WHERE Edo.CreditoID = Cre.CreditoID;

	-- Se actualiza el numero de sucursal del cliente en la tabla EDOCTADETCRE
	UPDATE EDOCTADETCRE Edo, CLIENTES Cli
		SET Edo.SucursalID = Cli.SucursalOrigen
	WHERE Edo.ClienteID = Cli.ClienteID;

	-- Se crea la tabla temporal para registrar los cargos
    -- y abonos del credito
	DROP TEMPORARY TABLE IF EXISTS TMP_CARGOABONOCREDITOS;
    CREATE TEMPORARY TABLE TMP_CARGOABONOCREDITOS(
		CreditoID     BIGINT(12),
        CargosMes     DECIMAL(14,2),
        AbonoMes      DECIMAL(14,2),
		PRIMARY KEY (CreditoID));

    -- Se registra la suma de los cargos y abonos del credito
    INSERT INTO TMP_CARGOABONOCREDITOS()
	SELECT CreditoID,SUM(Cargos),SUM(Abonos)
	  FROM EDOCTADETCRE
      WHERE TipoMovimi != Var_TipoSaldoInicial
	 GROUP BY CreditoID;

	-- Se actualiza los Abonos y cargos en la tabla EDOCTARESUMCREDITOS
	UPDATE EDOCTARESUMCREDITOS Res,
		TMP_CARGOABONOCREDITOS Edo
	SET Res.Abono = Edo.AbonoMes,
	   Res.Cargo = Edo.CargosMes
	WHERE Res.CreditoID = Edo.CreditoID;


DROP TABLE IF EXISTS TMP_CARGOABONOCREDITOS;
DROP TABLE IF EXISTS TMP_SALDOINICIAL;
DROP TABLE IF EXISTS TMP_EDOCTACOMISION;
DROP TABLE IF EXISTS TMP_EDOCTAMONCALCINTORD;
DROP TABLE IF EXISTS TMP_EDOCTAMONCALCINTMORA;
DROP TABLE IF EXISTS TMP_EDOCTACOMISIONAHO;

END TerminaStore$$