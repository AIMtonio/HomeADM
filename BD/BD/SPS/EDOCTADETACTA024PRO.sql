-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTADETACTA024PRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTADETACTA024PRO`;
DELIMITER $$


CREATE PROCEDURE `EDOCTADETACTA024PRO`(
	--  SP para obtener los detalles de movimientos de la cuenta
	Par_AnioMes				INT(11),		    --  Año y Mes Estado Cuenta
	Par_SucursalID			INT(11),		    --  Numero de Sucursal
	Par_FecIniMes			DATE,			    --  Fecha Inicio Mes
	Par_FecFinMes			DATE,			    --  Fecha Fin Mes
	Par_ClienteInstitu		INT(11)			    --  Cliente Institucion
)

TerminaStore: BEGIN
--  Declaracion de Constantes

	DECLARE	Cadena_Vacia	VARCHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT(11);
	DECLARE	Moneda_Cero		DECIMAL(14,2);
	DECLARE Poliza_Cero		BIGINT(20);

    DECLARE NatCargo		CHAR(1);
	DECLARE NatAbono		CHAR(1);
    DECLARE ClasMovISR		INT(11);
	--  Asignacion de Constantes

	SET Cadena_Vacia		:= '';				--  Cadena Vacia
	SET Fecha_Vacia			:= '1900-01-01';	--  Fecha Vacia
	SET Entero_Cero			:= 0;				--  Entero Cero
	SET Moneda_Cero			:= 0.00;			--  Moneda Cero
	SET Poliza_Cero			:= 0;				--  Poliza Cero

    SET NatCargo        	:= 'C';				--  Naturaleza Movimiento: CARGO
	SET NatAbono			:= 'A';				--  Naturaleza Movimiento: ABONO
    SET ClasMovISR          := 4;				--  Clasificacion de Movimientos ISR

	--  Se registra la informacion de la cuenta
	DROP TEMPORARY TABLE IF EXISTS TMPEDOCTAHISCTA;
	CREATE TEMPORARY TABLE TMPEDOCTAHISCTA (CuentaAhoID		BIGINT,
											FechaCorte		DATE);

	CREATE INDEX IDX_TMPEDOCTAHISCTA_Cuenta ON TMPEDOCTAHISCTA(CuentaAhoID);

	--  Se registra los movimientos de la cuenta
	INSERT INTO TMPEDOCTAHISCTA
	SELECT CuentaAhoID, MIN(Fecha)
	FROM `HIS-CUENTASAHO`
	WHERE   Fecha >= Par_FecIniMes
 	  AND	Fecha <= Par_FecFinMes
    GROUP BY CuentaAhoID;


	INSERT INTO EDOCTADETACTA
	SELECT  Par_AnioMes, 			Entero_Cero,  		Cta.ClienteID,			Cta.CuentaAhoID,	IFNULL(Cta.Etiqueta, 'Sin Etiqueta Definida'),
			Entero_Cero,		  	Cta.CLABE,  		Par_FecIniMes,			Entero_Cero,		'SALDO INICIAL',
			Entero_Cero,			Moneda_Cero, 		Entero_Cero,			Entero_Cero,		Poliza_Cero
	FROM  EDOCTARESUMCTA Cta
	WHERE Cta.ClienteID <> Par_ClienteInstitu;


	UPDATE EDOCTADETACTA Cta
			INNER JOIN TMPEDOCTAHISCTA Tmp	ON Cta.CuentaAhoID = Tmp.CuentaAhoID
			INNER JOIN `HIS-CUENTASAHO` His ON Tmp.CuentaAhoID = His.CuentaAhoID AND His.Fecha = Tmp.FechaCorte
			SET Cta.SaldoInicial = His.SaldoIniMes,
				Cta.Deposito 	 = His.SaldoIniMes,
				Cta.Saldo 		 = His.SaldoIniMes;

	DROP TEMPORARY TABLE IF EXISTS TMPEDOCTAHISCTA;

	INSERT INTO EDOCTADETACTA
	SELECT  Par_AnioMes,			Entero_Cero,		Cta.ClienteID,			Mov.CuentaAhoID,	IFNULL(Cta.Etiqueta, 'Sin Etiqueta Definida'),
			Cta.SaldoMesAnterior,	Cta.CLABE,			Mov.Fecha,				Mov.NumeroMov,		Mov.DescripcionMov,
			CASE Mov.NatMovimiento WHEN NatAbono THEN Mov.CantidadMov
											ELSE Moneda_Cero
			END,
			CASE Mov.NatMovimiento WHEN NatCargo THEN Mov.CantidadMov
											ELSE Moneda_Cero
			END,
			Moneda_Cero,		Mov.TipoMovAhoID,		IFNULL(Mov.PolizaID,Poliza_Cero)
	FROM `HIS-CUENAHOMOV` Mov,
		  EDOCTARESUMCTA Cta
	WHERE Cta.ClienteID <> Par_ClienteInstitu
	  AND Mov.CuentaAhoID = Cta.CuentaAhoID
	  AND Mov.Fecha >= Par_FecIniMes
	  AND Mov.Fecha <= Par_FecFinMes;

		-- Se actualiza la Sucursal Origen del Cliente
	UPDATE EDOCTADETACTA Edo, CLIENTES Cli
	SET  Edo.SucursalID = Cli.SucursalOrigen
	WHERE Edo.ClienteID = Cli.ClienteID;

	 -- Tabla temporal para obtener ISR retenido en el periodo
	DROP TEMPORARY TABLE IF EXISTS TMPISRCTA;
	CREATE TEMPORARY TABLE TMPISRCTA(
        CuentaAhoID     BIGINT(12),
        ISR	            DECIMAL(14,2),
        PRIMARY KEY     (CuentaAhoID));

    -- Se obtiene el ISR retenido en el periodo
    INSERT INTO TMPISRCTA (CuentaAhoID,	ISR)
    SELECT Mov.CuentaAhoID,SUM(CASE WHEN Mov.NatMovimiento = NatCargo THEN Mov.CantidadMov
						ELSE Moneda_Cero END) AS ISR
	 FROM `HIS-CUENAHOMOV` Mov
		INNER JOIN CUENTASAHO Cta
		ON Cta.CuentaAhoID = Mov.CuentaAhoID
		INNER JOIN TIPOSMOVSAHO Tip
		ON Mov.TipoMovAhoID = Tip.TipoMovAhoID
		WHERE Tip.ClasificacionMov = ClasMovISR
		AND Mov.Fecha >= Par_FecIniMes
		AND Mov.Fecha <= Par_FecFinMes
		GROUP BY Mov.CuentaAhoID;

	-- Se actualiza el monto del ISR retenido en el periodo
	UPDATE EDOCTARESUMCTA Edo,
		  TMPISRCTA Tmp
	SET Edo.ISR = IFNULL(Tmp.ISR, Moneda_Cero)
	WHERE Tmp.CuentaAhoID = Edo.CuentaAhoID;

	-- Se actualizan los montos de Retiros y Depositos
	UPDATE EDOCTARESUMCTA
	SET Retiros =  Retiros - ISR;

	INSERT INTO EDOCTADETACTACOM
	SELECT	Cta.AnioMes,			Cta.SucursalID,		Cta.ClienteID,			Cta.CuentaAhoID,		Cta.Transaccion,
			Cadena_Vacia,			Cadena_Vacia,		Entero_Cero,			Entero_Cero,			Fecha_Vacia,
			Cadena_Vacia,			Cadena_Vacia,		Entero_Cero,			Entero_Cero
	FROM  EDOCTADETACTA Cta;

	UPDATE EDOCTADETACTACOM Cta, CLIENTES Cli, SUCURSALES Suc
	SET	Cta.SucursalID = Cli.SucursalOrigen,
		Cta.LugarExp = Suc.NombreSucurs
	WHERE Cta.ClienteID = Cli.ClienteID
	AND Cta.SucursalID = Suc.SucursalID;

	UPDATE EDOCTADETACTACOM Cta, `HIS-CUENAHOMOV` Mov, MONEDAS Mon
	SET	Cta.DescMon = Mon.DescriCorta
	WHERE Cta.CuentaAhoID = Mov.CuentaAhoID
	AND Cta.Transaccion = Mov.NumeroMov
	AND Mov.Fecha >= Par_FecIniMes
	AND Mov.Fecha <= Par_FecFinMes
	AND Mov.MonedaID = Mon.MonedaId;

	DROP TABLE IF EXISTS TMPISRCTA;

END TerminaStore$$
