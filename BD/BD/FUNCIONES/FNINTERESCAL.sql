-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNINTERESCAL
DELIMITER ;
DROP FUNCTION IF EXISTS `FNINTERESCAL`;DELIMITER $$

CREATE FUNCTION `FNINTERESCAL`(
/** =====================================================================================
 ** -- FUNCION QUE CALCULA EL INTERÉS PARA APORTACIONES (INTERÉS GENERADO Y A RETENER) --
 ** =====================================================================================
 */
	Par_TipoPeriodo			CHAR(1),		-- Tipo de Periodo. R: Regular I: Irregular.
	Par_CalculoInteres		INT(11),		-- Tipo de Cálculo de Interés.
	Par_MontoInv			DECIMAL(12,4),	-- Monto invertido.
	Par_DiasInv				INT(11),		-- Plazo de la inversión en días.
	Par_TasaAplicar			DECIMAL(12,4),	-- Tasa a aplicar.

	Par_SobreTasa			DECIMAL(12,4),	-- Sobre tasa.
	Par_PisoTasa			DECIMAL(12,4),	-- Piso tasa.
	Par_TechoTasa			DECIMAL(12,4)	-- Techo tasa.



) RETURNS decimal(18,2)
    DETERMINISTIC
BEGIN
	-- Declaracion de Varibles
	DECLARE Var_InteresCalculado	DECIMAL(18,4);			-- Interés generado.
	DECLARE Var_TipoCalInt			INT(11);				-- Tipo de Cálculo (interés o retención).

	-- Declaracion de Constantes
	DECLARE TasaRetencion			INT(1);
	DECLARE TasaInteres				INT(1);
	DECLARE TasarRecalculoISR		INT(1);
	DECLARE TasaFija				INT(1);
	DECLARE TasaIniPs				INT(1);
	DECLARE TasaPromedioPs			INT(1);
	DECLARE TasaAperturaPs			INT(1);
	DECLARE TasaIniPsTePi			INT(1);
	DECLARE TasaProMesTePi			INT(1);
	DECLARE TasaAperPsTePi			INT(1);
	DECLARE ConsCien				INT(3);
	DECLARE EnteroCero				INT(1);

	-- Asignacion de constantes
	SET TasaRetencion				:= 0;		-- Para Calcula el Interés a Retener.
	SET TasaInteres					:= 1;		-- Para Calcula el Interés Generado
	SET TasarRecalculoISR			:= 2;		-- Para Calcula el Interés a Retener (Recálculo).
	SET TasaFija					:= 1;		-- Tasa Fija
	SET TasaIniPs					:= 2;		-- Tasa Inicio de Mes + Puntos
	SET TasaAperturaPs				:= 3;		-- Tasa Apertura + Puntos
	SET TasaPromedioPs				:= 4;		-- Tasa Promedio del Mes + Puntos.
	SET TasaIniPsTePi				:= 5;		-- Tasa Inicio de Mes + Puntos con Piso y Techo.
	SET TasaAperPsTePi				:= 6;		-- Tasa Apertura + Puntos con Piso y Techo
	SET TasaProMesTePi				:= 7;		-- Tasa Promedio de Mes + Puntos con Piso y Techo
	SET ConsCien					:= 100;		-- Constante 100.
	SET EnteroCero					:= 0;		-- Constante cero.

	SET Var_TipoCalInt := Par_CalculoInteres;

	# CÁLCULO DE INTERÉS.
	IF (Par_CalculoInteres = TasaInteres) THEN
		# CÁLCULO DE INTERÉS CON TASA VARIABLE.
		IF (Par_CalculoInteres != TasaFija) THEN
			IF (Par_CalculoInteres = TasaIniPs OR Par_CalculoInteres = TasaPromedioPs OR Par_CalculoInteres = TasaAperturaPs) THEN
				SET Par_TasaAplicar := Par_TasaAplicar + Par_SobreTasa;
			END IF;

			IF (Par_CalculoInteres = TasaIniPsTePi OR Par_CalculoInteres = TasaProMesTePi OR Par_CalculoInteres = TasaAperPsTePi) THEN
				SET Par_TasaAplicar := Par_TasaAplicar + Par_SobreTasa;

				IF(Par_TasaAplicar < Par_PisoTasa) THEN
					SET Par_TasaAplicar := Par_PisoTasa;
				END IF;

				IF(Par_TasaAplicar > Par_TechoTasa) THEN
					SET Par_TasaAplicar := Par_TechoTasa;
				END IF;
			END IF;
		END IF;
		SET Par_TasaAplicar := IFNULL(Par_TasaAplicar,EnteroCero);
	END IF;

	SET Var_InteresCalculado := FNFORMINTERES(Var_TipoCalInt,Par_TipoPeriodo,Par_MontoInv,Par_TasaAplicar,Par_DiasInv);

	RETURN ROUND(IFNULL(Var_InteresCalculado,EnteroCero),2);
END$$