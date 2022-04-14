-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PASIVOCORTOPLAZOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `PASIVOCORTOPLAZOREP`;
DELIMITER $$

CREATE PROCEDURE `PASIVOCORTOPLAZOREP`(
	-- SP para generar el reporte de Pasivo a Corto Plazo
	Par_FechaOperacion	DATE,         -- Fecha para generar el Reporte

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
DECLARE Var_PorcPasivCtoPlazo	DECIMAL(10,2);	 -- Porcentaje Parametrizado Pasivo Corto Plazo
DECLARE Var_AhorroOrdinario 	DECIMAL(14,2);   -- Monto Ahorro Ordinario
DECLARE Var_AhorroVista     	DECIMAL(14,2);   -- Monto Ahorro Vista

DECLARE Var_MontoPlazo30    	DECIMAL(14,2);   -- Monto Inversion Plazo 30 dias
DECLARE Var_MontoCaptado		DECIMAL(14,2);   -- Monto Captado del Dia Anterior
DECLARE Var_PorcentualPasivo   	DECIMAL(10,2);   -- Resultado Porcentual Pasivo Corto Plazo
DECLARE Var_DifLimitePasivo    	DECIMAL(10,2);   -- Diferencia entre el Parametro (Pasivo Corto Plazo) y el Resultado Porcentual (Pasivo Corto Plazo)
DECLARE Var_DiasInversion   	INT(11);		 -- Dias Inversion

DECLARE Var_IntPlazo30      	DECIMAL(14,2);   -- Monto Interes Inversion Plazo 30 dias
DECLARE Var_MontoPlazo    		DECIMAL(14,2);   -- Monto Inversion Plazo mayores a 30 dias
DECLARE Var_IntPlazo      		DECIMAL(14,2);   -- Monto Interes Inversion Plazo mayores a 30 dias
DECLARE Var_AhorroMenor         DECIMAL(14,2);   -- Monto Ahorro Menor
DECLARE Var_MontoInversion 		DECIMAL(14,2);   -- Monto Inversion

DECLARE Var_IntInversion		DECIMAL(14,2);   -- Monto Interes Inversion
DECLARE Var_TotDepInversion     DECIMAL(14,2);   -- Total de Depositos de Inversiones
DECLARE Var_IniMesSistema	    DATE;			 -- Fecha Inicial Mes del Sistema
DECLARE Var_SaldoInversion30    DECIMAL(14,2);   -- Saldo Inversiones plazo 30 dias
DECLARE Var_SaldoInversion      DECIMAL(14,2);   -- Saldo Inversiones plazo mayor a 30 dias

DECLARE Var_FechaInicio 		DATE;             -- Fecha de Inicio
DECLARE Var_FechaHistor         DATE;			  -- Fecha Historica
DECLARE Var_SaldoMenor    		DECIMAL(14,2);    -- Saldo Disponible de Cuentas de Socios Menores
DECLARE Var_SaldoOrdinario		DECIMAL(14,2);    -- Saldo Disponible de Cuentas de Ahorro Ordinario
DECLARE Var_SaldoVista			DECIMAL(14,2);    -- Saldo Disponible de Cuentas de Ahorro Vista

DECLARE Var_SaldoCaptado        DECIMAL(14,2);    -- Saldo Total Captado
DECLARE Var_PorcentualSaldo	 	DECIMAL(10,2);    -- Resultado Porcentual Saldos Pasivo Corto Plazo
DECLARE Var_DifLimiteSaldo		DECIMAL(10,2);    -- Diferencia entre el Parametro (Pasivo Corto Plazo) y el Resultado Porcentual (Saldos Pasivo Corto Plazo)
DECLARE Var_SalCtasSinMov  	    DECIMAL(18,2);    -- Saldo de cuentas sin movimientos
DECLARE Var_SaldoIntInversion	DECIMAL(14,2);    -- Saldo Intereses Inversiones

DECLARE Var_FechaInicioMes      DATE;	          -- Fecha inicial del mes
DECLARE Var_Estatus				CHAR(1);		  -- Estatus del Periodo Contable
DECLARE Var_FechaCieInv		DATE;
DECLARE Cliente_Inst		INT;

-- Declaracion de Constantes
DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Entero_Cero			INT(11);
DECLARE	Decimal_Cero		DECIMAL(14,2);
DECLARE Fecha_Vacia			DATE;
DECLARE ParamPasCtoPzo		INT(11);

DECLARE Estatus_Vigente     CHAR(1);
DECLARE MovimientoCargo		CHAR(1);
DECLARE MovimientoAbono		CHAR(1);
DECLARE AhorroOrdinario		CHAR(1);
DECLARE AhorroVista			CHAR(1);

DECLARE NumDia			    INT(11);
DECLARE Inversion_Vigente   CHAR(1);
DECLARE Inversion_Pagada    CHAR(1);
DECLARE Inversion_Cancelada CHAR(1);
DECLARE MenorEdadSI			CHAR(1);

DECLARE MovimientoBloqueo   CHAR(1);
DECLARE Cons_BloqGarLiq		INT(11);
DECLARE CtaActiva           CHAR(1);
DECLARE CtaBloqueada        CHAR(1);
DECLARE CtaCancelada        CHAR(1);

DECLARE EstatusNoCerrado	CHAR(1);
DECLARE FormCtaSinMov		VARCHAR(50);
DECLARE UbicaDetPoliza      CHAR(1);
DECLARE UbicaSalConta       CHAR(1);
DECLARE TipoCalculoFecha    CHAR(1);
DECLARE NumeroDias_mes			INT(11);
DECLARE Var_FechFinMasDias			DATE;				-- Fecha fin mas dias

-- Asignacion de Constantes
SET	Cadena_Vacia		:= '';				-- Cadena Vacia
SET	Entero_Cero			:= 0;				-- Entero Cero
SET	Decimal_Cero		:= 0.0;				-- Decimal Cero
SET Fecha_Vacia			:= '1900-01-01';    -- Fecha Vacia
SET ParamPasCtoPzo   	:= 9;               -- CatParamRiesgosID: Parametro Pasivo a Corto Plazo

SET Estatus_Vigente     := 'N';             -- Estatus Inversion: Vigente
SET MovimientoCargo		:= 'C';				-- Naturaleza Movimiento: Cargo
SET MovimientoAbono		:= 'A';				-- Naturaleza Movimiento: Abono
SET AhorroOrdinario		:= 'A';				-- Clasificacion Contable: Ahorro(Ordinario)
SET AhorroVista			:= 'V';				-- Clasificacion Contable: Depositos a la Vista

SET NumDia              := 1;
SET Inversion_Vigente   := 'N';             -- Estatus Inversion: VIGENTE
SET Inversion_Pagada    := 'P';             -- Estatus Inversion: PAGADA
SET Inversion_Cancelada := 'C';             -- Estatus Inversion: CANCELADA
SET MenorEdadSI         := 'S';             -- Es Menor de Edad: SI

SET MovimientoBloqueo   := 'B';             -- Naturaleza Movimiento: Bloqueo
SET Cons_BloqGarLiq		:= 8;	            -- Tipo Bloqueo: Deposito por Garantia Liquida
SET CtaActiva           := 'A';				-- Cuenta Activa
SET CtaBloqueada        := 'B';				-- Cuenta Bloqueada
SET CtaCancelada        := 'C';				-- Cuenta Cancelada

SET EstatusNoCerrado    := 'N';				-- Estatus: No Cerrado
SET FormCtaSinMov		:= '2103%';			-- Formula Cuentas sin Movimientos
SET UbicaDetPoliza  	:= 'A';				-- Ubicacion: DETALLEPOLIZA
SET UbicaSalConta   	:= 'H';				-- Ubicacion: SALDOSCONTABLES
SET TipoCalculoFecha    := 'F';				-- Tipo Calculo: A una Fecha
SET Cliente_Inst		:= (SELECT ClienteInstitucion FROM PARAMETROSSIS);


-- Asignacion de Variables
SET Var_DiasInversion   	:= (SELECT DiasInversion FROM PARAMETROSSIS);
SET Var_FechaSistema		:= (SELECT FechaSistema FROM PARAMETROSSIS);
SET Var_IniMesSistema		:= 	DATE(CONCAT(CAST(YEAR(Var_FechaSistema) AS CHAR), "-", CAST(MONTH( Var_FechaSistema) AS CHAR), "-01"));
SET Var_PorcPasivCtoPlazo   := (SELECT Porcentaje FROM PARAMUACIRIESGOS WHERE CatParamRiesgosID = ParamPasCtoPzo);
SET Var_FechaAnterior 		:= (SELECT DATE_ADD(Par_FechaOperacion, INTERVAL -1 DAY));
SET Var_PorcPasivCtoPlazo   := IFNULL(Var_PorcPasivCtoPlazo,Decimal_Cero);
SET Var_SalCtasSinMov   	:= Decimal_Cero;

	SET NumeroDias_mes		:= 30;					-- numero de dias del mes

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

	SET Var_AhorroMenor	:= IFNULL(Var_AhorroMenor, Decimal_Cero);

	ELSE
	SELECT SUM(CASE WHEN Mov.NatMovimiento = MovimientoAbono THEN Mov.CantidadMov ELSE Decimal_Cero END) -
			SUM(CASE WHEN Mov.NatMovimiento = MovimientoCargo THEN Mov.CantidadMov ELSE Decimal_Cero END)
			INTO Var_AhorroMenor
			FROM `HIS-CUENAHOMOV` Mov
			INNER JOIN CUENTASAHO Cue
				ON Cue.CuentaAhoID = Mov.CuentaAhoID
			INNER JOIN CLIENTES Cli
				ON Cue.ClienteID = Cli.ClienteID
				AND Cli.EsMenorEdad = MenorEdadSI
			WHERE Mov.Fecha = Var_FechaAnterior;

	SET Var_AhorroMenor	:= IFNULL(Var_AhorroMenor, Decimal_Cero);

END IF;

-- ================ Ahorro Ordinario del Dia Anterior ====================
IF (Var_FechaAnterior >= Var_IniMesSistema) THEN
		SELECT SUM(CASE WHEN Mov.NatMovimiento = MovimientoAbono THEN Mov.CantidadMov ELSE Decimal_Cero END) -
				SUM(CASE WHEN Mov.NatMovimiento = MovimientoCargo THEN Mov.CantidadMov ELSE Decimal_Cero END)
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

		SET Var_AhorroOrdinario	 := IFNULL(Var_AhorroOrdinario, Decimal_Cero);

	ELSE
	SELECT SUM(CASE WHEN Mov.NatMovimiento = MovimientoAbono THEN Mov.CantidadMov ELSE Decimal_Cero END) -
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

	SET Var_AhorroOrdinario	 := IFNULL(Var_AhorroOrdinario, Decimal_Cero);

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

	SET Var_AhorroVista  := IFNULL(Var_AhorroVista, Decimal_Cero);

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

	SET Var_AhorroVista   := IFNULL(Var_AhorroVista, Decimal_Cero);

END IF;

-- ================== Deposito de Inversiones Plazo 30 Dias ===========================
	DROP TABLE IF EXISTS TMPMINVERSIONES;
	CREATE TEMPORARY TABLE TMPMINVERSIONES(
		InversionID	   	  INT(11),
		MontoInversion	  DECIMAL(14,2),
		Tasa       		  DECIMAL(10,2),
		Plazo 			  INT(12),
		MontoInteres      DECIMAL(14,2));

	INSERT INTO TMPMINVERSIONES(InversionID, MontoInversion,Tasa,Plazo,MontoInteres)
	SELECT InversionID, Monto, Tasa, Plazo, ROUND(((Monto * Tasa * NumDia/Var_DiasInversion)/100),2) AS MontoInteres
		FROM INVERSIONES
		WHERE FechaInicio = Var_FechaAnterior AND Estatus = Inversion_Vigente;

	IF (Var_FechaAnterior >= Var_IniMesSistema) THEN
		SELECT SUM(MontoInversion) AS MontoInversion, SUM(MontoInteres) AS MontoInteres INTO Var_MontoPlazo30, Var_IntPlazo30
			FROM TMPMINVERSIONES
			WHERE Plazo >= 1  AND Plazo <= 30;
	ELSE
		SELECT SUM(Monto) AS MontoPlazo, SUM(InteresGenerado) AS MontoInteres INTO Var_MontoPlazo30, Var_IntPlazo30
			FROM `HISINVERSIONES`
			WHERE FechaInicio = Var_FechaAnterior AND Plazo >= 1 AND Plazo <= 30 AND Estatus = Inversion_Vigente;
	END IF;

    IF (Var_FechaAnterior >= Var_IniMesSistema) THEN
		SELECT SUM(MontoInversion) AS MontoInversion, SUM(MontoInteres) AS MontoInteres INTO Var_MontoPlazo, Var_IntPlazo
			FROM TMPMINVERSIONES
			WHERE Plazo > 30  AND Plazo <= 400;
	ELSE
		SELECT SUM(Monto) AS MontoPlazo, SUM(InteresGenerado) AS MontoInteres INTO Var_MontoPlazo, Var_IntPlazo
			FROM `HISINVERSIONES`
			WHERE FechaInicio = Var_FechaAnterior AND Plazo > 30 AND Plazo <= 400 AND Estatus = Inversion_Vigente;
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
			GROUP BY Blo.CuentaAhoID;

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

	TRUNCATE TABLE TMPSALDOSCUENTASCAP;
	IF(Var_FechaAnterior < Var_IniMesSistema) THEN
			INSERT INTO TMPSALDOSCUENTASCAP()
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
			INSERT INTO TMPSALDOSCUENTASCAP()
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

	UPDATE TMPSALDOSCUENTASCAP Cue
		INNER JOIN SUCURSALES Suc ON Suc.SucursalID = Cue.SucursalID
	SET Cue.NombreSucurs = Suc.NombreSucurs;

    UPDATE TMPSALDOSCUENTASCAP Cue
		INNER JOIN TIPOSCUENTAS Tip ON Tip.TipoCuentaID = Cue.TipoCuentaID
	SET Cue.Descripcion = Tip.Descripcion;

    UPDATE TMPSALDOSCUENTASCAP Cue
		INNER JOIN TMPSALDOSBLOQUEO Tmp ON Cue.CuentaAhoID = Tmp.Cuenta
	SET Cue.SaldoGarLiq = Tmp.Saldo,
		Cue.SaldoDispon = Cue.SaldoDispon - Tmp.Saldo;

    UPDATE TMPSALDOSCUENTASCAP Cue
		INNER JOIN TMPSALDOSMOVIMIENTOS Tmp ON Cue.CuentaAhoID = Tmp.Cuenta
	SET Cue.SaldoDispon = Cue.SaldoDispon + Tmp.SaldoMov;

    UPDATE TMPSALDOSCUENTASCAP Cue
		INNER JOIN TMPSALDOSMOVIMIENTOSACT Tmp ON Cue.CuentaAhoID = Tmp.Cuenta
	SET Cue.SaldoDispon = Cue.SaldoDispon + Tmp.SaldoMov;

    UPDATE TMPSALDOSCUENTASCAP
	SET SaldoTotal = SaldoDispon + SaldoGarLiq;

	SELECT SUM(SaldoTotal) INTO Var_SaldoMenor
	FROM TMPSALDOSCUENTASCAP
		WHERE EsMenor = MenorEdadSI;

	SET Var_SaldoMenor	:= IFNULL(Var_SaldoMenor, Decimal_Cero);


	SELECT SUM(SaldoTotal)  INTO Var_SaldoOrdinario
	FROM TMPSALDOSCUENTASCAP
		WHERE EsMenor != MenorEdadSI
			AND ClasiConta = AhorroOrdinario;

	SET Var_SaldoOrdinario	:= IFNULL(Var_SaldoOrdinario, Decimal_Cero);


	SELECT SUM(SaldoTotal)  INTO Var_SaldoVista
	FROM TMPSALDOSCUENTASCAP
		WHERE EsMenor != MenorEdadSI
			AND ClasiConta = AhorroVista;

	SET Var_SaldoVista	:= IFNULL(Var_SaldoVista, Decimal_Cero);

	-- ========= Saldo Inversiones Plazos al Dia Anterior ==========
	DROP TABLE IF EXISTS TMPSALDOINVERSION;
	CREATE TEMPORARY TABLE TMPSALDOINVERSION(
		Plazo			  INT(12),
		SaldoInversion    DECIMAL(14,2));

	IF (Var_FechaAnterior >= Var_IniMesSistema) THEN
		INSERT INTO TMPSALDOINVERSION()
		SELECT Plazo, (Monto + SaldoProvision )AS SaldoInversion
			FROM INVERSIONES
			WHERE FechaInicio <= Var_FechaAnterior
			  AND (Estatus = Inversion_Vigente
			   OR (Estatus = Inversion_Pagada
				AND FechaVencimiento != Fecha_Vacia
				AND FechaVencimiento > Var_FechaAnterior)
			   OR ( Estatus = Inversion_Cancelada
				AND FechaVenAnt != Var_FechaAnterior
				AND FechaVenAnt > Var_FechaAnterior));
	ELSE

		SET Var_FechaCieInv := (SELECT MAX(FechaCorte) FROM HISINVERSIONES WHERE FechaCorte <= Var_FechaAnterior);
		set Var_FechFinMasDias := date_add(Var_FechaCieInv, interval NumeroDias_mes day);
        INSERT INTO TMPSALDOINVERSION()
		SELECT	Plazo, (Monto+SaldoProvision) AS SaldoInversion
			FROM HISINVERSIONES Inv
			WHERE Inv.Estatus = 'N'
           --  AND Plazo <= 30
			AND	Inv.FechaCorte	= Var_FechaCieInv
			 AND Inv.ClienteID <> Cliente_Inst
				and Inv.Estatus = Estatus_Vigente
				and	(Inv.FechaVencimiento > Var_FechaCieInv
				AND Inv.FechaVencimiento <= Var_FechFinMasDias);

	END IF;



	SELECT SUM(SaldoInversion) INTO Var_SaldoInversion30
		FROM TMPSALDOINVERSION
		-- 	WHERE Plazo <= 30
        ;

	SELECT SUM(SaldoInversion) INTO Var_SaldoInversion
		FROM TMPSALDOINVERSION
			WHERE Plazo > 30 AND Plazo <= 400;

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
    SET	Var_SaldoInversion		:= IFNULL(Var_SaldoInversion,Decimal_Cero);
	SET Var_SaldoIntInversion   := IFNULL(Var_SaldoIntInversion,Decimal_Cero);

	SET Var_FechaInicioMes   := DATE(CONCAT(CAST(YEAR(Var_FechaAnterior) AS CHAR), "-", CAST(MONTH(Var_FechaAnterior) AS CHAR), "-01"));

	SELECT Estatus INTO Var_Estatus FROM  PERIODOCONTABLE
	WHERE Inicio <= Var_FechaInicioMes AND Fin >=Var_FechaAnterior;

	SET Var_Estatus	   := IFNULL(Var_Estatus, Cadena_Vacia);


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
-- ========================================================================
SET	Var_MontoPlazo30	  := IFNULL(Var_MontoPlazo30,Decimal_Cero);
SET	Var_IntPlazo30		  := IFNULL(Var_IntPlazo30,Decimal_Cero);

SET Var_MontoInversion    := Var_MontoPlazo30 + Var_MontoPlazo;
SET	Var_MontoInversion	  := IFNULL(Var_MontoInversion,Decimal_Cero);

SET Var_IntInversion      := Var_IntPlazo30 + Var_IntPlazo;
SET	Var_IntInversion	  := IFNULL(Var_IntInversion,Decimal_Cero);

SET Var_TotDepInversion   := Var_MontoInversion + Var_IntInversion;
SET	Var_TotDepInversion	  := IFNULL(Var_TotDepInversion,Decimal_Cero);

SET Var_MontoCaptado        := Var_AhorroOrdinario + Var_AhorroVista + Var_AhorroMenor + Var_TotDepInversion;
SET Var_MontoCaptado		:= IFNULL(Var_MontoCaptado,Decimal_Cero);

SET Var_PorcentualPasivo  	:= IF(Var_MontoCaptado != Entero_Cero, ((Var_TotDepInversion / Var_MontoCaptado)*100), Entero_Cero);
SET	Var_PorcentualPasivo	:= IFNULL(Var_PorcentualPasivo,Decimal_Cero);
SET Var_DifLimitePasivo		:= Var_PorcPasivCtoPlazo - Var_PorcentualPasivo;
SET	Var_DifLimitePasivo		:= IFNULL(Var_DifLimitePasivo,Decimal_Cero);

SET Var_SaldoCaptado  :=  Var_SaldoMenor + Var_SaldoOrdinario + Var_SaldoVista  ;

SET	Var_SaldoCaptado  := IFNULL(Var_SaldoCaptado,Decimal_Cero);

SET Var_PorcentualSaldo  := IF(Var_SaldoCaptado != Entero_Cero, ((Var_SaldoInversion30 / Var_SaldoCaptado)*100), Entero_Cero);
SET	Var_PorcentualSaldo	 := IFNULL(Var_PorcentualSaldo,Decimal_Cero);

SET Var_DifLimiteSaldo		:= Var_PorcPasivCtoPlazo - Var_PorcentualSaldo;
SET	Var_DifLimiteSaldo		:= IFNULL(Var_DifLimiteSaldo,Decimal_Cero);

	SELECT  FORMAT(Var_MontoCaptado,2) AS Var_MontoCaptado, 		Var_MontoCaptado AS Var_MontoCaptadoExc,
			FORMAT(Var_AhorroOrdinario,2) AS Var_AhorroOrdinario,  	Var_AhorroOrdinario AS Var_AhorroOrdinarioExc,
			FORMAT(Var_AhorroVista,2) AS Var_AhorroVista, 			Var_AhorroVista AS Var_AhorroVistaExc,
			FORMAT(Var_AhorroMenor,2) AS Var_AhorroMenor, 			Var_AhorroMenor AS Var_AhorroMenorExc,
			Var_TotDepInversion,	Var_PorcentualPasivo, 			Var_PorcPasivCtoPlazo,		Var_DifLimitePasivo,
			Var_SaldoMenor, 		Var_SaldoOrdinario, 			Var_SaldoVista,				Var_SaldoInversion30,
            Var_SaldoCaptado,		Var_PorcentualSaldo, 		    Var_DifLimiteSaldo,			Var_SaldoInversion30 AS Var_SaldoInversion;

DROP TABLE TMPSALDOSBLOQUEO;
DROP TABLE TMPSALDOSMOVIMIENTOS;
DROP TABLE TMPSALDOSMOVIMIENTOSACT;
DROP TABLE TMPMINVERSIONES;
DROP TABLE TMPSALDOINVERSION;

END TerminaStore$$