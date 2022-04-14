-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FUNCIONTASACEDE
DELIMITER ;
DROP FUNCTION IF EXISTS `FUNCIONTASACEDE`;
DELIMITER $$

CREATE FUNCTION `FUNCIONTASACEDE`(
# ========================================================
# --- FUNCION QUE DEVUELVE EL VALOR DE LA TASA DE CEDES---
# ========================================================
	Par_TipoCedeID			INT(11),
	Par_Plazo				INT(11),
	Par_Monto				DECIMAL(18,2),
	Par_Calificacion		CHAR(1),
	Par_SucursalID			INT(11)
) RETURNS decimal(8,4)
    DETERMINISTIC
BEGIN

	-- Declaracion de variables
	DECLARE	VarDiaInversionID		INT(11);
	DECLARE	VarMontoInversionID		INT(11);
	DECLARE Entero_Cero				INT(11);
	DECLARE VarTasaInversionID		INT(11);
	DECLARE Var_ValorTasa			DECIMAL(12,4);
	DECLARE Var_TasaFV				CHAR(1);

	-- Declaracion de Constantes
	DECLARE VarTasaFija				CHAR(1);
	DECLARE VarTasaVariable			CHAR(1);

	-- Asignacion de variables
	SET VarDiaInversionID			:= 0;					-- Inicializacion de Variables
	SET VarMontoInversionID			:= 0;					-- Inicializacion de Variables
	SET VarTasaInversionID			:= 0;					-- Inicializacion de Variables
	SET Var_ValorTasa				:= 0;					-- Inicializacion de Variables

	-- Asignacion de Constantes
	SET VarTasaFija					:= 'F';					-- Tasa Fija
	SET VarTasaVariable				:= 'V';					-- Tasa Variable
	SET Entero_Cero					:= 0;					-- Constante Entero Cero

	-- Se revisa si hay una tasa parametrizada
	SET Var_TasaFV		:= (SELECT TasaFV
								FROM TIPOSCEDES
								WHERE TipoCedeID	=	Par_TipoCedeID);

	IF(Var_TasaFV LIKE VarTasaFija) THEN
		SET Var_ValorTasa	:=	(SELECT tas.TasaFija
									FROM	TASASCEDES tas INNER JOIN TASACEDESUCURSALES suc
											ON(tas.TipoCedeID = suc.TipoCedeID AND  tas.TasaCedeID = suc.TasaCedeID
																			   AND 	suc.SucursalID = Par_SucursalID)
									WHERE 	tas.TipoCedeID 	= Par_TipoCedeID
									AND		MontoInferior 	<= Par_Monto
									AND		MontoSuperior	>= Par_Monto
									AND		PlazoInferior	<= Par_Plazo
									AND		PlazoSuperior	>= Par_Plazo
									AND 	tas.Calificacion = Par_Calificacion
									LIMIT 1);


		SET Var_ValorTasa		:=	IFNULL(Var_ValorTasa, Entero_Cero);
	END IF;

	IF(Var_TasaFV LIKE VarTasaVariable) THEN
		SET Var_ValorTasa		:=	(SELECT	tas.TasaBase
										FROM 	TASASCEDES tas INNER JOIN TASACEDESUCURSALES suc
												ON(tas.TipoCedeID = suc.TipoCedeID 	AND  tas.TasaCedeID = suc.TasaCedeID
																					AND suc.SucursalID = Par_SucursalID)
										WHERE 	tas.TipoCedeID 		= Par_TipoCedeID
										AND		tas.MontoInferior 	<= Par_Monto
										AND		tas.MontoSuperior	>= Par_Monto
										AND		tas.PlazoInferior	<= Par_Plazo
										AND		tas.PlazoSuperior	>= Par_Plazo
										AND 	tas.Calificacion 	= Par_Calificacion);

		SET Var_ValorTasa		:=	IFNULL(Var_ValorTasa, Entero_Cero);
	END IF;

	RETURN Var_ValorTasa;
END$$