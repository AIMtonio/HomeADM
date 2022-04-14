-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNCOMISIONANUALCRED
DELIMITER ;
DROP FUNCTION IF EXISTS `FNCOMISIONANUALCRED`;DELIMITER $$

CREATE FUNCTION `FNCOMISIONANUALCRED`(
	/*Funcion para calcula el monto de comisión por anualidad*/
	Par_CreditoID			BIGINT(12),		# ID del Crédito
    Par_AmortizacionID		INT(11),		# Numero de Amortizacion
	Par_SaldoInsoluto		DECIMAL(14,2),	# Saldo Insoluto se pasa por parametro para evitar la sobrecarga del proceso
	Par_FechaSistema		DATE			# Fecha del sistema

) RETURNS decimal(14,2)
    DETERMINISTIC
BEGIN
	-- Declaracion de constantes
	DECLARE Entero_Cero					INT(11);			# Constante Entero Cero
	DECLARE Decimal_Cero				DECIMAL(14,2);		# Constante Decimal Cero
	DECLARE Cadena_Vacia				CHAR(1);			# Constante Cadena Vacia
	DECLARE Cons_SI						CHAR(1);			# Constante SI
	DECLARE Cons_NO						CHAR(1);			# Constante NO
	DECLARE Estatus_Pagada				CHAR(1);			# Estatus Pagada(AMORTICREDITO)
	DECLARE FrecuenciaMensual			CHAR(1);			# Frecuencia Mensual
	DECLARE FrecuenciaAnual				CHAR(1);			# Frecuencia Anual
	DECLARE PorPorcentaje				CHAR(1);			# Tipo de Comision por Porcentaje
	DECLARE PorMonto					CHAR(1);			# Tipo de Comision por Monto
	DECLARE BaseCalcMontoOriginal		CHAR(1);			# Base de Calculo Monto Original
	DECLARE BaseCalcSaldoInsoluto		CHAR(1);			# Base de Calculo Saldo Insoluto
	DECLARE AmortAnualxMes				INT(11);			# 12 Amortizaciones para Frecuencia Mensual
	DECLARE AmortizacionDoce			INT(11);			# AmortizacionID 12


	-- Declaracion de Variables
	DECLARE Var_Monto							DECIMAL(14,2);			# Monto a cobrar por comision anual
	DECLARE Var_MontoCredito					DECIMAL(12,2);			# Saldo comision anual
	DECLARE Var_SaldoComAnual					DECIMAL(14,2);			# Saldo comision anual
	DECLARE Var_FrecuenciaCap					CHAR(1);				# Frecuencia de capital del credito
	DECLARE Var_NumAmortizacion					INT(11);				# Numero de amortizaciones
	DECLARE Var_CobraComisionComAnual			VARCHAR(1);				# Cobra Comision S:Si N:No
	DECLARE Var_TipoComisionComAnual			VARCHAR(1);				# Tipo de Comision P:Porcentaje M:Monto
	DECLARE Var_BaseCalculoComAnual				VARCHAR(1);				# Base del Cálculo M:Monto del crédito Original S:Saldo Insoluto
	DECLARE Var_MontoComisionComAnual			DECIMAL(14,2);			# Monto de la Comision en caso de que el tipo de comision sea M
	DECLARE Var_PorcentajeComisionComAnual		DECIMAL(14,4);			# Porcentaje de la comision en caso de que el tipo de comision sea P
	DECLARE Var_DiasGraciaComAnual				INT(11);				# Dias de gracia que se dan antes de cobrar la comisión
	DECLARE Var_ContinualCalcComision			CHAR(1);				# Continua con el calculo de la comision de credito

	-- Asignacion de Constantes
	SET Entero_Cero						:= 0;
	SET Decimal_Cero					:= 0;
	SET Cadena_Vacia					:= '';
	SET Cons_SI							:= 'S';
	SET Cons_NO							:= 'N';
	SET Estatus_Pagada					:= 'P';
	SET FrecuenciaMensual				:= 'M';
	SET FrecuenciaAnual					:= 'A';
	SET PorPorcentaje					:= 'P';
	SET PorMonto						:= 'M';
	SET BaseCalcMontoOriginal			:= 'M';
	SET BaseCalcSaldoInsoluto			:= 'S';
	SET AmortAnualxMes					:= 12;
	SET AmortizacionDoce				:= 12;

	SELECT
		FrecuenciaCap,						NumAmortizacion,				MontoCredito,				SaldoComAnual,
		CobraComAnual,						TipoComAnual,					BaseCalculoComAnual,		MontoComAnual,
		PorcentajeComAnual,					DiasGraciaComAnual
		INTO
		Var_FrecuenciaCap,					Var_NumAmortizacion,			Var_MontoCredito,				Var_SaldoComAnual,
		Var_CobraComisionComAnual,			Var_TipoComisionComAnual,		Var_BaseCalculoComAnual,		Var_MontoComisionComAnual,
		Var_PorcentajeComisionComAnual,		Var_DiasGraciaComAnual
		FROM CREDITOS
			WHERE CreditoID = Par_CreditoID;

	SET Var_FrecuenciaCap				:= IFNULL(Var_FrecuenciaCap, Cadena_Vacia);
	SET Var_SaldoComAnual				:= IFNULL(Var_SaldoComAnual, Decimal_Cero);
	SET Var_NumAmortizacion				:= IFNULL(Var_NumAmortizacion, Entero_Cero);
	SET Var_CobraComisionComAnual		:= IFNULL(Var_CobraComisionComAnual, Cons_NO);
	SET Var_TipoComisionComAnual		:= IFNULL(Var_TipoComisionComAnual, Cadena_Vacia);
	SET Var_BaseCalculoComAnual			:= IFNULL(Var_BaseCalculoComAnual, Cadena_Vacia);
	SET Var_MontoComisionComAnual		:= IFNULL(Var_MontoComisionComAnual, Decimal_Cero);
	SET Var_PorcentajeComisionComAnual	:= IFNULL(Var_PorcentajeComisionComAnual, Decimal_Cero);
	SET Var_DiasGraciaComAnual			:= IFNULL(Var_DiasGraciaComAnual, Entero_Cero);
	SET Par_SaldoInsoluto				:= IFNULL(Par_SaldoInsoluto, Decimal_Cero);
	SET Var_ContinualCalcComision		:= Cons_NO;
	/*Cobra comision solo si:
	El Credito cobra comision y su frecuencia sea anual o mensual(pero que supere o iguale las 12 cuotas equivalentes a
	un año)*/

	IF(Var_CobraComisionComAnual = Cons_SI) THEN
		/*(Si la comision es mensual y sus amortizaciones son igual o mayor a 12)*/
		IF(Var_FrecuenciaCap = FrecuenciaMensual AND Var_NumAmortizacion >=AmortAnualxMes) THEN
			/*Sacamos a la amortizacion 12 mientras no este pagada*/
			IF EXISTS(SELECT AmortizacionID
				FROM AMORTICREDITO
					WHERE
						CreditoID = Par_CreditoID AND
						FechaInicio = Par_FechaSistema AND
						Estatus != Estatus_Pagada AND
						AmortizacionID >= AmortAnualxMes AND
						(AmortizacionID%AmortAnualxMes) = 0 AND /*Amortizaciones multiplos de 12*/
						SaldoComisionAnual = Decimal_Cero
						ORDER BY AmortizacionID ASC
						LIMIT 1) THEN
				SET Var_ContinualCalcComision := Cons_SI;
			END IF;
		END IF;

		/*Si la frecuencia es anual*/
		IF(Var_FrecuenciaCap = FrecuenciaAnual) THEN
			SET Var_ContinualCalcComision := Cons_SI;
		END IF;

		IF(Var_ContinualCalcComision = Cons_SI) THEN
			IF(Var_TipoComisionComAnual = PorPorcentaje) THEN
				IF(Var_BaseCalculoComAnual = BaseCalcMontoOriginal) THEN
					SET Var_Monto := (Var_MontoCredito * (Var_PorcentajeComisionComAnual/100));
				  ELSEIF(Var_BaseCalculoComAnual = BaseCalcSaldoInsoluto) THEN
					SET Var_Monto := (Var_MontoCredito * (Par_SaldoInsoluto/100));
				END IF;
			ELSEIF(Var_TipoComisionComAnual = PorMonto) THEN
				SET Var_Monto := Var_MontoComisionComAnual;
			END IF;



            /*UPDATE AMORTICREDITO SET
				SaldoComisionAnual = Var_Monto
				WHERE CreditoID= Par_CreditoID AND
					AmortizacionID = Par_AmortizacionID;
                    */
			SET Var_Monto := IFNULL(Var_Monto, Decimal_Cero) + Var_SaldoComAnual;

           /* UPDATE CREDITOS SET
				SaldoComAnual = Var_Monto
				WHERE CreditoID= Par_CreditoID;*/
		  ELSE
			SET Var_Monto := Decimal_Cero;
		END IF;
	  ELSE
		SET Var_Monto := Decimal_Cero;
	END IF;



	RETURN Var_Monto;
END$$