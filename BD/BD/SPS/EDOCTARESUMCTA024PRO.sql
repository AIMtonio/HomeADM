-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTARESUMCTA024PRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTARESUMCTA024PRO`;
DELIMITER $$


CREATE PROCEDURE `EDOCTARESUMCTA024PRO`(

    Par_AnioMes     		INT(11),	-- Año y Mes Estado Cuenta
    Par_SucursalID  		INT(11),	-- Numero de Sucursal
    Par_FecIniMes   		DATE,		-- Fecha Inicio Mes
    Par_FecFinMes   		DATE,		-- Fecha Fin Mes
	Par_ClienteInstitu		INT(11)		-- Cliente Institucion
		)

TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		VARCHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Fecha_Corte			DATE;
	DECLARE	Entero_Cero			INT(11);
	DECLARE	Moneda_Cero			DECIMAL(14,2);
	DECLARE EstatusActiva		CHAR(1);

	DECLARE EstatusCancelado	CHAR(1);
	DECLARE EstatusBloqueado	CHAR(1);
	DECLARE EstatusInactiva		CHAR(1);
	DECLARE EstatusRegistrada	CHAR(1);
	DECLARE NaturalezaCargo		CHAR(1);

    DECLARE NaturalezaAbono		CHAR(1);
    DECLARE OrigenMovCta        INT(11);

	-- Asignacion de Constantes
	SET Cadena_Vacia			:=	'';					-- Cadena Vacia
	SET Fecha_Vacia				:=	'1900-01-01';		-- Fecha Vacia
	SET Entero_Cero				:= 	0;					-- Entero Cero
	SET Moneda_Cero				:=	0.00;				-- Decimal Cero
	SET EstatusActiva			:=	'A';      			-- Estatus de la cuenta: ACTIVA

	SET EstatusCancelado		:=	'C';       			-- Estatus de la cuenta: CANCELADA
	SET EstatusBloqueado		:=	'B';            	-- Estatus de la cuenta: BLOQUEADA
	SET EstatusInactiva			:=	'I';            	-- Estatus de la cuenta: INACTIVA
	SET EstatusRegistrada		:=	'R';  			 	-- Estatus de la cuenta: REGISTRADA
	SET NaturalezaCargo			:=	'C';				-- Naturaleza de movimiento: CARGO

	SET NaturalezaAbono			:= 'A';	           		-- Naturaleza de movimiento: ABONO
	SET OrigenMovCta            := 1;      		   		-- Origen de Movimiento: Cuenta de Ahorro



	DROP TEMPORARY TABLE IF EXISTS TMPEDOCTAHISCTA;
	CREATE TEMPORARY TABLE TMPEDOCTAHISCTA (CuentaAhoID		BIGINT,
											FechaCorte		DATE,
											FechaInicio		DATE);

	CREATE INDEX IDX_TMPEDOCTAHISCTA_Cuenta ON TMPEDOCTAHISCTA(CuentaAhoID);

	INSERT INTO TMPEDOCTAHISCTA
	SELECT CuentaAhoID, MAX(Fecha), MIN(Fecha)
	FROM `HIS-CUENTASAHO`
	WHERE   Fecha >= Par_FecIniMes
 	  AND	Fecha <= Par_FecFinMes
 	GROUP BY CuentaAhoID;


	-- Se insertan los datos basicos de la cuenta
	 INSERT INTO EDOCTARESUMCTA (
			AnioMes,		SucursalID,				ClienteID,			CuentaAhoID,		MonedaID,
			MonedaDescri,	Etiqueta,				Depositos,			Retiros,			Interes,
			ISR,			SaldoActual,			SaldoMesAnterior,	SaldoPromedio,		TasaBruta,
			Estatus,		GAT,					CLABE,				TipoCuentaID,		SaldoMInReq,
			Comisiones,		GatInformativo,			ParteSocial,		GeneraInteres)

	SELECT  Par_AnioMes, 		Cli.SucursalOrigen,	Cli.ClienteID,  	 Cta.CuentaAhoID,    Cta.MonedaID,
			Cadena_Vacia,		Cadena_Vacia,   	Cta.AbonosMes,		 Cta.CargosMes,       Cta.InteresesGen,
			Cta.ISR,			Cta.Saldo,        	Cta.SaldoIniMes,  	 Cta.SaldoProm,      Cta.TasaInteres,
			CASE Cta.Estatus WHEN EstatusActiva then 'ACTIVA'
			 WHEN EstatusBloqueado then 'BLOQUEADA'
			 WHEN EstatusCancelado then 'CANCELADA'
			 WHEN EstatusInactiva then 'INACTIVA'
			 WHEN EstatusRegistrada then 'REGISTRADA'
			 ELSE 'Estatus No Identificado'
			END,
			IFNULL(Gat, Moneda_Cero) as GAT,		Cadena_Vacia,		   Tc.TipoCuentaID,			Tc.SaldoMinReq,
			Moneda_Cero as Comisiones, 		   IFNULL(Tc.GatInformativo, Moneda_Cero),			IFNULL(Moneda_Cero, Moneda_Cero),
			Tc.GeneraInteres
	FROM `HIS-CUENTASAHO` Cta
	INNER JOIN TMPEDOCTAHISCTA Tmp ON Cta.CuentaAhoID = Tmp.CuentaAhoID AND Cta.Fecha = Tmp.FechaCorte
	INNER JOIN CLIENTES Cli ON Cta.ClienteID=Cli.ClienteID AND Cli.ClienteID!=Par_ClienteInstitu
	INNER JOIN TIPOSCUENTAS Tc ON Cta.TipoCuentaID=Tc.TipoCuentaID
-- 	WHERE  Cta.Fecha >= Par_FecIniMes
-- 	  AND Cta.Fecha <= Par_FecFinMes
-- 	 WHERE Cta.Fecha = Fecha_Corte
	WHERE Cta.Estatus IN (EstatusActiva, EstatusBloqueado, EstatusCancelado)
	GROUP BY Cta.CuentaAhoID,	Cli.SucursalOrigen,	Cli.ClienteID,    	Cta.MonedaID,  		Cta.AbonosMes,
             Cta.CargosMes,     Cta.InteresesGen,	Cta.ISR,			Cta.SaldoIniMes,	Cta.AbonosMes,Cta.CargosMes,
             Cta.SaldoIniMes,  	Cta.SaldoProm,      Cta.Saldo,			Cta.TasaInteres,	Cta.Estatus,  		Cta.Gat,
             Tc.TipoCuentaID,	Tc.SaldoMinReq,		Tc.GatInformativo;

	UPDATE EDOCTARESUMCTA Edo
	INNER JOIN TMPEDOCTAHISCTA Tmp ON Edo.CuentaAhoID = Tmp.CuentaAhoID
	INNER JOIN `HIS-CUENTASAHO` Cta ON Tmp.CuentaAhoID = Cta.CuentaAhoID AND Cta.Fecha = Tmp.FechaInicio
	SET Edo.SaldoMesAnterior = Cta.SaldoIniMes;

	DROP TEMPORARY TABLE IF EXISTS TMPEDOCTAHISCTA;

	DROP TEMPORARY TABLE IF EXISTS TMPEDOCTASUMAMOVS;

	CREATE TEMPORARY TABLE TMPEDOCTASUMAMOVS(	CuentaAhoID		BIGINT(20),
												SumaDepositos	DECIMAL(14,2),
												SumaRetiros		DECIMAL(14,2),
												SumaIntereses	DECIMAL(14,2),
												SumaISR			DECIMAL(14,2),
												SaldoProm		DECIMAL(14,2));

	CREATE INDEX IDX_TMPEDOCTASUMAMOVS_Cuenta ON TMPEDOCTASUMAMOVS(CuentaAhoID);

	INSERT INTO TMPEDOCTASUMAMOVS
		SELECT CuentaAhoID, SUM(AbonosMes), SUM(CargosMes), SUM(InteresesGen), SUM(ISR), AVG(SaldoProm)
			FROM `HIS-CUENTASAHO`
			WHERE   Fecha >= Par_FecIniMes
 	  			AND	Fecha <= Par_FecFinMes
  			GROUP BY CuentaAhoID;

	UPDATE EDOCTARESUMCTA Edo, TMPEDOCTASUMAMOVS Tmp
		SET Edo.Depositos 		= Tmp.SumaDepositos,
			Edo.Retiros 		= Tmp.SumaRetiros,
			Edo.Interes 		= Tmp.SumaIntereses,
			Edo.ISR				= Tmp.SumaISR,
			Edo.SaldoPromedio	= Tmp.SaldoProm
		WHERE Edo.CuentaAhoID = Tmp.CuentaAhoID;

	DROP TEMPORARY TABLE IF EXISTS TMPEDOCTASUMAMOVS;
	-- Se actualiza la descripcion de la cuenta
	UPDATE EDOCTARESUMCTA Edo, CUENTASAHO Cta,	TIPOSCUENTAS Tc
	SET Edo.Etiqueta = IFNULL(Tc.Descripcion, 'Sin Etiqueta Definida'),
		Edo.CLABE = IFNULL(Cta.Clabe, '')
	WHERE Edo.CuentaAhoID = Cta.CuentaAhoID AND Cta.TipoCuentaID=Tc.TipoCuentaID;

	-- Se actualiza la descripcion de la moneda
	UPDATE EDOCTARESUMCTA Edo, MONEDAS Mon
	SET Edo.MonedaDescri = Mon.DescriCorta
	WHERE Edo.MonedaID = Mon.MonedaId;

	-- Se actualiza la aportacion social

	UPDATE  EDOCTARESUMCTA Cta
		INNER JOIN APORTACIONSOCIO Apo ON Apo.ClienteID=Cta.ClienteID
		SET Cta.ParteSocial = IFNULL(Apo.Saldo, Moneda_Cero);

	-- Se obtiene el monto de las comisiones de las cuentas
	TRUNCATE TABLE TMPCOMISIONESEDOCTA;
	INSERT INTO TMPCOMISIONESEDOCTA(CuentaAhoID, CantidadMov)
	SELECT Mov.CuentaAhoID, SUM(CASE WHEN  Mov.NatMovimiento = NaturalezaCargo THEN Mov.CantidadMov ELSE Moneda_Cero END)  -
			  SUM(CASE WHEN Mov.NatMovimiento = NaturalezaAbono THEN Mov.CantidadMov ELSE Moneda_Cero END) AS Comision
		FROM `HIS-CUENAHOMOV` Mov
		INNER JOIN TIPOSMOVSAHO Tip ON Mov.TipoMovAhoID = Tip.TipoMovAhoID
		WHERE Tip.OrigenMov = OrigenMovCta
		AND Mov.DescripcionMov LIKE 'COMISION%'
		AND  Mov.Fecha >= Par_FecIniMes
		AND Mov.Fecha <= Par_FecFinMes
		GROUP BY Mov.CuentaAhoID;

	-- Se actualiza el monto de las comisiones de las cuentas
	UPDATE EDOCTARESUMCTA Cta INNER JOIN TMPCOMISIONESEDOCTA  Tmp ON Tmp.CuentaAhoID = Cta.CuentaAhoID
		SET Cta.Comisiones = IFNULL(Tmp.CantidadMov, Moneda_Cero);

	-- Se inserta información complementaria para reporte EDOCUENTA
	INSERT INTO EDOCTARESUMCTACOM
	SELECT
		RES.ClienteID,	RES.CuentaAhoID,	Moneda_Cero,	Entero_Cero,	Entero_Cero,
		Fecha_Vacia,	Cadena_Vacia,		Cadena_Vacia,	Entero_Cero,	Entero_Cero
	FROM EDOCTARESUMCTA RES;

	UPDATE EDOCTARESUMCTACOM COM INNER JOIN  EDOCTARESUMCTA RES ON RES.ClienteID = COM.ClienteID AND RES.CuentaAhoID = COM.CuentaAhoID
		SET COM.IVAComisones = (RES.Comisiones * (CASE WHEN (SELECT Cl1.PagaIVA FROM CLIENTES Cl1 WHERE Cl1.ClienteID=RES.ClienteID) = 'S'
															THEN (SELECT SU.IVA
															FROM SUCURSALES SU
															WHERE SU.SucursalID = (SELECT CL2.SucursalOrigen
															FROM CLIENTES CL2
															where CL2.ClienteID=RES.ClienteID))
															ELSE 0.00 END));

END TerminaStore$$
