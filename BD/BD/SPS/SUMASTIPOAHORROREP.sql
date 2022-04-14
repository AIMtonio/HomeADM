-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUMASTIPOAHORROREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUMASTIPOAHORROREP`;
DELIMITER $$

CREATE PROCEDURE `SUMASTIPOAHORROREP`(
	# SP para generar el reporte de Sumas por Tipo de Ahorro
	Par_FechaOperacion	DATE,

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT
)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_FechaSistema		DATE;            -- Fecha del Sistema
DECLARE Var_FechaAnterior   	DATE;            -- Fecha Dia Anterior
DECLARE Var_MontoCapDiaAnt  	DECIMAL(14,2);   -- Monto Captado al Dia Anterior
DECLARE Var_AhorroOrdinario 	DECIMAL(14,2);   -- Monto Ahorro Ordinario
DECLARE Var_AhorroVista     	DECIMAL(14,2);   -- Monto Ahorro Vista

DECLARE Var_MontoPlazo30    	DECIMAL(14,2);   -- Monto Inversion Plazo 30 dias
DECLARE Var_MontoPlazo60    	DECIMAL(14,2);   -- Monto Inversion Plazo 60 dias
DECLARE Var_MontoPlazo90    	DECIMAL(14,2);   -- Monto Inversion Plazo 90 dias
DECLARE Var_MontoPlazo120   	DECIMAL(14,2);   -- Monto Inversion Plazo 120 dias
DECLARE Var_MontoPlazo180   	DECIMAL(14,2);   -- Monto Inversion Plazo 180 dias

DECLARE Var_MontoPlazo360   	DECIMAL(14,2);   -- Monto Inversion Plazo 300 dias
DECLARE Var_TotDepInversion 	DECIMAL(14,2);   -- Total de Depositos de Inversiones
DECLARE Var_PorcentualCapDia  	DECIMAL(10,2);   -- Resultado Porcentual (Captado Dia)
DECLARE Var_AhorroPlazo     	DECIMAL(14,2);   -- Monto Ahorro Ordinario + Monto Ahorro Vista
DECLARE Var_AhorroMenor     	DECIMAL(14,2);	 -- Monto Ahorro Menor

DECLARE Var_IntPlazo30      	DECIMAL(14,2);	  -- Interes Inversion Plazo 30 dias
DECLARE Var_IntPlazo60      	DECIMAL(14,2);    -- Interes Inversion Plazo 60 dias
DECLARE Var_IntPlazo90      	DECIMAL(14,2);    -- Interes Inversion Plazo 90 dias
DECLARE Var_IntPlazo120     	DECIMAL(14,2);    -- Interes Inversion Plazo 120 dias
DECLARE Var_IntPlazo180     	DECIMAL(14,2);    -- Interes Inversion Plazo 180 dias

DECLARE Var_IntPlazo360     	DECIMAL(14,2);    -- Interes Inversion Plazo 360 dias
DECLARE Var_IntInversion    	DECIMAL(14,2);    -- Monto Interes Inversion
DECLARE Var_DiasInversion   	INT(11);          -- Dias Inversion
DECLARE Var_SaldoDisponible     DECIMAL(14,2);    -- Saldo Disponible de las Cuentas
DECLARE Var_FechaInicio 		DATE;             -- Fecha de Inicio

DECLARE Var_IniMesSistema	    DATE;			  -- Fecha Inicial Mes del Sistema
DECLARE Var_FechaHistor         DATE;			  -- Fecha Historica
DECLARE Var_MontoCarteraVen     DECIMAL(14,2);    -- Monto Cartera Credito Vencido
DECLARE Var_MontoCarteraVig     DECIMAL(14,2);    -- Monto Carterta Credito Vigente
DECLARE Var_SaldoMenor    		DECIMAL(14,2);    -- Saldo Disponible de Cuentas de Socios Menores

DECLARE Var_SaldoOrdinario		DECIMAL(14,2);   -- Saldo Disponible de Cuentas de Ahorro Ordinario
DECLARE Var_SaldoVista			DECIMAL(14,2);   -- Saldo Disponible de Cuentas de Ahorro Vista
DECLARE Var_SaldoCapDiaAnt      DECIMAL(18,2);   -- Saldo Captados (Menores, Ordinario, Vista, Ahorro a Plazo)
DECLARE Var_SaldoInversion30 	DECIMAL(14,2);   -- Saldo Inversion Plazo 30 dias
DECLARE Var_SaldoInversion60 	DECIMAL(14,2);   -- Saldo Inversion Plazo 60 dias

DECLARE Var_SaldoInversion90 	DECIMAL(14,2);   -- Saldo Inversion Plazo 90 dias
DECLARE Var_SaldoInversion120   DECIMAL(14,2);   -- Saldo Inversion Plazo 120 dias
DECLARE Var_SaldoInversion180 	DECIMAL(14,2);   -- Saldo Inversion Plazo 180 dias
DECLARE Var_SaldoInversion360	DECIMAL(14,2);   -- Saldo Inversion Plazo 360 dias
DECLARE Var_SaldoInversion      DECIMAL(14,2);   -- Saldo Total de la Inversion

DECLARE Var_SaldoAhorroPlazo    DECIMAL(14,2);   -- Saldo Ahorro Plazo
DECLARE Var_SaldosCredVig       DECIMAL(14,2);   -- Saldo Creditos Vigentes
DECLARE Var_SaldosCredVen       DECIMAL(14,2);   -- Saldo Creditos Vencidos
DECLARE Var_SaldosCreditos      DECIMAL(14,2);   -- Total Saldos Creditos (Vigentes + Vencidos)
DECLARE Var_SaldoIntInversion	DECIMAL(14,2);   -- Saldo Intereses Inversiones

DECLARE Var_MontoPlazo   		DECIMAL(14,2);   -- Monto Inversiones
DECLARE Var_InteresPlazo  		DECIMAL(14,2);   -- Interes Inversiones
DECLARE Var_MontoCtasSinMov  	DECIMAL(14,2);   -- Monto de cuentas sin movimientos
DECLARE Var_SalCtasSinMov  	    DECIMAL(18,2);   -- Saldo de cuentas sin movimientos
DECLARE Var_FechaInicioMes      DATE;	         -- Fecha inicial del mes

DECLARE Var_MontoVistaOrd       DECIMAL(14,2);   -- Monto Ahorro Vista Ordinario
DECLARE Var_MontoInversion      DECIMAL(14,2);   -- Monto Inversiones
DECLARE Var_SaldoVistaOrd       DECIMAL(18,2);   -- Saldo Ahorro Vista Ordinario
DECLARE Var_SaldoInversiones    DECIMAL(14,2);   -- Saldo Inversiones
DECLARE Var_PorcentVistaOrd   	DECIMAL(10,2);   -- Resultado Porcentual Monto Ahorro Vista/Ordinario

DECLARE Var_PorcentInversion    DECIMAL(10,2);   -- Resultado Porcentual Monto Inversiones
DECLARE Var_PorcentSalVistaOrd	DECIMAL(10,2);	 -- Resultado Porcentual Saldo Ahorro Vista/Ordinario
DECLARE	Var_PorcentSaldoInv		DECIMAL(10,2);   -- Resultado Porcentual Saldo Inversiones

-- Declaracion de Constantes
DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Entero_Cero			INT(11);
DECLARE	Decimal_Cero		DECIMAL(14,2);
DECLARE Fecha_Vacia			DATE;
DECLARE Inversion_Vigente   CHAR(1);

DECLARE Inversion_Pagada    CHAR(1);
DECLARE Inversion_Cancelada CHAR(1);
DECLARE MovimientoCargo		CHAR(1);
DECLARE MovimientoAbono		CHAR(1);
DECLARE MenorEdadSI			CHAR(1);

DECLARE AhorroOrdinario		CHAR(1);
DECLARE AhorroVista			CHAR(1);
DECLARE NumDia			    INT(11);
DECLARE MovimientoBloqueo   CHAR(1);
DECLARE Cons_BloqGarLiq		INT(11);

DECLARE CtaActiva           CHAR(1);
DECLARE CtaBloqueada        CHAR(1);
DECLARE CtaCancelada        CHAR(1);
DECLARE FormCtaSinMov		VARCHAR(50);
DECLARE UbicaDetPoliza      CHAR(1);

DECLARE UbicaSalConta       CHAR(1);
DECLARE TipoCalculoFecha    CHAR(1);
DECLARE TipoCalculoPeriodo	CHAR(1);
DECLARE Var_Estatus			CHAR(1);
DECLARE EstatusNoCerrado	CHAR(1);

-- Asignacion de Constantes
SET	Cadena_Vacia		:= '';				-- Cadena Vacia
SET	Entero_Cero			:= 0;				-- Entero Cero
SET	Decimal_Cero		:= 0.0;				-- Decimal Cero
SET Fecha_Vacia			:= '1900-01-01';    -- Fecha Vacia
SET Inversion_Vigente   := 'N';             -- Estatus Inversion: VIGENTE

SET Inversion_Pagada    := 'P';             -- Estatus Inversion: PAGADA
SET Inversion_Cancelada := 'C';             -- Estatus Inversion: CANCELADA
SET MovimientoCargo		:= 'C';				-- Naturaleza Movimiento: Cargo
SET MovimientoAbono		:= 'A';				-- Naturaleza Movimiento: Abono
SET MenorEdadSI         := 'S';             -- Es Menor de Edad: SI

SET AhorroOrdinario		:= 'A';				-- Clasificacion Contable: Ahorro Ordinario
SET AhorroVista			:= 'V';				-- Clasificacion Contable: Depositos a la Vista
SET NumDia              := 1;
SET MovimientoBloqueo   := 'B';             -- Naturaleza Movimiento: Bloqueo
SET Cons_BloqGarLiq		:= 8;	            -- Tipo Bloqueo: Deposito por Garantia Liquida

SET CtaActiva           := 'A';				-- Cuenta Activa
SET CtaBloqueada        := 'B';				-- Cuenta Bloqueada
SET CtaCancelada        := 'C';				-- Cuenta Cancelada
SET FormCtaSinMov		:= '2103%';			-- Formula Cuentas sin Movimientos
SET UbicaDetPoliza  	:= 'A';				-- Ubicacion: DETALLEPOLIZA

SET UbicaSalConta   	:= 'H';				-- Ubicacion: SALDOSCONTABLES
SET TipoCalculoFecha    := 'F';				-- Tipo Calculo: A una Fecha
SET TipoCalculoPeriodo  := 'P';				-- Tipo Calculo: P Periodo
SET EstatusNoCerrado    := 'N';				-- Estatus: No Cerrado

-- Asignacion de variables
SET Var_FechaSistema	:= (SELECT FechaSistema FROM PARAMETROSSIS);
SET Var_IniMesSistema	:= 	DATE(CONCAT(CAST(YEAR(Var_FechaSistema) AS CHAR), "-", CAST(MONTH( Var_FechaSistema) AS CHAR), "-01"));
SET Var_DiasInversion   := (SELECT DiasInversion FROM PARAMETROSSIS);

SET Var_FechaAnterior 	:= (SELECT DATE_ADD(Par_FechaOperacion, INTERVAL -1 DAY));
SET Var_MontoCtasSinMov := Decimal_Cero;
SET Var_SalCtasSinMov   := Decimal_Cero;


	DROP TABLE IF EXISTS TMPSUMASTIPOAHOSALCTA;
	CREATE TABLE TMPSUMASTIPOAHOSALCTA (
		CuentaAhoID 	BIGINT(12),
		TipoCuentaID	INT(11),
		Descripcion		VARCHAR(30),
		SucursalID		INT(11),
		NombreSucurs	VARCHAR(30),
		SaldoIniMes		DECIMAL(18,2),
		SaldoDispon		DECIMAL(18,2),
		SaldoGarLiq		DECIMAL(18,2),
		SaldoTotal		DECIMAL(18,2),
		EsMenor			CHAR(1),
		ClasiConta  	CHAR(1),
		PRIMARY KEY(CuentaAhoID));


	-- ================ Ahorro de Menores del Dia Anterior ===================
	IF (Var_FechaAnterior >= Var_IniMesSistema) THEN
		SELECT SUM(CASE WHEN Mov.NatMovimiento = MovimientoAbono THEN Mov.CantidadMov ELSE Decimal_Cero END) -
				SUM(CASE WHEN Mov.NatMovimiento = MovimientoCargo THEN Mov.CantidadMov ELSE Decimal_Cero END)
				INTO Var_AhorroMenor
				FROM CUENTASAHOMOV Mov
				INNER JOIN CUENTASAHO Cue
					ON Cue.CuentaAhoID = Mov.CuentaAhoID
				INNER JOIN CLIENTES Cli
					ON Cue.ClienteID = Cli.ClienteID
					AND Cli.EsMenorEdad = MenorEdadSI
				WHERE Mov.Fecha = Var_FechaAnterior;

		SET Var_AhorroMenor		:= IFNULL(Var_AhorroMenor, Decimal_Cero);

		ELSE
		SELECT 	SUM(CASE WHEN Mov.NatMovimiento = MovimientoAbono THEN Mov.CantidadMov ELSE Decimal_Cero END) -
				SUM(CASE WHEN Mov.NatMovimiento  = MovimientoCargo THEN Mov.CantidadMov ELSE Decimal_Cero END)
				INTO Var_AhorroMenor
				FROM `HIS-CUENAHOMOV` Mov
				INNER JOIN CUENTASAHO Cue
					ON Cue.CuentaAhoID = Mov.CuentaAhoID
				INNER JOIN CLIENTES Cli
					ON Cue.ClienteID = Cli.ClienteID
					AND Cli.EsMenorEdad = MenorEdadSI
				WHERE Mov.Fecha = Var_FechaAnterior;

		SET Var_AhorroMenor		:= IFNULL(Var_AhorroMenor, Decimal_Cero);

	END IF;

	-- ================ Ahorro Ordinario del Dia Anterior ====================
	IF (Var_FechaAnterior >= Var_IniMesSistema) THEN
		SELECT SUM(CASE WHEN Mov.NatMovimiento  = MovimientoAbono THEN Mov.CantidadMov ELSE Decimal_Cero END) -
				SUM(CASE WHEN Mov.NatMovimiento  = MovimientoCargo THEN Mov.CantidadMov ELSE Decimal_Cero END)
				INTO Var_AhorroOrdinario
				FROM CUENTASAHOMOV Mov
				INNER JOIN CUENTASAHO Cue
					ON Cue.CuentaAhoID = Mov.CuentaAhoID
				INNER JOIN CLIENTES Cli
					ON Cue.ClienteID = Cli.ClienteID
					AND Cli.EsMenorEdad != MenorEdadSI
				INNER JOIN TIPOSCUENTAS Tip
					ON Tip.TipoCuentaID = Cue.TipoCuentaID
					AND Tip.ClasificacionConta = AhorroOrdinario
				WHERE Mov.Fecha = Var_FechaAnterior;

		SET Var_AhorroOrdinario	  := IFNULL(Var_AhorroOrdinario, Decimal_Cero);

	ELSE
		SELECT SUM(CASE WHEN Mov.NatMovimiento =MovimientoAbono THEN Mov.CantidadMov ELSE Decimal_Cero END) -
			  SUM(CASE WHEN Mov.NatMovimiento = MovimientoCargo THEN Mov.CantidadMov ELSE Decimal_Cero END)
				INTO Var_AhorroOrdinario
			FROM `HIS-CUENAHOMOV` Mov
			INNER JOIN CUENTASAHO Cue
				ON Cue.CuentaAhoID = Mov.CuentaAhoID
			INNER JOIN CLIENTES Cli
				ON Cue.ClienteID = Cli.ClienteID
				AND Cli.EsMenorEdad != MenorEdadSI
			INNER JOIN TIPOSCUENTAS Tip
				ON Tip.TipoCuentaID = Cue.TipoCuentaID
				AND Tip.ClasificacionConta = AhorroOrdinario
			WHERE Mov.Fecha = Var_FechaAnterior;

		SET Var_AhorroOrdinario	  := IFNULL(Var_AhorroOrdinario, Decimal_Cero);

	END IF;

	-- ================ Ahorro Vista del Dia Anterior ====================
	IF (Var_FechaAnterior >= Var_IniMesSistema) THEN
		SELECT SUM(CASE WHEN Mov.NatMovimiento = MovimientoAbono THEN Mov.CantidadMov ELSE Decimal_Cero END) -
				SUM(CASE WHEN Mov.NatMovimiento = MovimientoCargo THEN Mov.CantidadMov ELSE Decimal_Cero END)
				INTO Var_AhorroVista
				FROM CUENTASAHOMOV Mov
				INNER JOIN CUENTASAHO Cue
					ON Cue.CuentaAhoID = Mov.CuentaAhoID
				INNER JOIN CLIENTES Cli
					ON Cue.ClienteID = Cli.ClienteID
					AND Cli.EsMenorEdad != MenorEdadSI
				INNER JOIN TIPOSCUENTAS Tip
					ON Tip.TipoCuentaID = Cue.TipoCuentaID
					AND Tip.ClasificacionConta = AhorroVista
				WHERE Mov.Fecha = Var_FechaAnterior;

		SET Var_AhorroVista     := IFNULL(Var_AhorroVista, Decimal_Cero);

	ELSE

		SELECT SUM(CASE WHEN Mov.NatMovimiento = MovimientoAbono THEN Mov.CantidadMov ELSE Decimal_Cero END) -
				SUM(CASE WHEN Mov.NatMovimiento = MovimientoCargo THEN Mov.CantidadMov ELSE Decimal_Cero END)
				INTO Var_AhorroVista
				FROM `HIS-CUENAHOMOV` Mov
				INNER JOIN CUENTASAHO Cue
					ON Cue.CuentaAhoID = Mov.CuentaAhoID
				INNER JOIN CLIENTES Cli
					ON Cue.ClienteID = Cli.ClienteID
					AND Cli.EsMenorEdad != MenorEdadSI
				INNER JOIN TIPOSCUENTAS Tip
					ON Tip.TipoCuentaID = Cue.TipoCuentaID
					AND Tip.ClasificacionConta = AhorroVista
				WHERE Mov.Fecha = Var_FechaAnterior;

		SET Var_AhorroVista     := IFNULL(Var_AhorroVista, Decimal_Cero);

	END IF;

	-- ====================== Deposito de Inversiones ===========================
	DROP TABLE IF EXISTS TMPMINVERSIONES;
	CREATE TEMPORARY TABLE TMPMINVERSIONES(
		InversionID	   	  INT(11),
		MontoInversion	  DECIMAL(14,2),
		Tasa       		  DECIMAL(10,2),
		Plazo 			  INT(12),
		MontoInteres      DECIMAL(14,2));

	INSERT INTO TMPMINVERSIONES(InversionID,MontoInversion,Tasa,Plazo,MontoInteres)
	SELECT InversionID,Monto,Tasa, Plazo, ROUND(((Monto * Tasa * NumDia/Var_DiasInversion)/100),2) AS MontoInteres
			FROM INVERSIONES
			WHERE FechaInicio = Var_FechaAnterior AND Estatus = Inversion_Vigente;

	-- ======================= Inversiones Plazo 30 ===========================
	IF (Var_FechaAnterior >= Var_IniMesSistema) THEN
		SELECT SUM(MontoInversion) AS MontoInversion, SUM(MontoInteres) AS MontoInteres INTO Var_MontoPlazo30, Var_IntPlazo30
			FROM TMPMINVERSIONES
			WHERE Plazo >= 1 AND Plazo <= 30;
	ELSE
		SELECT SUM(Monto) AS MontoPlazo, SUM(InteresGenerado) AS MontoInteres INTO Var_MontoPlazo30, Var_IntPlazo30
			FROM `HISINVERSIONES`
			WHERE FechaInicio = Var_FechaAnterior AND Plazo >= 1 AND Plazo <= 30 AND Estatus = Inversion_Vigente;
	END IF;

	-- ======================= Inversiones Plazo 60 ===========================
	IF (Var_FechaAnterior >= Var_IniMesSistema) THEN
		SELECT SUM(MontoInversion) AS MontoInversion, SUM(MontoInteres) AS MontoInteres INTO Var_MontoPlazo60, Var_IntPlazo60
			FROM TMPMINVERSIONES
			WHERE Plazo > 30 AND Plazo <= 60;
	ELSE
		SELECT SUM(Monto) AS MontoPlazo, SUM(InteresGenerado) AS MontoInteres  INTO Var_MontoPlazo60, Var_IntPlazo60
			FROM `HISINVERSIONES`
			WHERE FechaInicio = Var_FechaAnterior AND Plazo > 30 AND Plazo <= 60 AND Estatus = Inversion_Vigente;
	END IF;

	-- ======================= Inversiones Plazo 90 ===========================
	IF (Var_FechaAnterior >= Var_IniMesSistema) THEN
		SELECT SUM(MontoInversion) AS MontoInversion, SUM(MontoInteres) AS MontoInteres INTO Var_MontoPlazo90, Var_IntPlazo90
			FROM TMPMINVERSIONES
			WHERE Plazo > 60 AND Plazo <= 90;
	ELSE
		SELECT SUM(Monto) AS MontoPlazo, SUM(InteresGenerado) AS MontoInteres  INTO Var_MontoPlazo90, Var_IntPlazo90
			FROM `HISINVERSIONES`
			WHERE FechaInicio = Var_FechaAnterior AND Plazo > 60 AND Plazo <= 90 AND Estatus = Inversion_Vigente;
	END IF;

	-- ======================= Inversiones Plazo 120 ===========================
	IF (Var_FechaAnterior >= Var_IniMesSistema) THEN
		SELECT SUM(MontoInversion) AS MontoInversion, SUM(MontoInteres) AS MontoInteres INTO Var_MontoPlazo120,Var_IntPlazo120
			FROM TMPMINVERSIONES
			WHERE Plazo > 90 AND Plazo <= 120;
	ELSE
		SELECT SUM(Monto) AS MontoPlazo, SUM(InteresGenerado) AS MontoInteres  INTO Var_MontoPlazo120, Var_IntPlazo120
			FROM `HISINVERSIONES`
			WHERE FechaInicio = Var_FechaAnterior AND Plazo > 90 AND Plazo <= 120 AND Estatus = Inversion_Vigente;
	END IF;

	-- ======================= Inversiones Plazo 180 ===========================

	IF (Var_FechaAnterior >= Var_IniMesSistema) THEN
		SELECT SUM(MontoInversion) AS MontoInversion, SUM(MontoInteres) AS MontoInteres INTO Var_MontoPlazo180,Var_IntPlazo180
		FROM TMPMINVERSIONES
		WHERE Plazo > 120 AND Plazo <= 180;
	ELSE
		SELECT SUM(Monto) AS MontoPlazo, SUM(InteresGenerado) AS MontoInteres INTO Var_MontoPlazo180, Var_IntPlazo180
		FROM `HISINVERSIONES`
			WHERE FechaInicio = Var_FechaAnterior AND Plazo > 120 AND Plazo <= 180 AND Estatus = Inversion_Vigente;
	END IF;

-- ======================= Inversiones Plazo 360 ===========================
	IF (Var_FechaAnterior >= Var_IniMesSistema) THEN
		SELECT SUM(MontoInversion) AS MontoInversion, SUM(MontoInteres) AS MontoInteres INTO Var_MontoPlazo360,Var_IntPlazo360
		FROM TMPMINVERSIONES
			WHERE Plazo > 180 AND Plazo <= 400;
	ELSE
		SELECT SUM(Monto) AS MontoPlazo, SUM(InteresGenerado) AS InteresGenerado INTO Var_MontoPlazo360, Var_IntPlazo360
		FROM `HISINVERSIONES`
			WHERE FechaInicio = Var_FechaAnterior AND Plazo > 180 AND Plazo <= 400 AND Estatus = Inversion_Vigente;
	END IF;

	-- ======================= Saldos Captados al Dia Anterior ===========================
	-- ========= Saldo Cuentas de Ahorro =========
	SET Var_FechaInicio 	:= Fecha_Vacia;

	SET Var_FechaInicio	= DATE(CONCAT(CAST(YEAR( Var_FechaAnterior) AS CHAR), "-", CAST(MONTH( Var_FechaAnterior) AS CHAR), "-01"));

	-- Tabla temporal para almacenar saldos bloqueados
	DROP TABLE IF EXISTS TMPSALDOSBLOQUEO;
	CREATE TEMPORARY TABLE TMPSALDOSBLOQUEO (
		Cuenta 		BIGINT,
		Saldo		DECIMAL(18,2),
		PRIMARY KEY(Cuenta));

    INSERT INTO TMPSALDOSBLOQUEO()
	SELECT Blo.CuentaAhoID, SUM(CASE WHEN NatMovimiento = MovimientoBloqueo THEN  MontoBloq ELSE MontoBloq *-1 END) AS Saldo
		FROM BLOQUEOS Blo
		WHERE DATE(FechaMov) <= Var_FechaAnterior
			AND TiposBloqID = Cons_BloqGarLiq
			GROUP BY CuentaAhoID;

    -- Tabla temporal para almacenar los saldos de movimientos
    DROP TABLE IF EXISTS TMPSALDOSMOVIMIENTOS;
	CREATE TEMPORARY TABLE TMPSALDOSMOVIMIENTOS (
		Cuenta 			BIGINT,
		SaldoMov		DECIMAL(18,2),
		PRIMARY KEY(Cuenta));

	-- Tabla temporal para almacenar los saldos de movimientos Actuales
	DROP TABLE IF EXISTS TMPSALDOSMOVIMIENTOSACT;
	CREATE TEMPORARY TABLE TMPSALDOSMOVIMIENTOSACT (
		Cuenta 			BIGINT,
		SaldoMov		DECIMAL(18,2),
		PRIMARY KEY(Cuenta));

    IF(Var_FechaAnterior < Var_IniMesSistema) THEN
		SELECT MAX(Fecha) INTO Var_FechaHistor
			FROM `HIS-CUENTASAHO`
				WHERE Fecha < Var_IniMesSistema
				 AND MONTH(Fecha) = MONTH(Var_FechaAnterior);
	END IF;

	SET Var_FechaHistor	:= IFNULL(Var_FechaHistor, Fecha_Vacia);

    IF(Var_FechaAnterior < Var_IniMesSistema) THEN
		INSERT INTO TMPSALDOSMOVIMIENTOS
			SELECT Mov.CuentaAhoID, SUM(CASE Mov.NatMovimiento WHEN MovimientoCargo THEN Mov.CantidadMov * -1 ELSE Mov.CantidadMov END)
				FROM `HIS-CUENAHOMOV` Mov
					WHERE Mov.Fecha >= Var_FechaInicio
					  AND Mov.Fecha <= Var_FechaAnterior
					  GROUP BY Mov.CuentaAhoID;

		INSERT INTO TMPSALDOSMOVIMIENTOSACT
			SELECT Mov.CuentaAhoID, SUM(CASE Mov.NatMovimiento WHEN MovimientoCargo THEN Mov.CantidadMov * -1 ELSE Mov.CantidadMov END)
				FROM CUENTASAHOMOV Mov
				WHERE Mov.Fecha <= Var_FechaAnterior
					GROUP BY Mov.CuentaAhoID;
	ELSE
		INSERT INTO TMPSALDOSMOVIMIENTOS
			SELECT Mov.CuentaAhoID, SUM(CASE Mov.NatMovimiento WHEN MovimientoCargo THEN Mov.CantidadMov * -1 else Mov.CantidadMov END)
				FROM CUENTASAHOMOV Mov
				WHERE Mov.Fecha >= Var_FechaInicio
				  AND Mov.Fecha <= Var_FechaAnterior
				GROUP BY Mov.CuentaAhoID;
	END IF;


	-- Tabla temporal para almacenar los saldos de las cuentas
	IF(Var_FechaAnterior < Var_IniMesSistema) THEN
			INSERT INTO TMPSUMASTIPOAHOSALCTA()
			SELECT  Cue.CuentaAhoID, Cue.TipoCuentaID AS NumTipoCue, NULL AS NombreTipCue, Cue.SucursalID, NULL AS NombreSuc,
					Cue.SaldoIniMes, 	Cue.SaldoIniMes AS SaldoDispon, Decimal_Cero as SaldoGarLiq, Decimal_Cero AS SaldoTotal,
					Cli.EsMenorEdad,Tip.ClasificacionConta
				FROM `HIS-CUENTASAHO` Cue
				INNER JOIN CUENTASAHO Act
					ON Cue.CuentaAhoID = Act.CuentaAhoID
				INNER JOIN CLIENTES Cli
					ON Cue.ClienteID = Cli.ClienteID
				INNER JOIN TIPOSCUENTAS Tip
					ON Tip.TipoCuentaID = Cue.TipoCuentaID
				WHERE Cue.Fecha = Var_FechaHistor
					AND (Cue.Estatus IN (CtaActiva, CtaBloqueada)
					OR (Cue.Estatus = CtaCancelada AND Act.FechaCan  >= Var_FechaInicio))
					AND Cue.TipoCuentaID <> 1;
		ELSE
			INSERT INTO TMPSUMASTIPOAHOSALCTA()
			SELECT  Cue.CuentaAhoID, Cue.TipoCuentaID AS NumTipoCue, NULL AS NombreTipCue, Cue.SucursalID, NULL AS NombreSuc,
					Cue.SaldoIniMes, Cue.SaldoIniMes AS SaldoDispon, Decimal_Cero AS SaldoGarLiq, Decimal_Cero AS SaldoTotal,
					 Cli.EsMenorEdad,Tip.ClasificacionConta
				FROM CUENTASAHO Cue
				INNER JOIN CLIENTES Cli
					ON Cue.ClienteID = Cli.ClienteID
				INNER JOIN TIPOSCUENTAS Tip
					ON Tip.TipoCuentaID = Cue.TipoCuentaID
				WHERE (Cue.Estatus IN (CtaActiva, CtaBloqueada)
					OR (Cue.Estatus = CtaCancelada AND Cue.FechaCan  >= Var_FechaInicio))
					AND Cue.TipoCuentaID <> 1;
	END IF;

	UPDATE TMPSUMASTIPOAHOSALCTA Cue
		INNER JOIN SUCURSALES Suc ON Suc.SucursalID = Cue.SucursalID
	SET Cue.NombreSucurs = Suc.NombreSucurs;

    UPDATE TMPSUMASTIPOAHOSALCTA Cue
		INNER JOIN TIPOSCUENTAS Tip ON Tip.TipoCuentaID = Cue.TipoCuentaID
	SET Cue.Descripcion = Tip.Descripcion;

    UPDATE TMPSUMASTIPOAHOSALCTA Cue
		INNER JOIN TMPSALDOSBLOQUEO Tmp ON Cue.CuentaAhoID = Tmp.Cuenta
	SET Cue.SaldoGarLiq = Tmp.Saldo,
		Cue.SaldoDispon = Cue.SaldoDispon - Tmp.Saldo;

    UPDATE TMPSUMASTIPOAHOSALCTA Cue
		INNER JOIN TMPSALDOSMOVIMIENTOS Tmp ON Cue.CuentaAhoID = Tmp.Cuenta
	SET Cue.SaldoDispon = Cue.SaldoDispon + Tmp.SaldoMov;

    UPDATE TMPSUMASTIPOAHOSALCTA Cue
		INNER JOIN TMPSALDOSMOVIMIENTOSACT Tmp ON Cue.CuentaAhoID = Tmp.Cuenta
	SET Cue.SaldoDispon = Cue.SaldoDispon + Tmp.SaldoMov;

    UPDATE TMPSUMASTIPOAHOSALCTA
	SET SaldoTotal = SaldoDispon + SaldoGarLiq;

	SELECT SUM(SaldoTotal) INTO Var_SaldoMenor
	FROM TMPSUMASTIPOAHOSALCTA
		WHERE EsMenor = MenorEdadSI;

	SET Var_SaldoMenor	:= IFNULL(Var_SaldoMenor, Decimal_Cero);


	SELECT SUM(SaldoTotal)  INTO Var_SaldoOrdinario
	FROM TMPSUMASTIPOAHOSALCTA
		WHERE EsMenor != MenorEdadSI
			AND ClasiConta = AhorroOrdinario;

	SET Var_SaldoOrdinario	:= IFNULL(Var_SaldoOrdinario, Decimal_Cero);


	SELECT SUM(SaldoTotal)  INTO Var_SaldoVista
	FROM TMPSUMASTIPOAHOSALCTA
		WHERE EsMenor != MenorEdadSI
			AND ClasiConta = AhorroVista;

	SET Var_SaldoVista	:= IFNULL(Var_SaldoVista, Decimal_Cero);

	-- ========= Saldo Inversiones Plazo 30 al Dia Anterior ==========
	DROP TABLE IF EXISTS TMPSALDOINVERSION;
	CREATE TEMPORARY TABLE TMPSALDOINVERSION(
		Plazo			  INT(12),
		SaldoInversion    DECIMAL(14,2));

	INSERT INTO TMPSALDOINVERSION()
	SELECT Plazo,Monto AS SaldoInversion
		FROM INVERSIONES
		WHERE FechaInicio <= Var_FechaAnterior
		  AND (Estatus = Inversion_Vigente
		   OR (Estatus = Inversion_Pagada
			AND FechaVencimiento != Fecha_Vacia
			AND FechaVencimiento > Var_FechaAnterior)
		   OR ( Estatus = Inversion_Cancelada
			AND FechaVenAnt != Var_FechaAnterior
			AND FechaVenAnt > Var_FechaAnterior));

	SELECT SUM(SaldoInversion) INTO Var_SaldoInversion30
		FROM TMPSALDOINVERSION
			WHERE Plazo <= 30;

	SELECT SUM(SaldoInversion) INTO Var_SaldoInversion60
		FROM TMPSALDOINVERSION
			WHERE Plazo > 30 AND Plazo <= 60;

	SELECT SUM(SaldoInversion) INTO Var_SaldoInversion90
		FROM TMPSALDOINVERSION
			WHERE Plazo > 60 AND Plazo <= 90;

	SELECT SUM(SaldoInversion) INTO Var_SaldoInversion120
		FROM TMPSALDOINVERSION
			WHERE Plazo > 90 AND Plazo <= 120;

	SELECT SUM(SaldoInversion) INTO Var_SaldoInversion180
		FROM TMPSALDOINVERSION
			WHERE Plazo > 120 AND Plazo <= 180;

	SELECT SUM(SaldoInversion) INTO Var_SaldoInversion360
		FROM TMPSALDOINVERSION
			WHERE Plazo > 180 AND Plazo <= 400;

	IF (Var_FechaAnterior >= Var_IniMesSistema) THEN
		SELECT SUM(SaldoProvision) AS SaldoInteres INTO Var_SaldoIntInversion
			FROM INVERSIONES
			WHERE ((Estatus = Inversion_Vigente))
				AND (Plazo >= 1 AND Plazo <= 400)
				AND FechaInicio = Var_FechaAnterior;

	ELSE
		SELECT SUM(SaldoProvision) AS SaldoInteres INTO Var_SaldoIntInversion
			FROM HISINVERSIONES
			WHERE ((Estatus = Inversion_Vigente))
				AND (Plazo >= 1 AND Plazo <= 400)
				AND FechaCorte = Var_FechaAnterior;
	END IF;

	SET	Var_SaldoInversion30	:= IFNULL(Var_SaldoInversion30,Decimal_Cero);
	SET	Var_SaldoInversion60	:= IFNULL(Var_SaldoInversion60,Decimal_Cero);
	SET	Var_SaldoInversion90	:= IFNULL(Var_SaldoInversion90,Decimal_Cero);
	SET	Var_SaldoInversion120	:= IFNULL(Var_SaldoInversion120,Decimal_Cero);
	SET	Var_SaldoInversion180	:= IFNULL(Var_SaldoInversion180,Decimal_Cero);
	SET	Var_SaldoInversion360	:= IFNULL(Var_SaldoInversion360,Decimal_Cero);
	SET Var_SaldoIntInversion   := IFNULL(Var_SaldoIntInversion,Decimal_Cero);

	SET Var_FechaInicioMes   := DATE(CONCAT(CAST(YEAR(Var_FechaAnterior) AS CHAR), "-", CAST(MONTH(Var_FechaAnterior) AS CHAR), "-01"));

	-- Se obtiene el estatus del periodo contable
	SELECT Estatus INTO Var_Estatus FROM  PERIODOCONTABLE
	WHERE Inicio <= Var_FechaInicioMes AND Fin >=Var_FechaAnterior;

	SET Var_Estatus	   := IFNULL(Var_Estatus, Cadena_Vacia);
    -- Se valida el estatus del periodo contable
	IF(Var_Estatus = EstatusNoCerrado) THEN
		IF (Var_FechaAnterior >= Var_IniMesSistema) THEN
			CALL EVALFORMULAREGPRO(Var_SalCtasSinMov,FormCtaSinMov,UbicaDetPoliza,TipoCalculoFecha,Var_FechaAnterior);

		ELSE
			CALL EVALFORMULAREGPRO(Var_SalCtasSinMov,FormCtaSinMov,UbicaDetPoliza,TipoCalculoFecha,Var_FechaAnterior);

		END IF;

	ELSE
		CALL EVALFORMULAREGPRO(Var_SalCtasSinMov,FormCtaSinMov,UbicaSalConta,TipoCalculoFecha,Var_FechaAnterior);
	END IF;

	SET Var_SalCtasSinMov :=IFNULL(Var_SalCtasSinMov,Decimal_Cero);


	SET	Var_MontoPlazo30	:= IFNULL(Var_MontoPlazo30,Decimal_Cero);
	SET	Var_IntPlazo30		:= IFNULL(Var_IntPlazo30,Decimal_Cero);

	SET	Var_MontoPlazo60	:= IFNULL(Var_MontoPlazo60,Decimal_Cero);
	SET	Var_IntPlazo60		:= IFNULL(Var_IntPlazo60,Decimal_Cero);

	SET	Var_MontoPlazo90	:= IFNULL(Var_MontoPlazo90,Decimal_Cero);
	SET	Var_IntPlazo90		:= IFNULL(Var_IntPlazo90,Decimal_Cero);

	SET	Var_MontoPlazo120	:= IFNULL(Var_MontoPlazo120,Decimal_Cero);
	SET	Var_IntPlazo120		:= IFNULL(Var_IntPlazo120,Decimal_Cero);

	SET	Var_MontoPlazo180	:= IFNULL(Var_MontoPlazo180,Decimal_Cero);
	SET	Var_IntPlazo180		:= IFNULL(Var_IntPlazo180,Decimal_Cero);

	SET	Var_MontoPlazo360	:= IFNULL(Var_MontoPlazo360,Decimal_Cero);
	SET	Var_IntPlazo360		:= IFNULL(Var_IntPlazo360,Decimal_Cero);


	SET Var_MontoPlazo          := Var_MontoPlazo30 + Var_MontoPlazo60 + Var_MontoPlazo90 + Var_MontoPlazo120 +
									Var_MontoPlazo180 + Var_MontoPlazo360;

	SET Var_InteresPlazo        := Var_IntPlazo30 + Var_IntPlazo60 + Var_IntPlazo90 + Var_IntPlazo120 +
									Var_IntPlazo180 + Var_IntPlazo360;

	SET Var_TotDepInversion   	:= Var_MontoPlazo + Var_InteresPlazo;
	SET	Var_TotDepInversion	  	:= IFNULL(Var_TotDepInversion,Decimal_Cero);

	SET Var_AhorroPlazo			:= Var_TotDepInversion;
	SET	Var_AhorroPlazo			:= IFNULL(Var_AhorroPlazo,Decimal_Cero);

	SET Var_MontoCapDiaAnt    	:= Var_AhorroPlazo + Var_AhorroOrdinario + Var_AhorroVista + Var_AhorroMenor;
	SET	Var_MontoCapDiaAnt	  	:= IFNULL(Var_MontoCapDiaAnt,Decimal_Cero);

	SET Var_MontoVistaOrd       := Var_AhorroOrdinario + Var_AhorroVista;
	SET Var_MontoVistaOrd       := IFNULL(Var_MontoVistaOrd,Decimal_Cero);

	SET Var_PorcentVistaOrd  	:= (CASE WHEN Var_MontoCapDiaAnt = Decimal_Cero THEN Decimal_Cero ELSE (Var_MontoVistaOrd / Var_MontoCapDiaAnt) END) * 100;
	SET	Var_PorcentVistaOrd		:= IFNULL(Var_PorcentVistaOrd,Decimal_Cero);

	SET Var_MontoInversion      := Var_AhorroPlazo;
	SET Var_MontoInversion      := IFNULL(Var_MontoInversion,Decimal_Cero);

	SET Var_PorcentInversion    := (CASE WHEN Var_MontoCapDiaAnt = Decimal_Cero THEN Decimal_Cero ELSE (Var_MontoInversion / Var_MontoCapDiaAnt) END) * 100;
	SET Var_PorcentInversion    := IFNULL(Var_PorcentInversion,Decimal_Cero);


	SET Var_SaldoInversion   	:= Var_SaldoInversion30 + Var_SaldoInversion60 + Var_SaldoInversion90 +
										Var_SaldoInversion120 + Var_SaldoInversion180 + Var_SaldoInversion360 +
									Var_SaldoIntInversion;
	SET Var_SaldoInversion	 	:= IFNULL(Var_SaldoInversion, Decimal_Cero);

	SET Var_SaldoAhorroPlazo	:= Var_SaldoInversion;
	SET	Var_SaldoAhorroPlazo	:= IFNULL(Var_SaldoAhorroPlazo,Decimal_Cero);

	SET Var_SaldoCapDiaAnt     	:= Var_SaldoAhorroPlazo + Var_SaldoMenor + Var_SaldoOrdinario + Var_SaldoVista + Var_SalCtasSinMov;
	SET Var_SaldoCapDiaAnt	 	:= IFNULL(Var_SaldoCapDiaAnt, Decimal_Cero);

	SET Var_SaldoVistaOrd       := Var_SaldoOrdinario + Var_SaldoVista + Var_SalCtasSinMov;
	SET Var_SaldoVistaOrd       := IFNULL(Var_SaldoVistaOrd,Decimal_Cero);

	SET Var_PorcentSalVistaOrd  := (CASE WHEN Var_SaldoCapDiaAnt = Decimal_Cero THEN Decimal_Cero ELSE (Var_SaldoVistaOrd / Var_SaldoCapDiaAnt) END) * 100;
	SET Var_PorcentSalVistaOrd  := IFNULL(Var_PorcentSalVistaOrd,Decimal_Cero);

	SET Var_SaldoInversiones   := Var_SaldoAhorroPlazo;
	SET Var_SaldoInversiones   := IFNULL(Var_SaldoInversiones,Decimal_Cero);

	SET Var_PorcentSaldoInv    := (CASE WHEN Var_SaldoCapDiaAnt = Decimal_Cero THEN Decimal_Cero ELSE (Var_SaldoInversiones / Var_SaldoCapDiaAnt) END) * 100;
	SET Var_PorcentSaldoInv    := IFNULL(Var_PorcentSaldoInv,Decimal_Cero);


  SELECT  	FORMAT(Var_MontoCapDiaAnt,2) AS Var_MontoCapDiaAnt, 	Var_MontoCapDiaAnt AS Var_MontoCapDiaAntExc,
			FORMAT(Var_AhorroMenor,2) AS Var_AhorroMenor, 			Var_AhorroMenor AS Var_AhorroMenorExc,
			FORMAT(Var_AhorroOrdinario,2) AS Var_AhorroOrdinario, 	Var_AhorroOrdinario AS Var_AhorroOrdinarioExc,
			FORMAT(Var_AhorroVista,2) AS Var_AhorroVista, 			Var_AhorroVista AS Var_AhorroVistaExc,
            Var_AhorroPlazo,			Var_MontoPlazo30,			Var_MontoPlazo60,	    Var_MontoPlazo90,
            Var_MontoPlazo120, 			Var_MontoPlazo180,			Var_MontoPlazo360,   	Var_InteresPlazo,
            Var_SaldoCapDiaAnt,			Var_SaldoAhorroPlazo,		Var_SaldoMenor,			Var_SaldoOrdinario,
            Var_SaldoVista,		    	Var_SaldoInversion30,		Var_SaldoInversion60,	Var_SaldoInversion90,
            Var_SaldoInversion120,  	Var_SaldoInversion180,		Var_SaldoInversion360,	Var_SaldoInversion,
            Var_SaldoIntInversion,		Var_MontoCtasSinMov,        Var_SalCtasSinMov, 		Var_MontoVistaOrd,
            Var_MontoInversion,      	Var_SaldoVistaOrd,       	Var_SaldoInversiones,   Var_PorcentVistaOrd,
            Var_PorcentInversion,       Var_PorcentSalVistaOrd,		Var_PorcentSaldoInv, 0 AS ClienteID,
            0 as Var_MontoCaptado,0 as Var_AhoOrdinarioSocio, 0 as Var_AhoVistaSocio ,0 as SaldoOrdinario, 0 as SaldoVista;


	DROP TABLE IF EXISTS  TMPSALDOSBLOQUEO;
	DROP TABLE IF EXISTS TMPSALDOSMOVIMIENTOS;
	DROP TABLE IF EXISTS TMPSALDOSMOVIMIENTOSACT;
	DROP TABLE IF EXISTS TMPSALDOINVERSION;
	DROP TABLE IF EXISTS TMPMINVERSIONES;
	DROP TABLE IF EXISTS TMPSUMASTIPOAHOSALCTA;

END TerminaStore$$