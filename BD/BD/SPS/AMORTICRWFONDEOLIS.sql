-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AMORTICRWFONDEOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `AMORTICRWFONDEOLIS`;

DELIMITER $$
CREATE PROCEDURE `AMORTICRWFONDEOLIS`(
/* LISTA DE CALENDARIO DE PAGOS DE INVERSIONISTAS. */
	Par_SolFondeoID  	BIGINT(20),			-- Solicitud de Fondeo.
	Par_NumLis			TINYINT UNSIGNED,	-- Númoero de lista.
	/* Parámetros de Auditoría. */
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,

	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

/* Declaracion de Variables */
DECLARE Var_TotalSalCap		DECIMAL(12,2);
DECLARE Var_TotalSalInteres	DECIMAL(12,2);
DECLARE Var_TotalMoratorio	DECIMAL(12,2);
DECLARE Var_TotalCapitalCO	DECIMAL(12,2);
DECLARE Var_TotalInteresCO	DECIMAL(12,2);
DECLARE Var_FechaSistema	DATE;

/* Declaracion de Constantes */
DECLARE Lis_Principal		INT;
DECLARE Lis_GridAmorInv		INT;
DECLARE Entero_Cero			INT;
DECLARE Est_Pagado			CHAR(1);
DECLARE Est_Vigente			CHAR(1);

/* Asigancion de Constantes */
SET Entero_Cero				:= 0;		-- Constante entero cero.
SET Lis_Principal			:= 1;		-- Lista principal.
SET Lis_GridAmorInv			:= 2;		-- Lista grid.
SET Est_Pagado				:= "P";		-- Estatus Pagado.
SET Est_Vigente				:= "N";		-- Estatus Vigente.

/* Asignacion de Variables */
SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS);

IF(Par_NumLis = Lis_GridAmorInv) THEN
	SELECT
		SUM(IFNULL((SaldoCapVigente+SaldoCapExigible),Entero_Cero)),
		SUM(ROUND(IFNULL((SaldoInteres),Entero_Cero),2)),
		SUM(ROUND(IFNULL((SaldoIntMoratorio),Entero_Cero),2)),
		SUM(ROUND(IFNULL((SaldoCapCtaOrden),Entero_Cero),2)),
		SUM(ROUND(IFNULL((SaldoIntCtaOrden),Entero_Cero),2))
	INTO
		Var_TotalSalCap,
		Var_TotalSalInteres,
		Var_TotalMoratorio,
		Var_TotalCapitalCO,
		Var_TotalInteresCO
	FROM AMORTICRWFONDEO
		WHERE SolFondeoID = Par_SolFondeoID;

	SELECT
		AmortizacionID,	FechaInicio,	FechaVencimiento,	FechaExigible,	Capital,
		InteresGenerado,
		CASE WHEN FechaExigible< Var_FechaSistema  AND Estatus <> Est_Pagado THEN 'ATRASADO' ELSE Estatus END AS Estatus,
		ROUND(SaldoCapVigente + SaldoCapExigible, 2) AS SaldoCapital,
		ROUND(SaldoInteres, 2) AS SaldoInteres,
		ROUND(SaldoIntMoratorio,2) AS SaldoIntMoratorio,
		ROUND(SaldoCapCtaOrden,2) AS SaldoCapCtaOrden,
		ROUND(SaldoIntCtaOrden,2) AS SaldoIntCtaOrden,

		ROUND(Var_TotalSalCap,2) AS TotalSalCap,
		ROUND(Var_TotalSalInteres,2) AS TotalSalInteres,
		ROUND(Var_TotalMoratorio,2) AS TotalMoratorio,
		ROUND(Var_TotalCapitalCO,2) AS TotalCapitalCO,
		ROUND(Var_TotalInteresCO,2) AS TotalInteresCO,

		FechaLiquida, InteresRetener
	FROM AMORTICRWFONDEO
		WHERE SolFondeoID = Par_SolFondeoID;
END IF;

END TerminaStore$$