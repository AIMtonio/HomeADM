-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TASASCEDESCAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `TASASCEDESCAL`;
DELIMITER $$


CREATE PROCEDURE `TASASCEDESCAL`(
# ========================================================
# ------ SP QUE REGRESA EL VALOR DE LA TASA DE CEDES------
# ========================================================
	Par_TipoCedeID			INT(11),
	Par_Plazo				INT(11),
	Par_Monto				DECIMAL(18,2),
	Par_Calificacion		CHAR(1),
	Par_SucursalID			INT(11)

)

TerminaStore: BEGIN
	-- Declaracion de constantes
	DECLARE Fecha_Vacia			DATE;
	DECLARE Entero_Cero			INT(11);
	DECLARE DecimalCero			DECIMAL(18,2);
	DECLARE ConTasaFija			CHAR(1);
	DECLARE ConTasaVariable		CHAR(1);
	DECLARE CalculoFijo			INT(1);

	-- Declaracion de variables
	DECLARE TasaAnualizada		DECIMAL(12,4);
	DECLARE ValorGat			DECIMAL(12,2);
	DECLARE ValorGatReal		DECIMAL(12,2);
	DECLARE Var_Inflacion		DECIMAL(12,4);
	DECLARE Var_TasaFV			CHAR(1);
	DECLARE Var_TasaBase		INT(2);
	DECLARE VarDiaCedeID		INT(3);
	DECLARE VarMontoCedeID		INT(3);
	DECLARE Var_CalculoInteres	INT(1);
	DECLARE Var_SobreTasa		DECIMAL(12,4);
	DECLARE Var_PisoTasa		DECIMAL(12,4);
	DECLARE Var_TechoTasa		DECIMAL(12,4);
	DECLARE Var_Fechaapertura      DATE; -- FECHA APERTURA CEDE LAYALA
	DECLARE Var_FechaOperacion     DATE; -- FECHA APERTURA CEDE LAYALA


	-- Asignacion de Constantes
	SET Entero_Cero				:= 0;				-- Constante Entero Cero
	SET Fecha_Vacia				:= '1900-01-01';	-- Constante fecha Vacia
	SET TasaAnualizada			:= 0.0;				-- Constante Tasa
	SET ValorGat				:= 0.0;				-- Constante Gat
	SET DecimalCero				:= 0.0;				-- COnstante DECIMAL Cero
	SET ConTasaFija				:= 'F';				-- Tasa Fija
	SET ConTasaVariable			:= 'V';				-- Tasa Variable
	SET CalculoFijo				:= 1;				-- Calculo Fijo

	SET Var_Inflacion	:=	(SELECT InflacionProy
								FROM INFLACIONACTUAL
								WHERE FechaActualizacion =
										(SELECT MAX(FechaActualizacion)
												FROM INFLACIONACTUAL));
	SET Var_TasaFV		:= (SELECT TasaFV
								FROM TIPOSCEDES
								WHERE TipoCedeID	=	Par_TipoCedeID);

	SET Var_Fechaapertura = (SELECT FechaSistema from PARAMETROSSIS LIMIT 1);
	SET Var_FechaOperacion = DATE_ADD(Var_Fechaapertura,INTERVAL Par_Plazo DAY);

	IF(Var_TasaFV = ConTasaFija) THEN

		SET TasaAnualizada	:= 	FORMAT(FUNCIONTASACEDE(Par_TipoCedeID , Par_Plazo , Par_Monto, Par_Calificacion, Par_SucursalID),4);
		SET ValorGat		:=	FUNCIONCALCTAGATCEDE(Var_FechaOperacion,Var_Fechaapertura,TasaAnualizada);
		SET ValorGatReal	:=	FUNCIONCALCGATREAL(ValorGat,Var_Inflacion);
		SET Var_TasaBase 	:=	Entero_Cero;

		SET Var_CalculoInteres := CalculoFijo;
		SET Var_SobreTasa 	   := DecimalCero;
		SET Var_PisoTasa 	   := DecimalCero;
		SET Var_TechoTasa 	   := DecimalCero;

		SELECT TasaAnualizada,Var_TasaBase,Var_CalculoInteres,Var_SobreTasa,Var_PisoTasa,Var_TechoTasa,ValorGat, ValorGatReal;

	END IF;

	IF(Var_TasaFV = ConTasaVariable) THEN

		SELECT tas.TasaBase, tas.CalculoInteres, tas.SobreTasa, tas.PisoTasa, tas.TechoTasa
				INTO Var_TasaBase,Var_CalculoInteres,Var_SobreTasa,Var_PisoTasa,Var_TechoTasa
			FROM	TASASCEDES tas INNER JOIN TASACEDESUCURSALES suc
					ON(tas.TipoCedeID = suc.TipoCedeID 	AND  tas.TasaCedeID = suc.TasaCedeID
														AND suc.SucursalID = Par_SucursalID)
			WHERE 	tas.TipoCedeID 			= Par_TipoCedeID
			AND 	tas.PlazoInferior		<= Par_Plazo
			AND		tas.PlazoSuperior		>= Par_Plazo
			AND 	tas.MontoInferior		<= Par_Monto
			AND		tas.MontoSuperior		>= Par_Monto
			AND		tas.TipoCedeID		 	= Par_TipoCedeID
			AND 	tas.Calificacion		= Par_Calificacion ;


		SET TasaAnualizada	:=	FNTASACEDES(Var_CalculoInteres,	Var_TasaBase,
											Var_SobreTasa,		Var_PisoTasa,
											Var_TechoTasa);

		SET ValorGat		:=	FUNCIONCALCTAGATCEDE(Var_FechaOperacion,Var_Fechaapertura,TasaAnualizada);
		SET ValorGatReal	:=	FUNCIONCALCGATREAL(ValorGat,Var_Inflacion);

		SELECT TasaAnualizada,Var_TasaBase,Var_CalculoInteres,Var_SobreTasa,Var_PisoTasa,Var_TechoTasa,ValorGat, ValorGatReal;
	END IF;


END TerminaStore$$