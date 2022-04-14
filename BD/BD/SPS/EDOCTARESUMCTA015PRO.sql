-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTARESUMCTA015PRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTARESUMCTA015PRO`;
DELIMITER $$


CREATE PROCEDURE `EDOCTARESUMCTA015PRO`(
	-- SP para obtener los Datos de la Cuenta e inversiones
    Par_AnioMes     		INT(11),	-- Anio y Mes Estado Cuenta
    Par_SucursalID  		INT(11),	-- Numero de Sucursal
    Par_FecIniMes   		DATE,		-- Fecha Inicio Mes
    Par_FecFinMes   		DATE,		-- Fecha Fin Mes
	Par_ClienteInstitu		INT(11)		-- Cliente Institucion
		)

TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE	Con_Cadena_Vacia	VARCHAR(1);
	DECLARE	Con_Fecha_Vacia		DATE;
	DECLARE	Con_Entero_Cero		INT(11);
	DECLARE	Con_Moneda_Cero		DECIMAL(14,2);
	DECLARE EstatusActiva		CHAR(1);

	DECLARE EstatusCancelado	CHAR(1);
	DECLARE EstatusBloqueado	CHAR(1);
	DECLARE EstatusInactiva		CHAR(1);
	DECLARE EstatusRegistrada	CHAR(1);
	DECLARE NaturalezaCargo		CHAR(1);

	DECLARE NaturalezaAbono		CHAR(1);
	DECLARE OrigenMovCta        INT(11);
	DECLARE EstatusVigente		CHAR(1);
    DECLARE EstatusPagada		CHAR(1);
	DECLARE Con_GeneraInteres	CHAR(1);

	-- Asignacion de Constantes
	SET Con_Cadena_Vacia			:= '';		       -- Cadena Vacia
	SET Con_Fecha_Vacia				:= '1900-01-01';   -- Fecha Vacia
	SET Con_Entero_Cero				:= 0;		       -- Entero Cero
	SET Con_Moneda_Cero				:= 0.00;	       -- Decimal Cero
	SET EstatusActiva				:= 'A';            -- Estatus de la cuenta: ACTIVA

	SET EstatusCancelado			:= 'C';            -- Estatus de la cuenta: CANCELADA
	SET EstatusBloqueado			:= 'B';            -- Estatus de la cuenta: BLOQUEADA
	SET EstatusInactiva				:= 'I';            -- Estatus de la cuenta: INACTIVA
	SET EstatusRegistrada			:= 'R';  	       -- Estatus de la cuenta: REGISTRADA
	SET NaturalezaCargo				:= 'C';            -- Naturaleza de movimiento: CARGO

	SET NaturalezaAbono				:= 'A';	           -- Naturaleza de movimiento: ABONO
	SET OrigenMovCta                := 1;      		   -- Origen de Movimiento: Cuenta de Ahorro
	SET EstatusVigente	   			:= 'N';			   -- Estatus de la inversion: VIGENTE
	SET EstatusPagada				:= 'P';			   -- Estatus de la inversion: PAGADA
	SET Con_GeneraInteres			:= 'N';			   -- constante para indicar que no generea Interes

	-- Se insertan los datos basicos de la cuenta
	 INSERT INTO EDOCTARESUMCTA (
			AnioMes,		SucursalID,				ClienteID,			CuentaAhoID,		MonedaID,
			MonedaDescri,	Etiqueta,				Depositos,			Retiros,			Interes,
			ISR,			SaldoActual,			SaldoMesAnterior,	SaldoPromedio,		TasaBruta,
			Estatus,		GAT,					CLABE,				TipoCuentaID,		SaldoMInReq,
			Comisiones,		GatInformativo,			ParteSocial, 		GeneraInteres)

	SELECT  Par_AnioMes, 		Cli.SucursalOrigen,	Cli.ClienteID,  	 Cta.CuentaAhoID,    Cta.MonedaID,
			Con_Cadena_Vacia,	Con_Cadena_Vacia,   Cta.AbonosMes,		 Cta.CargosMes,       Cta.InteresesGen,
			Cta.ISR,			Cta.SaldoIniMes + Cta.AbonosMes - Cta.CargosMes,
			Cta.SaldoIniMes,  	Cta.SaldoProm,      Cta.TasaInteres,	CASE Cta.Estatus WHEN EstatusActiva THEN 'ACTIVA'
																											 WHEN EstatusBloqueado THEN 'BLOQUEADA'
																											 WHEN EstatusCancelado THEN 'CANCELADA'
																											 WHEN EstatusInactiva THEN 'INACTIVA'
																											 WHEN EstatusRegistrada THEN 'REGISTRADA'
																													 ELSE 'Estatus No Identificado'
																						   END,
			IFNULL(Gat, Con_Moneda_Cero) AS GAT,			Con_Cadena_Vacia,		   Tc.TipoCuentaID,			Tc.SaldoMinReq,
			Con_Moneda_Cero AS Comisiones, 		   IFNULL(Tc.GatInformativo, Con_Moneda_Cero),			IFNULL(Con_Moneda_Cero, Con_Moneda_Cero),
			Tc.GeneraInteres

	FROM `HIS-CUENTASAHO` Cta
	INNER JOIN CLIENTES Cli ON Cta.ClienteID=Cli.ClienteID AND Cli.ClienteID!=Par_ClienteInstitu
	INNER JOIN TIPOSCUENTAS Tc ON Cta.TipoCuentaID=Tc.TipoCuentaID
	WHERE  Cta.Fecha >= Par_FecIniMes
	  AND Cta.Fecha <= Par_FecFinMes
	  AND Cta.Estatus IN (EstatusActiva,EstatusBloqueado,EstatusCancelado)
	GROUP BY Cta.CuentaAhoID,	Cli.SucursalOrigen,	Cli.ClienteID,    	Cta.MonedaID,  		Cta.AbonosMes,
             Cta.CargosMes,     Cta.InteresesGen,	Cta.ISR,			Cta.SaldoIniMes,	Cta.AbonosMes,Cta.CargosMes,
             Cta.SaldoIniMes,  	Cta.SaldoProm,      Cta.TasaInteres,	Cta.Estatus,  		Gat,
             Tc.TipoCuentaID,	Tc.SaldoMinReq,		Tc.GatInformativo;

	-- Se actualiza la descripcion de la cuenta
	UPDATE EDOCTARESUMCTA Edo, CUENTASAHO Cta,	TIPOSCUENTAS Tc
	SET Edo.Etiqueta = IFNULL(Tc.Descripcion, 'Sin Etiqueta Definida'),
		Edo.CLABE = IFNULL(Cta.Clabe, '')
	WHERE Edo.CuentaAhoID = Cta.CuentaAhoID AND Cta.TipoCuentaID=Tc.TipoCuentaID;

	-- Se actualiza la descripcion de la moneda
	UPDATE EDOCTARESUMCTA Edo, MONEDAS Mon
	SET Edo.MonedaDescri = Mon.DescriCorta
	WHERE Edo.MonedaID = Mon.MonedaId;

	-- Se actualiza la descripcion de la moneda
	UPDATE  EDOCTARESUMCTA Cta
		INNER JOIN APORTACIONSOCIO Apo ON Apo.ClienteID=Cta.ClienteID
		SET Cta.ParteSocial = IFNULL(Apo.Saldo, Con_Moneda_Cero);

	-- Se obtiene el monto de las comisiones
	TRUNCATE TABLE TMPCOMISIONESEDOCTA;
	INSERT INTO TMPCOMISIONESEDOCTA(CuentaAhoID, CantidadMov)
	SELECT Mov.CuentaAhoID, SUM(CASE WHEN  Mov.NatMovimiento = NaturalezaCargo THEN Mov.CantidadMov ELSE Con_Moneda_Cero END)  -
			  SUM(CASE WHEN Mov.NatMovimiento = NaturalezaAbono THEN Mov.CantidadMov ELSE Con_Moneda_Cero END) AS Comision
		FROM `HIS-CUENAHOMOV` Mov
		INNER JOIN TIPOSMOVSAHO Tip ON Mov.TipoMovAhoID=Tip.TipoMovAhoID
		WHERE Tip.OrigenMov = OrigenMovCta
		AND Mov.DescripcionMov LIKE 'COMISION%'
		AND  Mov.Fecha >= Par_FecIniMes
		AND Mov.Fecha <= Par_FecFinMes
		GROUP BY Mov.CuentaAhoID;

	-- Se actualiza el monto de las comisiones de las cuentas
	UPDATE EDOCTARESUMCTA Cta INNER JOIN TMPCOMISIONESEDOCTA  Tmp ON Tmp.CuentaAhoID = Cta.CuentaAhoID
		SET Cta.Comisiones = IFNULL(Tmp.CantidadMov, Con_Moneda_Cero);

	-- ####### RESUMEN INVERSIONES  ########### ---
	DROP TEMPORARY TABLE IF EXISTS TMPRESUMINV;
    CREATE TEMPORARY TABLE TMPRESUMINV(
		AnioMes				INT(11),
        SucursalID			INT(11),
        ClienteID			INT(11),
        CuentaAhoID			BIGINT(12),
        MonedaID			INT(11),
        MonedaDescri		VARCHAR(45),
        Etiqueta			VARCHAR(60),
        Depositos			DECIMAL(14,2),
        Retiros				DECIMAL(14,2),
        Interes				DECIMAL(14,2),
        ISR					DECIMAL(14,2),
        SaldoActual			DECIMAL(14,2),
        SaldoMesAnterior	DECIMAL(14,2),
        SaldoPromedio		DECIMAL(14,2),
        TasaBruta			DECIMAL(14,2),
        Estatus				VARCHAR(20),
        GAT					DECIMAL(12,2),
        CLABE				VARCHAR(18),
        TipoCuentaID		INT(11),
        SaldoMInReq			DECIMAL(12,2),
        Comisiones			DECIMAL(12,2),
        GatInformativo		DECIMAL(12,2),
        ParteSocial			DECIMAL(14,2));

    CREATE INDEX CuentaAhoID ON TMPRESUMINV (CuentaAhoID);

	INSERT INTO TMPRESUMINV
	SELECT  Par_AnioMes, 		Cli.SucursalOrigen,		Cli.ClienteID,  	 Inv.InversionID,    Inv.MonedaID,
			Con_Cadena_Vacia, 	Con_Cadena_Vacia,
            CASE WHEN Inv.FechaInicio >= Par_FecIniMes THEN  Inv.Monto ELSE Con_Moneda_Cero END AS Depositos,
			CASE WHEN Inv.Estatus IN(EstatusPagada,EstatusCancelado) THEN Inv.Monto + Inv.SaldoProvision
				ELSE Con_Moneda_Cero END AS Retiros,
			CASE WHEN Inv.Estatus IN(EstatusPagada,EstatusCancelado) THEN Inv.SaldoProvision
				ELSE Con_Moneda_Cero END AS Interes,
			Con_Moneda_Cero, CASE WHEN Inv. Estatus = EstatusVigente THEN
					Inv.Monto ELSE Con_Moneda_Cero  END AS SaldoActual,
			CASE WHEN Inv.FechaInicio >= Par_FecIniMes THEN Con_Moneda_Cero ELSE Inv.Monto END AS SaldoMesAnterior,
             Con_Moneda_Cero AS SaldoPromedio,     Inv.Tasa,	CASE Inv.Estatus WHEN EstatusPagada THEN 'PAGADA'
																	 WHEN EstatusVigente THEN 'VIGENTE'
																	 WHEN EstatusCancelado THEN 'CANCELADA'
																	 WHEN EstatusInactiva THEN 'INACTIVA'
																	 ELSE 'Estatus No Identificado'END AS Estatus,
			IFNULL(ValorGatReal, 	Con_Moneda_Cero) AS GAT,	Con_Cadena_Vacia,		  			Inv.TipoInversionID,
            Con_Moneda_Cero,		Con_Moneda_Cero, 			IFNULL(ValorGat, Con_Moneda_Cero),	Con_Moneda_Cero

	FROM INVERSIONES Inv
	INNER JOIN CLIENTES Cli ON Inv.ClienteID = Cli.ClienteID
	INNER JOIN CATINVERSION Tc ON Inv.TipoInversionID = Tc.TipoInversionID
	 WHERE (Inv.Estatus = EstatusVigente
		OR (Inv.Estatus = EstatusPagada
			AND Inv.FechaVencimiento >= Par_FecIniMes
			AND Inv.FechaVencimiento <= Par_FecFinMes)
		OR (Inv.Estatus = EstatusCancelado
			AND Inv.FechaVenAnt >= Par_FecIniMes
			AND Inv.FechaVenAnt <= Par_FecFinMes)
		OR (Inv.Estatus = EstatusCancelado
			AND Inv.FechaVenAnt = Con_Fecha_Vacia
			AND Inv.FechaInicio >= Par_FecIniMes
			AND Inv.FechaInicio <= Par_FecFinMes
			AND Inv.InversionRenovada > Con_Entero_Cero));

	-- Se actualiza la descripcion de la moneda
	UPDATE TMPRESUMINV T, MONEDAS M SET
	MonedaDescri = DescriCorta
	WHERE T.MonedaID = M.MonedaID;

	-- Tabla temporal para obtener el monto de los intereses generados del periodo
	DROP TEMPORARY TABLE IF EXISTS TMPINTERESMES;
	CREATE TEMPORARY TABLE TMPINTERESMES (
		InversionID		INT(11),
        Interes			DECIMAL(12,2));

	CREATE INDEX InversionID ON TMPINTERESMES (InversionID);

    INSERT INTO TMPINTERESMES
	SELECT InversionID, SUM(Monto)
    FROM INVERSIONESMOV
    WHERE Fecha BETWEEN Par_FecIniMes
    AND Par_FecFinMes
	AND NatMovimiento = NaturalezaCargo
    GROUP BY InversionID;


	UPDATE TMPRESUMINV R, TMPINTERESMES I SET
	R.Interes = I.Interes
	WHERE R.CuentaAhoID = I.InversionID;

	-- Tabla temporal para obtener el monto de los intereses generados del periodo
	DROP TEMPORARY TABLE IF EXISTS TMPINTERESMES;
	CREATE TEMPORARY TABLE TMPINTERESMES (
		InversionID		INT(11),
        Monto			DECIMAL(12,2));

	CREATE INDEX InversionID ON TMPINTERESMES (InversionID);

	INSERT INTO TMPINTERESMES
	SELECT  InversionID, SUM(Monto)
    FROM INVERSIONESMOV
    WHERE Fecha < Par_FecIniMes
    AND NatMovimiento = NaturalezaCargo
    GROUP BY InversionID;

	-- Se actualiza el saldo del mes anterior
	UPDATE TMPRESUMINV R,  TMPINTERESMES I SET
	R.SaldoMesAnterior = R.SaldoMesAnterior + I.Monto
	WHERE R.CuentaAhoID = I.InversionID;

	-- Se actualiza el valor del interes para inversiones pagadas o canceladas
    UPDATE TMPRESUMINV
    SET Interes = CASE WHEN SaldoMesAnterior = Retiros THEN
					Con_Moneda_Cero ELSE Interes END
	WHERE Estatus <> 'VIGENTE';

	-- Se actualiza el valor del saldo actual
	UPDATE TMPRESUMINV SET
	SaldoActual = SaldoMesAnterior + Depositos + Interes - Retiros;

	-- Se actualiza la descripcion
	UPDATE TMPRESUMINV R, INVERSIONES I  SET
	R.Etiqueta = CONCAT('INVERSION A ', I.Plazo, ' DIAS')
	WHERE R.CuentaAhoID = I.InversionID;

	-- Se inserta el valor de las inversiones en EDOCTARESUMCTA para mostrarlo en el resumen de AHORRO E INVERSION en el Estado de Cuenta de SOFIEXPRESS
	INSERT INTO EDOCTARESUMCTA (
			AnioMes,		SucursalID,		ClienteID,			CuentaAhoID,		MonedaID,
			MonedaDescri,	Etiqueta,		Depositos,			Retiros,			Interes,
			ISR,			SaldoActual,	SaldoMesAnterior,	SaldoPromedio,		TasaBruta,
			Estatus,		GAT,			CLABE,				TipoCuentaID,		SaldoMInReq,
			Comisiones,		GatInformativo,	ParteSocial, 		GeneraInteres)

	SELECT 	AnioMes,		SucursalID,		ClienteID,			CuentaAhoID,		MonedaID,
			MonedaDescri,	Etiqueta,		Depositos,			Retiros,			Interes,
			ISR,			SaldoActual,	SaldoMesAnterior,	SaldoPromedio,		TasaBruta,
			Estatus,		GAT,			CLABE,				TipoCuentaID,		SaldoMInReq,
			Comisiones,		GatInformativo,	ParteSocial,		Con_GeneraInteres
    FROM TMPRESUMINV;

	DROP TEMPORARY TABLE IF EXISTS TMPRESUMINV;
    DROP TEMPORARY TABLE IF EXISTS TMPINTERESMES;

END TerminaStore$$