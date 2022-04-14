-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTADETACTA099PRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTADETACTA099PRO`;
DELIMITER $$


CREATE PROCEDURE `EDOCTADETACTA099PRO`(
	--  SP para obtener los detalles de movimientos de la cuenta
    Par_AnioMes     		INT(11),		--  Año y Mes Estado Cuenta
    Par_SucursalID  		INT(11),		--  Numero de Sucursal
    Par_FecIniMes   		DATE,			--  Fecha Inicio Mes
    Par_FecFinMes   		DATE,			--  Fecha Fin Mes
	Par_ClienteInstitu		INT(11)			--  Cliente Institucion
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
    DECLARE ClasMovISR      INT(11);
	DECLARE Entero_Uno		INT(11);			-- Entero uno
	DECLARE Var_ProCieGen	VARCHAR(50);		-- Programa CIERREGENERALPRO
	DECLARE Var_ProCieAho	VARCHAR(50);		-- Programa CIERREMESAHORRO

	--  Asignacion de Constantes
	SET Cadena_Vacia		:= '';				--  Cadena Vacia
	SET Fecha_Vacia			:= '1900-01-01';	--  Fecha Vacia
	SET Entero_Cero			:= 0;				--  Entero Cero
	SET Moneda_Cero			:= 0.00;			--  Moneda Cero
	SET Poliza_Cero			:= 0;				--  Poliza Cero

    SET NatCargo        	:= 'C';				--  Naturaleza Movimiento: CARGO
	SET NatAbono			:= 'A';				--  Naturaleza Movimiento: ABONO
    SET ClasMovISR          := 4;               --  Clasificacion de Movimientos ISR
	SET Entero_Uno			:= 1;				-- Entero uno
	SET Var_ProCieGen		:= 'CIERREGENERALPRO';	-- Programa CIERREGENERALPRO
	SET Var_ProCieAho		:= 'CIERREMESAHORRO';	-- Programa CIERREMESAHORRO

	--  Se registra la informacion de la cuenta
	INSERT INTO EDOCTADETACTA
	SELECT  Par_AnioMes, 			Cta.SucursalID,  		Cta.ClienteID,			Cta.CuentaAhoID,	IFNULL(Cta.Etiqueta, 'Sin Etiqueta Definida'),
			Cta.SaldoMesAnterior,  	Cta.CLABE,  		Par_FecIniMes,			Entero_Cero,		'SALDO INICIAL',
			Cta.SaldoMesAnterior,	Moneda_Cero, 		Cta.SaldoMesAnterior,	Entero_Cero,		Poliza_Cero
	FROM  EDOCTARESUMCTA Cta
	WHERE Cta.ClienteID <> Par_ClienteInstitu;

	--  Se registra los movimientos de la cuenta
	INSERT INTO EDOCTADETACTA
	SELECT  Par_AnioMes,
			IF(Mov.ProgramaID IN (Var_ProCieGen, Var_ProCieAho), Entero_Uno, Mov.Sucursal),
			Cta.ClienteID,			Mov.CuentaAhoID,	IFNULL(Cta.Etiqueta, 'Sin Etiqueta Definida'),
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

	-- Actualiza la columna sucursal en caso que algun movimiento contenga Entero Cero a partir del historial de movimientos
	UPDATE EDOCTADETACTA Edo,
			CUENTASAHO Cta
	SET Edo.SucursalID = Cta.SucursalID
	WHERE Cta.CuentaAhoID = Edo.CuentaAhoID
	  AND Edo.SucursalID = Entero_Cero;

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

	DROP TABLE IF EXISTS TMPISRCTA;

END TerminaStore$$
