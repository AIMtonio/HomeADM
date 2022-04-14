-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TASASAPORTACIONESCAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `TASASAPORTACIONESCAL`;DELIMITER $$

CREATE PROCEDURE `TASASAPORTACIONESCAL`(
# ================================================================
# ------ SP QUE REGRESA EL VALOR DE LA TASA DE APORTACIONES ------
# ================================================================
	Par_TipoAportacionID	INT(11),		-- ID del tipo de Aportacion
	Par_Plazo				INT(11),		-- Plazo
	Par_Monto				DECIMAL(18,2),	-- Monto
	Par_Calificacion		CHAR(1),		-- Calificacion asignada
	Par_SucursalID			INT(11)			-- ID de la sucursal

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
	DECLARE TasaAnualizada			DECIMAL(12,4);	-- Tasa anualizada
	DECLARE ValorGat				DECIMAL(12,2);	-- Valor de GAT
	DECLARE ValorGatReal			DECIMAL(12,2);	-- Valor de GAT Real
	DECLARE Var_Inflacion			DECIMAL(12,4);	-- Inflacion anual proyectada
	DECLARE Var_TasaFV				CHAR(1);		-- Tasa Fija/Variable
	DECLARE Var_TasaBase			INT(2);			-- Tasa base
	DECLARE VarDiaAportacionID		INT(3);			-- Día aportacion ID
	DECLARE VarMontoAportacionID	INT(3);			-- ID del monto de la aportacion
	DECLARE Var_CalculoInteres		INT(1);			-- Calculo de interes
	DECLARE Var_SobreTasa			DECIMAL(12,4);	-- Sobretasa
	DECLARE Var_PisoTasa			DECIMAL(12,4);	-- Piso de la tasa
	DECLARE Var_TechoTasa			DECIMAL(12,4);	-- Techo de la tasa


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
								FROM TIPOSAPORTACIONES
								WHERE TipoAportacionID	=	Par_TipoAportacionID);


	IF(Var_TasaFV = ConTasaFija) THEN

		SET TasaAnualizada	:= 	FORMAT(FUNCIONTASAAPORTACION(Par_TipoAportacionID , Par_Plazo , Par_Monto, Par_Calificacion, Par_SucursalID),4);
		SET ValorGat		:=	FUNCIONCALCTAGATAPORTACION(Fecha_Vacia,Fecha_Vacia,TasaAnualizada);
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
			FROM	TASASAPORTACIONES tas INNER JOIN TASAAPORTSUCURSALES suc
					ON(tas.TipoAportacionID = suc.TipoAportacionID 	AND  tas.TasaAportacionID = suc.TasaAportacionID
														AND suc.SucursalID = Par_SucursalID)
			WHERE 	tas.TipoAportacionID 			= Par_TipoAportacionID
			AND 	tas.PlazoInferior		<= Par_Plazo
			AND		tas.PlazoSuperior		>= Par_Plazo
			AND 	tas.MontoInferior		<= Par_Monto
			AND		tas.MontoSuperior		>= Par_Monto
			AND		tas.TipoAportacionID	= Par_TipoAportacionID
			AND 	tas.Calificacion		= Par_Calificacion ;


		SET TasaAnualizada	:=	FNTASAAPORTACIONES(Var_CalculoInteres,	Var_TasaBase,
											Var_SobreTasa,		Var_PisoTasa,
											Var_TechoTasa);

		SET ValorGat		:=	FUNCIONCALCTAGATAPORTACION(Fecha_Vacia,Fecha_Vacia,TasaAnualizada);
		SET ValorGatReal	:=	FUNCIONCALCGATREAL(ValorGat,Var_Inflacion);

		SELECT TasaAnualizada,Var_TasaBase,Var_CalculoInteres,Var_SobreTasa,Var_PisoTasa,Var_TechoTasa,ValorGat, ValorGatReal;
	END IF;


END TerminaStore$$