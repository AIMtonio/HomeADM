
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNGETPLDSITIPERIODO

DELIMITER ;
DROP FUNCTION IF EXISTS `FNGETPLDSITIPERIODO`;

DELIMITER $$
CREATE FUNCTION `FNGETPLDSITIPERIODO`(
/* FUNCIÓN QUE GENERA LA FECHA DEL PERIODO A REPORTAR PARA REP.PLD. */
	Par_TipoReporte			TINYINT			-- TIPO DE REPORTE
) RETURNS DATE
    DETERMINISTIC
BEGIN
	-- Declaracion Variables
	DECLARE Var_FechaPeriodo	DATE;	-- RESULTADO.
	DECLARE Var_FechaSistema	DATE;	-- FECHA DEL SISTEMA.
	DECLARE Var_FechaInusRep	DATE;	-- FECHA DE LAS OP. A REPORTAR.
	DECLARE Var_TipoPeriodo		CHAR(1);-- TIPO DE CONSULTA

	-- Declaracion de Constantes
	DECLARE Estatus_Activo		CHAR(1);
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Fecha_Vacia			DATE;
	DECLARE Entero_Cero			INT;
	DECLARE Tipo_PeriodoFechMax	INT;
	DECLARE Tipo_PeriodoFinMes	INT;
	DECLARE Estatus_Reportar	INT;

	-- Asignacion de Constantes
	SET Estatus_Activo			:= 'A';				-- ESTATUS ACTIVO.
	SET Cadena_Vacia			:= '';				-- CADENA VACIA.
	SET Fecha_Vacia				:= '1900-01-01';	-- FECHA VACIA.
	SET Entero_Cero				:= 0;				-- ENTERO CERO.
	SET Tipo_PeriodoFechMax		:= 01;				-- FECHA MAX DE LAS OP REPORTADAS.
	SET Tipo_PeriodoFinMes		:= 02;				-- FIN DE MES DE LAS OP REPORTADAS.
	SET Estatus_Reportar		:= 03;				-- ESTATUS A REPORTAR (INUSUALES).

	SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
	SET Var_FechaInusRep := (SELECT MAX(Inu.FechaDeteccion) FROM PLDOPEINUSUALES Inu
								WHERE Inu.Estatus = Estatus_Reportar AND Inu.FolioInterno > Entero_Cero);
	SET Var_TipoPeriodo := LEFT(FNPARAMGENERALES('PLDSITI_TipoPeriodo'),1);
	SET Var_TipoPeriodo := IF(TRIM(Var_TipoPeriodo) = Cadena_Vacia, Tipo_PeriodoFechMax,TRIM(Var_TipoPeriodo));

	IF(IFNULL(Var_TipoPeriodo, Entero_Cero) = Tipo_PeriodoFechMax)THEN
		SET Var_FechaPeriodo := Var_FechaInusRep;
	END IF;

	IF(IFNULL(Var_TipoPeriodo, Entero_Cero) = Tipo_PeriodoFinMes)THEN
		SET Var_FechaPeriodo := LAST_DAY(Var_FechaInusRep);
	END IF;

RETURN IFNULL(Var_FechaPeriodo, Fecha_Vacia);
END$$

