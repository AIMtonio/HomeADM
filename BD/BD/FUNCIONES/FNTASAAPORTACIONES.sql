-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNTASAAPORTACIONES
DELIMITER ;
DROP FUNCTION IF EXISTS `FNTASAAPORTACIONES`;DELIMITER $$

CREATE FUNCTION `FNTASAAPORTACIONES`(
# ========================================================================
# --- FUNCION QUE DEVUELVE EL VALOR DE LA TASA DE APORTACIONES A PLAZO ---
# ========================================================================
	Par_CalculoInteres		INT(11),		-- Calculo de interes
	Par_TasaBaseID			INT(11),		-- ID de la tasa base
	Par_SobreTasa			DECIMAL(12,4),	-- Sobretasa
	Par_PisoTasa			DECIMAL(12,4),	-- Piso de la tasa
	Par_TechoTasa			DECIMAL(12,4)	-- Techo de la tasa



) RETURNS decimal(12,4)
    DETERMINISTIC
BEGIN

	-- Declaracion de Constantes
	DECLARE InicoMesPts		INT(1);
	DECLARE AperPts 		INT(1);
	DECLARE PromMesPts		INT(1);
	DECLARE PromMesPtsPiTe	INT(1);
	DECLARE IniMesPtsPiTe	INT(1);
	DECLARE AperPtsPiTe		INT(1);
	DECLARE PromPtsPiTe		INT(1);
	DECLARE DecimalCero		DECIMAL(18,2);

	-- Declaracion de variables
	DECLARE FechaActual		DATE;			-- Fecha actual
	DECLARE InicioMes		DATE;			-- Inicio de mes
	DECLARE resultado		DECIMAL(12,4);	-- Resultado
	DECLARE DiaPromedio 	INT(2);			-- Dia promedio
	DECLARE Var_ValorTasa	DECIMAL(18,2);	-- Valor de la tasa

	-- Asignacion de constantes
	SET InicoMesPts			:=	2;		-- Tasa de Inicio de Mes + Puntos
	SET AperPts				:=	3;		-- Tasa de Apertura + Puntos
	SET PromMesPts			:=	4;		-- Tasa Promedio Mes + Puntos
	SET IniMesPtsPiTe		:=	5;		-- Tasa de Inicio de Mes + Puntos con Piso y Techo
	SET AperPtsPiTe			:=	6;		-- Tasa de Apertura + Puntos con Piso y Techo
	SET PromMesPtsPiTe		:=	7;		-- Tasa Promedio de Mes + Puntos con Piso y techo
	SET DecimalCero			:=	0.0;	-- Constante Decimal Cero

	SET FechaActual			:= (SELECT FechaSistema FROM PARAMETROSSIS);
	SET InicioMes			:= CONVERT(CONCAT(EXTRACT(YEAR_MONTH FROM FechaActual),'01'),DATE);
	SET DiaPromedio			:=	DAY(FechaActual);

	IF(Par_CalculoInteres=InicoMesPts) THEN
		SET resultado = (SELECT Valor
							FROM CALHISTASASBASE
							WHERE TasaBaseID=Par_TasaBaseID AND Fecha=InicioMes);

		IF(IFNULL(resultado,DecimalCero) = DecimalCero) THEN
			SET resultado =(SELECT Valor FROM TASASBASE	WHERE TasaBaseID = Par_TasaBaseID);
		END IF;
		SET resultado	=	resultado	+	Par_SobreTasa;
	END IF;

	IF(Par_CalculoInteres=AperPts) THEN
		SET resultado=(SELECT Valor
							FROM CALHISTASASBASE
							WHERE TasaBaseID=Par_TasaBaseID AND Fecha=FechaActual);

		IF(IFNULL(resultado,DecimalCero) = DecimalCero) THEN
			SET resultado = (SELECT Valor FROM TASASBASE WHERE TasaBaseID=Par_TasaBaseID);
		END IF;

		SET resultado = resultado + Par_SobreTasa;

	END IF;

	IF(Par_CalculoInteres=PromMesPts) THEN
		SET resultado=(SELECT SUM(Valor)/DiaPromedio
							FROM CALHISTASASBASE
							WHERE TasaBaseID=Par_TasaBaseID AND Fecha>=InicioMes AND Fecha <= FechaActual);

		SET resultado=IFNULL(resultado,DecimalCero);

		IF(resultado=DecimalCero) THEN
			SET resultado=(SELECT Valor/DiaPromedio FROM TASASBASE WHERE TasaBaseID=Par_TasaBaseID);
		END IF;

		SET resultado = resultado + Par_SobreTasa;

	END IF;

	IF(Par_CalculoInteres=IniMesPtsPiTe) THEN
		SET resultado=(SELECT Valor
							FROM CALHISTASASBASE
							WHERE TasaBaseID=Par_TasaBaseID AND Fecha=InicioMes);

		IF(IFNULL(resultado,DecimalCero) = DecimalCero) THEN
			SET resultado = (SELECT Valor FROM TASASBASE WHERE TasaBaseID=Par_TasaBaseID);
		END IF;

		SET resultado = resultado + Par_SobreTasa;

		IF(resultado<Par_PisoTasa)THEN
			SET resultado = Par_PisoTasa;
		END IF;
		IF(resultado>Par_TechoTasa) THEN
			SET resultado = Par_TechoTasa;
		END IF;

	END IF;

	IF(Par_CalculoInteres=AperPtsPiTe) THEN
		SET resultado=(SELECT Valor
							FROM CALHISTASASBASE
							WHERE TasaBaseID=Par_TasaBaseID AND Fecha = FechaActual);

		IF(IFNULL(resultado,DecimalCero) = DecimalCero) THEN
			SET resultado = (SELECT Valor FROM TASASBASE WHERE TasaBaseID=Par_TasaBaseID);
		END IF;

		SET resultado = resultado + Par_SobreTasa;

		IF(resultado<Par_PisoTasa)THEN
			SET resultado = Par_PisoTasa;
		END IF;
		IF(resultado>Par_TechoTasa) THEN
			SET resultado = Par_TechoTasa;
		END IF;

	END IF;

	IF(Par_CalculoInteres=PromMesPtsPiTe) THEN
		SET resultado=(SELECT SUM(Valor)/DiaPromedio
							FROM CALHISTASASBASE
							WHERE TasaBaseID=Par_TasaBaseID AND Fecha>=InicioMes AND Fecha <= FechaActual);

		SET resultado=IFNULL(resultado,DecimalCero);
		 IF(resultado=DecimalCero) THEN
			SET resultado=(SELECT Valor FROM TASASBASE WHERE TasaBaseID=Par_TasaBaseID);
		 END IF;

		SET resultado = resultado + Par_SobreTasa;

		IF(resultado<Par_PisoTasa)THEN
			SET resultado = Par_PisoTasa;
		END IF;
		IF(resultado>Par_TechoTasa) THEN
			SET resultado = Par_TechoTasa;
		END IF;
	END IF;


	RETURN resultado;
END$$