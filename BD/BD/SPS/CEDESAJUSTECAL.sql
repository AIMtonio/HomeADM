-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CEDESAJUSTECAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `CEDESAJUSTECAL`;DELIMITER $$

CREATE PROCEDURE `CEDESAJUSTECAL`(
	/* SP creado para el Ajuste de Interes */
	Par_CedeID				INT(11),		-- Cede a la Cual se hara el Ajuste de Interes.
    Par_Tasa				DECIMAL(14,4),	-- Nueva Tasa(Tasa Fija).
    Par_TasaBaseID			INT(11),		-- Nueva Tasa Base(Tasa Variable)
    Par_SobreTasa			DECIMAL(14,4),	-- Nueva Sobre Tasa(Tasa Variable)
    Par_PisoTasa			DECIMAL(14,4),	-- Nuevo Piso Tasa(Tasa Variable)
    Par_TechoTasa			DECIMAL(14,4),	-- Nuevo Techo Tasa(Tasa Variable)
    Par_CalculoInteres		INT(11),   		-- Nuevo Calculo Interes(Tasa Variable)
    Par_TipoAjuste			INT(1)
)
TerminaStored:BEGIN

	-- Declaracion de Variables
	DECLARE Var_FechaVencimiento	DATE;
	DECLARE Var_DiasBase			INT(11);
	DECLARE Var_FechaSistema		DATE;
	DECLARE Var_DiasRestantes		INT(11);
	DECLARE Var_NuevoInteresGene	DECIMAL(18,2);
	DECLARE Var_NuevoInteresReci	DECIMAL(18,2);
	DECLARE Var_TotalInteres		DECIMAL(18,2);
	DECLARE Var_TipoTasa			CHAR(1);
	DECLARE Var_TasaAnt				DECIMAL(18,4);
	DECLARE Var_SaldoProvision		DECIMAL(18,2);
	DECLARE Var_MontoCede			DECIMAL(18,2);
	DECLARE Var_InteresOrigi		DECIMAL(18,2);
	DECLARE Var_IntMejorado			DECIMAL(18,2);
	DECLARE Var_IntRetener			DECIMAL(18,2);

	-- Declaracion de Constantes
	DECLARE EnteroCero				INT(1);
	DECLARE Entero_Dos				INT(1);
	DECLARE DecimalCero				DECIMAL(2,2);
	DECLARE ConstanteCien			INT(11);
	DECLARE Consulta				INT(1);
	DECLARE EstVigente				CHAR(1);

	-- Asignacion de Constantes
	SET EnteroCero			:=	0;
	SET Entero_Dos			:=	2;
	SET DecimalCero			:=	0.0;
	SET ConstanteCien		:=	100;
	SET Consulta			:=	1;
	SET EstVigente			:=	'N';
	SET Var_TasaAnt			:=	0.00;

	SELECT 	DiasInversion,	FechaSistema
	INTO	Var_DiasBase,	Var_FechaSistema
		FROM PARAMETROSSIS;

	SELECT 	cede.FechaVencimiento,	cat.TasaFV, 			cede.TasaFija, 	cede.Monto,				cede.InteresGenerado,
			cede.InteresRetener
		INTO
			Var_FechaVencimiento,	Var_TipoTasa,			Var_TasaAnt, Var_MontoCede,			Var_InteresOrigi,
			Var_IntRetener
		FROM CEDES cede
			INNER JOIN TIPOSCEDES cat ON cede.TipoCedeID = cat.TipoCedeID
		WHERE cede.CedeID = Par_CedeID;
	SELECT
		SUM(SaldoProvision)
			INTO Var_SaldoProvision
				FROM RENDIMIENTOCEDES WHERE CedeID=Par_CedeID;

	SET Var_DiasRestantes	:=	DATEDIFF(Var_FechaVencimiento, Var_FechaSistema);
	SET Var_DiasRestantes	:= IFNULL(Var_DiasRestantes,EnteroCero);
	SET Var_TasaAnt 		:= IFNULL(Var_TasaAnt, EnteroCero);
	SET Var_SaldoProvision	:= IFNULL(Var_SaldoProvision, EnteroCero);
	SET Var_MontoCede		:= IFNULL(Var_MontoCede, EnteroCero);
	SET Var_InteresOrigi	:= IFNULL(Var_InteresOrigi, EnteroCero);


	IF(Par_TipoAjuste = Consulta) THEN

		SET Var_NuevoInteresGene := ROUND(Var_MontoCede * Var_DiasRestantes * Par_Tasa / (Var_DiasBase * ConstanteCien), Entero_Dos);

		SET Var_IntMejorado := ROUND((Var_NuevoInteresGene + Var_SaldoProvision)-Var_InteresOrigi, Entero_Dos);

		IF(Var_IntMejorado < EnteroCero) THEN
			SET Var_IntMejorado := EnteroCero;
		END IF;
		SET  Var_NuevoInteresReci:=(Var_SaldoProvision+Var_NuevoInteresGene)-Var_IntRetener;

		SELECT Var_IntMejorado AS InteresGenerado,
			   Var_NuevoInteresReci AS InteresRecibir,
			   Var_NuevoInteresReci  AS TotalInteres;

	END IF;

END TerminaStored$$