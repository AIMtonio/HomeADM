-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNFORMINTERES
DELIMITER ;
DROP FUNCTION IF EXISTS `FNFORMINTERES`;DELIMITER $$

CREATE FUNCTION `FNFORMINTERES`(
/** ==================================================================
 ** -- FUNCION QUE CALCULA EL INTERÉS PARA APORTACIONES --------------
 ** -- CONFORME A FÓRMULA ESPECÍFICA (INTERÉS GENERADO Y A RETENER) --
 ** ==================================================================
 */
	Par_TipoCalculo			INT(11),		-- Tipo de Cálculo. 0: Retención 1: Interes. 2: Retencion Restante
	Par_TipoPeriodo			CHAR(1),		-- Tipo de Periodo. R: Regular I: Irregular.
	Par_MontoInv			DECIMAL(18,2),	-- Monto invertido.
	Par_TasaAplicar			DECIMAL(12,4),	-- Tasa a aplicar (tasa bruta o tasa ISR).
	Par_Plazo				INT(11)			-- Plazo de la inversión en días.


) RETURNS decimal(18,2)
    DETERMINISTIC
BEGIN
	-- Declaracion de Varibles
	DECLARE Var_InteresCalc			DECIMAL(18,4);		-- Interés generado.
	DECLARE Var_Base				INT(11);			-- Número de días base para el cálculo.

	-- Declaracion de Constantes
	DECLARE EnteroCero				INT(11);
	DECLARE EnteroUno				INT(11);
	DECLARE EnteroCien				INT(11);
	DECLARE TipoRetencion			INT(11);
	DECLARE TipoInteres				INT(11);
	DECLARE TipoISRRecalculo		INT(11);
	DECLARE TipoISRExtranjero		INT(11);
	DECLARE TipoISRExtRecal			INT(11);
	DECLARE PeriodoReg				CHAR(1);
	DECLARE PeriodoIrreg			CHAR(1);

	-- Asignacion de constantes
	SET EnteroCero					:= 0;				-- Constante cero.
	SET EnteroUno					:= 1;				-- Constante uno.
	SET EnteroCien					:= 100;				-- Constante 100.
	SET TipoRetencion				:= 0;				-- Cálculo para el Interés a Retener.
	SET TipoInteres					:= 1;				-- Cálculo para el Interés Generado.
	SET TipoISRRecalculo			:= 2;				-- Cálculo para el Interés a Retener Restante por Cambio de tasa ISR. (Recálculo).
	SET TipoISRExtranjero			:= 3;				-- Cálculo para el Interés a Retener Residentes en el Ext.
	SET TipoISRExtRecal				:= 4;				-- Cálculo para el Interés a Retener Residentes en el Ext. Restante por Cambio de tasa ISR. (Recálculo).
	SET PeriodoReg					:= 'R';				-- Periodo Regular.
	SET PeriodoIrreg				:= 'I';				-- Periodo Irregular.

	SET Var_Base	:= EnteroCero;

	IF (Par_TipoCalculo IN (TipoInteres,TipoRetencion,TipoISRRecalculo)) THEN
		# CÁLCULO DE INTERÉS.
		IF (Par_TipoCalculo = TipoInteres) THEN
			/** PERIODO REGULAR
			 ** Fórmula:
			 ** Intereses = (Capital * Tasa) / (Base * 100)
			 */
			IF (Par_TipoPeriodo = PeriodoReg) THEN
				SET Par_Plazo := EnteroUno;
				SET Var_Base := (SELECT FNPARAMGENERALES('BaseIntRegular'));
			END IF;
			/** PERIODO IRREGULAR
			 ** Fórmula:
			 ** Intereses = (Capital * Tasa * Plazo) / (Base * 100)
			 */
			IF (Par_TipoPeriodo = PeriodoIrreg) THEN
				SET Var_Base := (SELECT FNPARAMGENERALES('BaseIntIrregular'));
			END IF;
		END IF;

		# CÁLCULO DE RETENCIÓN. Monto sin excentar las 5 UMA’s Anualizadas.
		IF (Par_TipoCalculo IN (TipoRetencion,TipoISRRecalculo)) THEN
			/** PERIODO REGULAR
			 ** Fórmula:
			 ** ISR = (Capital * TasaISR) / (Base * 100)
			 */
			IF (Par_TipoPeriodo = PeriodoReg) THEN
				/** ISR RESTANTE POR CAMBIO DE TASA, SE CONSERVA EL PERIODO
				 ** QUE LE LLEGA POR PARÁMETRO, SINO SE CALCULA POR UNO.
				 */
				SET Par_Plazo := IF(Par_TipoCalculo=TipoISRRecalculo,Par_Plazo,EnteroUno);
				SET Var_Base := (SELECT FNPARAMGENERALES('BaseISRRegular'));
			END IF;
			/** PERIODO IRREGULAR
			 ** Fórmula:
			 ** ISR = (Capital * TasaISR * Plazo) / (Base * 100)
			 */
			IF (Par_TipoPeriodo = PeriodoIrreg) THEN
				SET Var_Base := (SELECT FNPARAMGENERALES('BaseISRIrregular'));
			END IF;
			/** Para el Recálculo de ISR se toma como base el valor de 360. */
			IF (Par_TipoCalculo = TipoISRRecalculo) THEN
				SET Var_Base := (SELECT FNPARAMGENERALES('BaseISRRecal'));
			END IF;
		END IF;

		SET Var_Base := IFNULL(Var_Base,EnteroUno);
		SET Var_InteresCalc := ROUND((Par_MontoInv*Par_TasaAplicar*Par_Plazo)/(Var_Base*EnteroCien),2);
	END IF;

	# RETENCIÓN RESIDENTES EN EL EXTRANJERO
	IF (Par_TipoCalculo IN (TipoISRExtranjero)) THEN
		/** Fórmula:
		 ** ISR = (Interés Bruto * TasaISR)
		 */
		SET Var_InteresCalc := ROUND((Par_MontoInv*Par_TasaAplicar),2);
	END IF;

	# RETENCIÓN RESIDENTES EN EL EXTRANJERO
	IF (Par_TipoCalculo IN (TipoISRExtRecal)) THEN
		/** Fórmula:
		 ** ISR = (Interés Bruto * TasaISR * Plazo)
		 */
		SET Var_InteresCalc := ROUND((Par_MontoInv*Par_TasaAplicar*Par_Plazo),2);
	END IF;

	RETURN ROUND(IFNULL(Var_InteresCalc,EnteroCero),2);
END$$