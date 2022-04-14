-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNRENINVERSION
DELIMITER ;
DROP FUNCTION IF EXISTS `FNRENINVERSION`;DELIMITER $$

CREATE FUNCTION `FNRENINVERSION`(
# ====================================================
# --- FUNCION QUE CALCULA EL ISR PARA TASA VARIABLE---
# ====================================================
	CalculoInteres  INT(1),
	MontoInver		DECIMAL(12,4),
	DiasInver		INT(2),
	DiasBase		INT(3),
	TasaAplicar   	DECIMAL(12,4),
	SobreTasa		DECIMAL(12,4),
	PisoTasa		DECIMAL(12,4),
	TechoTasa		DECIMAL(12,4)
) RETURNS decimal(18,2)
    DETERMINISTIC
BEGIN
	-- Declaracion de Varibles
	DECLARE resultado			DECIMAL(18,4);

	-- Declaracion de Constantes
	DECLARE TASAIniPs			INT(1);
	DECLARE TASAPromedioPs		INT(1);
	DECLARE TASAAperturaPs		INT(1);
	DECLARE TASAIniPsTePi		INT(1);
	DECLARE TASAProMesTePi		INT(1);
	DECLARE TASAAperPsTePi		INT(1);
	DECLARE	ConsCien			INT(3);

    -- Asignacion de constantes
	SET TASAIniPs				:= 2;		-- TASA Inicio de Mes + Puntos
	SET TASAAperturaPs			:= 3;		-- TASA Apertura + Puntos
	SET TASAPromedioPs 			:= 4;       -- TASA Promedio del Mes + Puntos.
	SET TASAIniPsTePi			:= 5;       -- TASA Inicio de Mes + Puntos con Piso y Techo.
	SET TASAAperPsTePi			:= 6;		-- Tasa Apertura + Puntos con Piso y Techo
	SET TASAProMesTePi			:= 7;		-- Tasa Promedio de Mes + Puntos con Piso y Techo
	SET ConsCien  				:= 100;     -- Constante 100.

	IF (CalculoInteres = TASAIniPs OR CalculoInteres = TASAPromedioPs OR CalculoInteres = TASAAperturaPs) THEN
		SET TasaAplicar=TasaAplicar+SobreTasa;
		SET resultado=ROUND(MontoInver*(TasaAplicar)*DiasInver/(DiasBase*ConsCien),2);
	END IF;

	IF (CalculoInteres = TASAIniPsTePi OR CalculoInteres = TASAProMesTePi OR CalculoInteres = TASAAperPsTePi) THEN

		SET TasaAplicar=TasaAplicar+SobreTasa;

		IF(TasaAplicar < PisoTasa) THEN
			SET TasaAplicar=PisoTasa;
		END IF;

		IF(TasaAplicar > TechoTasa) THEN
			SET TasaAplicar=TechoTasa;
		END IF;

		SET resultado=ROUND(MontoInver*(TasaAplicar)*DiasInver/(DiasBase*ConsCien),2);

	END IF;


      RETURN ROUND(resultado,2);
END$$