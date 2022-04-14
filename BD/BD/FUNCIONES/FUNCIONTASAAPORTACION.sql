-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FUNCIONTASAAPORTACION
DELIMITER ;
DROP FUNCTION IF EXISTS `FUNCIONTASAAPORTACION`;DELIMITER $$

CREATE FUNCTION `FUNCIONTASAAPORTACION`(
# ================================================================
# --- FUNCION QUE DEVUELVE EL VALOR DE LA TASA DE APORTACIONES ---
# ================================================================
	Par_TipoAportacionID	INT(11),		-- ID del tipo de aportacion
	Par_Plazo				INT(11),		-- Plazo de la aportacion
	Par_Monto				DECIMAL(18,2),	-- Monto de la aportacion
	Par_Calificacion		CHAR(1),		-- Calificacion asignada
	Par_SucursalID			INT(11)			-- ID de la sucursal



) RETURNS decimal(8,4)
    DETERMINISTIC
BEGIN

	-- Declaracion de variables
	DECLARE	VarDiaAportacionID		INT(11);				-- ID del dia de la aportacion
	DECLARE	VarMontoAportacionID	INT(11);				-- ID del monto de la aportacion
	DECLARE Entero_Cero				INT(11);				-- Entero cero
	DECLARE VarTasaAportacionID		INT(11);				-- ID de la tasa
	DECLARE Var_ValorTasa			DECIMAL(12,4);			-- Valor de la tasa
	DECLARE Var_TasaFV				CHAR(1);				-- Tasa Fija/Variable

	-- Declaracion de Constantes
	DECLARE VarTasaFija				CHAR(1);
	DECLARE VarTasaVariable			CHAR(1);

	-- Asignacion de variables
	SET VarDiaAportacionID			:= 0;					-- Inicializacion de Variables
	SET VarMontoAportacionID		:= 0;					-- Inicializacion de Variables
	SET VarTasaAportacionID			:= 0;					-- Inicializacion de Variables
	SET Var_ValorTasa				:= 0;					-- Inicializacion de Variables

	-- Asignacion de Constantes
	SET VarTasaFija					:= 'F';					-- Tasa Fija
	SET VarTasaVariable				:= 'V';					-- Tasa Variable
	SET Entero_Cero					:= 0;					-- Constante Entero Cero

	-- Se revisa si hay una tasa parametrizada
	SET Var_TasaFV		:= (SELECT TasaFV
								FROM TIPOSAPORTACIONES
								WHERE TipoAportacionID	=	Par_TipoAportacionID);

	IF(Var_TasaFV LIKE VarTasaFija) THEN
		SET Var_ValorTasa	:=	(SELECT tas.TasaFija
									FROM	TASASAPORTACIONES tas INNER JOIN TASAAPORTSUCURSALES suc
											ON(tas.TipoAportacionID = suc.TipoAportacionID AND  tas.TasaAportacionID = suc.TasaAportacionID
																			   AND 	suc.SucursalID = Par_SucursalID)
									WHERE 	tas.TipoAportacionID 	= Par_TipoAportacionID
									AND		MontoInferior 			<= Par_Monto
									AND		MontoSuperior			>= Par_Monto
									AND		PlazoInferior			<= Par_Plazo
									AND		PlazoSuperior			>= Par_Plazo
									AND 	tas.Calificacion = Par_Calificacion);


		SET Var_ValorTasa		:=	IFNULL(Var_ValorTasa, Entero_Cero);
	END IF;

	IF(Var_TasaFV LIKE VarTasaVariable) THEN
		SET Var_ValorTasa		:=	(SELECT	tas.TasaBase
										FROM 	TASASAPORTACIONES tas INNER JOIN TASAAPORTSUCURSALES suc
												ON(tas.TipoAportacionID = suc.TipoAportacionID 	AND  tas.TasaAportacionID = suc.TasaAportacionID
																					AND suc.SucursalID = Par_SucursalID)
										WHERE 	tas.TipoAportacionID 	= Par_TipoAportacionID
										AND		tas.MontoInferior 		<= Par_Monto
										AND		tas.MontoSuperior		>= Par_Monto
										AND		tas.PlazoInferior		<= Par_Plazo
										AND		tas.PlazoSuperior		>= Par_Plazo
										AND 	tas.Calificacion 		= Par_Calificacion);

		SET Var_ValorTasa		:=	IFNULL(Var_ValorTasa, Entero_Cero);
	END IF;

	RETURN Var_ValorTasa;
END$$