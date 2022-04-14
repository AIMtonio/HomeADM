-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTARESUMINV015PRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTARESUMINV015PRO`;DELIMITER $$

CREATE PROCEDURE `EDOCTARESUMINV015PRO`(
	-- SP para generar informacion de Inversiones
    Par_AnioMes     INT(11),		-- Anio y Mes Estado Cuenta
    Par_SucursalID  INT(11),		-- Numero de Sucursal
    Par_FecIniMes   DATE,			-- Fecha Inicio Mes
    Par_FecFinMes   DATE			-- Fecha Fin Mes
	)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE	Con_Cadena_Vacia	VARCHAR(1);
	DECLARE	Con_Fecha_Vacia		DATE;
	DECLARE	Con_Entero_Cero		INT(11);
	DECLARE	Con_Moneda_Cero		DECIMAL(14,2);
	DECLARE Con_StaVigente		CHAR(1);

	DECLARE Con_StaPagado		CHAR(1);
	DECLARE Con_StaCancelado	CHAR(1);
	DECLARE NatCargo			CHAR(1);
	DECLARE NatAbono			CHAR(1);

	-- Asignacion de Constantes
	SET Con_Cadena_Vacia		:= '';				 -- Cadena Vacia
	SET Con_Fecha_Vacia			:= '1900-01-01';	 -- Fecha Vacia
	SET Con_Entero_Cero			:= 0;				 -- Entero Cero
	SET Con_Moneda_Cero			:= 0.00;		     -- Decimal Cero
	SET Con_StaVigente	   		:= 'N';				 -- Estatus de la inversion: VIGENTE

	SET Con_StaPagado			:= 'P';				 -- Estatus de la inversion: PAGADA
	SET Con_StaCancelado		:= 'C';				 -- Estatus de la inversion: CANCELADA
	SET NatCargo				:= 'C';				 -- Naturaleza de movimiento: CARGO
	SET NatAbono				:= 'A';				 -- Naturaleza de movimiento: ABONO

	-- Se obtiene datos para el encabezado de inversiones Pagadas en el periodo
	INSERT INTO EDOCTAHEADERINV
    SELECT Par_AnioMes, 		Con_Entero_Cero, 	ClienteID,			CuentaAhoID,		InversionID,
		  Con_Cadena_Vacia,		Monto,				FechaInicio,		FechaVencimiento,	Tasa,
		  Plazo,				Estatus,			IFNULL(ValorGat, Con_Moneda_Cero)
    FROM INVERSIONES
    WHERE Estatus = Con_StaPagado
    AND FechaVencimiento >= Par_FecIniMes
    AND FechaVencimiento <= Par_FecFinMes;

    -- Se obtiene datos para el encabezado de inversiones Canceladas en el periodo
	INSERT INTO EDOCTAHEADERINV
    SELECT Par_AnioMes, 		Con_Entero_Cero, 	ClienteID,			CuentaAhoID,		InversionID,
		  Con_Cadena_Vacia,		Monto,				FechaInicio,		FechaVencimiento,	Tasa,
		  Plazo,				Estatus,			IFNULL(ValorGat, Con_Moneda_Cero)
    FROM INVERSIONES
    WHERE Estatus = Con_StaCancelado
    AND FechaVenAnt >= Par_FecIniMes
    AND FechaVenAnt <= Par_FecFinMes;

	-- Se obtiene datos para el encabezado de inversiones Vigentes en el periodo
	INSERT INTO EDOCTAHEADERINV
    SELECT Par_AnioMes,			Con_Entero_Cero, 	ClienteID,		CuentaAhoID,		InversionID,
		   Con_Cadena_Vacia,	Monto,			    FechaInicio,	FechaVencimiento,	Tasa,
		   Plazo,				Estatus,			IFNULL(ValorGat, Con_Moneda_Cero)
    FROM INVERSIONES
    WHERE Estatus = Con_StaVigente;

	-- Se actualiza la sucursal del cliente
	UPDATE EDOCTAHEADERINV Edo, CLIENTES Cli
		SET Edo.SucursalID = Cli.SucursalOrigen
	   WHERE Edo.ClienteID = Cli.ClienteID;

	-- Se obtiene el monto de la inversion
	INSERT INTO EDOCTARESUM015INV
	SELECT  InversionID,	'APERTURA CAPITAL',	Con_Moneda_Cero, 	Con_Moneda_Cero,	Con_Moneda_Cero,
		Con_Moneda_Cero,	Con_Moneda_Cero,    Con_Moneda_Cero,	Con_Moneda_Cero,	InvCapital,
        Con_Moneda_Cero,	1,					FechaInicio,		InversionID,        Con_Cadena_Vacia
	FROM  EDOCTAHEADERINV
	WHERE FechaInicio >= Par_FecIniMes
		AND Fechainicio <= Par_FecFinMes;

    -- Tabla temporal para el registro de movimientos de inversiones
	DROP TABLE IF EXISTS TMPINVERSIONES;
	CREATE TEMPORARY TABLE TMPINVERSIONES(
		ReferenciaMov			INT(11),
		DescripcionMov			VARCHAR(150),
		NatMovimiento			CHAR(1),
		Fecha					DATE,
		NumeroMov				BIGINT(20),
		TipoMovAhoID			CHAR(4),
		CantidadMov				DECIMAL(12,2),
		CuentaAhoID				BIGINT(12));
   -- Se obtiene el registro de movimientos de inversiones
   INSERT INTO TMPINVERSIONES
	SELECT 	CAST(Mov.ReferenciaMov AS UNSIGNED) AS ReferenciaMov,   	Mov.DescripcionMov,	Mov.NatMovimiento,
								Mov.Fecha,			Mov.NumeroMov,  Mov.TipoMovAhoID,Mov.CantidadMov , Mov.CuentaAhoID
	   FROM `HIS-CUENAHOMOV` Mov
	   WHERE TipoMovAhoID IN (61,62,63,65,67,68)
		AND Mov.Fecha >= Par_FecIniMes
		AND Mov.Fecha <= Par_FecFinMes;

	-- Se inserta los movimientos de inversiones del periodo
	INSERT INTO EDOCTARESUM015INV
	SELECT 	Res.InversionID,   	Mov.DescripcionMov,		Con_Moneda_Cero, 	Con_Moneda_Cero,	Con_Moneda_Cero,
			Con_Moneda_Cero,	Con_Moneda_Cero,		Con_Moneda_Cero,	Con_Moneda_Cero,
            CASE  WHEN Mov.NatMovimiento = NatCargo THEN Mov.CantidadMov ELSE Con_Moneda_Cero END,
            CASE  WHEN Mov.NatMovimiento = NatAbono  THEN Mov.CantidadMov ELSE Con_Moneda_Cero END,
            	2,					Mov.Fecha,			Mov.ReferenciaMov,			Mov.TipoMovAhoID
	   FROM  TMPINVERSIONES Mov, EDOCTAHEADERINV Res
	   WHERE Mov.ReferenciaMov = Res.InversionID
       AND Mov.CuentaAhoID = Res.CuentaAhoID;

	-- Se inserta el monto de los intereses ganados
	INSERT INTO EDOCTARESUM015INV
	SELECT 	Mov.InversionID, 	'CIERRE INTERESES GANADOS',	Con_Moneda_Cero, 	Con_Moneda_Cero,	Con_Moneda_Cero,
			Con_Moneda_Cero,	Con_Moneda_Cero,			Con_Moneda_Cero,	Con_Moneda_Cero,	 Mov.SaldoProvision,
			Con_Moneda_Cero,	3,							Mov.FechaCorte,		Mov.InversionID,     Con_Cadena_Vacia

	FROM HISINVERSIONES Mov, EDOCTAHEADERINV Res
	   WHERE Mov.InversionID  = Res.InversionID
		AND Mov.FechaCorte = Par_FecFinMes
		AND Mov.Estatus = Con_StaVigente;

    -- Se actualiza los valores de las inversiones pagadas y que no se aperturaron en el periodo
	UPDATE EDOCTARESUMCTA Edo,
		 EDOCTAHEADERINV Hea,
		 INVERSIONES Inv
	SET Edo.SaldoMesAnterior = Inv.Monto,
	  Edo.Interes = Inv.InteresGenerado,
	  Edo.Retiros = Inv.Monto + Inv.InteresGenerado
	  WHERE Hea.Estatus = Con_StaPagado
	  AND Hea.FechaInicio < Par_FecIniMes
	  AND Edo.CuentaAhoID = Hea.InversionID
	  AND Hea.INversionID = Inv.InversionID;

    --  Se actualiza el valor del saldo del mes anterior a 0 en caso de que inicie y se venza la inversion en el mismo periodo
	UPDATE EDOCTARESUMCTA Edo,
		 EDOCTAHEADERINV Hea,
		 INVERSIONES Inv
	SET Edo.SaldoMesAnterior = Con_Moneda_Cero
	  WHERE Hea.Estatus = Con_StaPagado
	  AND Hea.FechaInicio >= Par_FecIniMes
	  AND Edo.CuentaAhoID = Hea.InversionID
	  AND Hea.InversionID = Inv.InversionID;

	-- Se actualiza el valor del saldo actual de todas las inversiones
	UPDATE EDOCTARESUMCTA Edo,
		  EDOCTAHEADERINV Hea
	SET Edo.SaldoActual = Edo.SaldoMesAnterior + Edo.Depositos + Edo.Interes - Edo.Retiros
    WHERE  Edo.CuentaAhoID = Hea.InversionID;


END TerminaStore$$