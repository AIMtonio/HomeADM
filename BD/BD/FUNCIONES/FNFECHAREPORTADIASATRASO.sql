-- FNFECHAREPORTADIASATRASO
DELIMITER ;
DROP FUNCTION IF EXISTS `FNFECHAREPORTADIASATRASO`;

DELIMITER $$
CREATE FUNCTION `FNFECHAREPORTADIASATRASO`(
	-- Funcion para calcular la Fecha de Reporte de los días de Atraso un credito reestructurado o renovado
	Par_CreditoID		BIGINT(12),	-- Numero de Credito
	Par_Fecha			DATE 		-- Fecha de Inicio
) RETURNS date
    DETERMINISTIC
BEGIN

	-- Declaracion de Variables
	DECLARE Var_NumeroAmortizaciones INT(11);	-- Numero de Amortizaciones
	DECLARE Var_NumeroDias			INT(11);	-- Numero de Dias de la Primer Amortizacion
	DECLARE Var_PeriodicidadCap		INT(11);	-- Periodicidad Capital
	DECLARE Var_MinAmortizacionID	INT(11);	-- Numero Minimo de Amortizaciones
	DECLARE Var_MaxAmortizacionID	INT(11);	-- Numero Maximo de Amortizaciones

	DECLARE Var_FechaExigibilidad	DATE;		-- Fecha de Exigibilidad
	DECLARE Var_FechaSistema		DATE;		-- Fecha del Sistema
	DECLARE Var_Frecuencia			CHAR(1);	-- Frecuencia Capital

	-- Declaracion de Constantes
	DECLARE Entero_Cero				INT(11);	-- Constante Entero Cero
	DECLARE Entero_Uno				INT(11);	-- Constante Entero Uno
	DECLARE Con_60Dias				INT(11);	-- Constante Sesenta Dias
	DECLARE Fecha_Vacia				DATE;		-- Constante Fecha Vacia
	DECLARE Fre_Semanal				CHAR(1);	-- Frecuencia Semanal

	DECLARE Fre_Decenal				CHAR(1);	-- Frecuencia Decenal
	DECLARE Fre_Catorcenal			CHAR(1);	-- Frecuencia Catorcenal
	DECLARE Fre_Quincenal			CHAR(1);	-- Frecuencia Quincenal
	DECLARE Fre_Mensual				CHAR(1);	-- Frecuencia Mensual
	DECLARE Fre_Bimiestral			CHAR(1);	-- Frecuencia Bimestral

	DECLARE Fre_Trimestral			CHAR(1);	-- Frecuencia Trimestral
	DECLARE Fre_Tetramestral		CHAR(1);	-- Frecuencia Tetramestral
	DECLARE Fre_Semestral			CHAR(1);	-- Frecuencia Semestral
	DECLARE Fre_Anual				CHAR(1);	-- Frecuencia Anual
	DECLARE Fre_Periodo				CHAR(1);	-- Frecuencia Periodo

	DECLARE Fre_PagoUnico			CHAR(1);	-- Frecuencia Pago Unico
	DECLARE Fre_Libre				CHAR(1);	-- Frecuencia Libre
	DECLARE Fre_PagoUnicoIntPeriodo CHAR(1);	-- Frecuencia Pago Unico Interes Periodico
	DECLARE Estatus_Pagado			CHAR(1);	-- Estatus Pagado

	-- Asignacion de Constantes
	SET Entero_Cero				:= 0;
	SET Entero_Uno				:= 1;
	SET Con_60Dias				:= 60;
	SET Fecha_Vacia				:= '1900-01-01';
	SET Fre_Semanal				:= 'S';

	SET Fre_Decenal				:= 'D';
	SET Fre_Catorcenal			:= 'C';
	SET Fre_Quincenal			:= 'Q';
	SET Fre_Mensual				:= 'M';
	SET Fre_Bimiestral			:= 'B';

	SET Fre_Trimestral			:= 'T';
	SET Fre_Tetramestral		:= 'R';
	SET Fre_Semestral			:= 'E';
	SET Fre_Anual				:= 'A';
	SET Fre_Periodo				:= 'P';

	SET Fre_PagoUnico			:= 'U';
	SET Fre_Libre				:= 'L';
	SET Fre_PagoUnicoIntPeriodo	:= 'I';
	SET Estatus_Pagado			:= 'P';

	SELECT FechaSistema
	INTO Var_FechaSistema
	FROM PARAMETROSSIS
	LIMIT 1;

	SET Par_CreditoID	:= IFNULL(Par_CreditoID, Entero_Cero);
	SET Par_Fecha 		:= IFNULL(Par_Fecha, Var_FechaSistema);

	SELECT FrecuenciaCap,	PeriodicidadCap
	INTO Var_Frecuencia,	Var_PeriodicidadCap
	FROM CREDITOS
	WHERE CreditoID = Par_CreditoID;

	SELECT	IFNULL(COUNT(*), Entero_Cero),	IFNULL(MIN(AmortizacionID), Entero_Cero),	IFNULL(MAX(AmortizacionID), Entero_Cero)
	INTO	Var_NumeroAmortizaciones,		Var_MinAmortizacionID,						Var_MaxAmortizacionID
	FROM AMORTICREDITO
	WHERE CreditoID = Par_CreditoID
	  AND Estatus <> Estatus_Pagado;

	SELECT IFNULL(DATEDIFF(FechaVencim, FechaInicio), Entero_Cero)
	INTO Var_NumeroDias
	FROM AMORTICREDITO
	WHERE CreditoID = Par_CreditoID
	  AND Estatus <> Estatus_Pagado
	LIMIT 1;

	-- Si la Frecuencias es Semanal, Decenal, Catorcenal, Quincenal o Mensual obtengo la fecha de exigibilidad de la tercera amortizacion
	-- si no existe la tercer amortizacion obtengo la maxima fecha exigible del credito
	IF( Var_Frecuencia IN (Fre_Semanal, Fre_Decenal, Fre_Catorcenal, Fre_Quincenal, Fre_Mensual) ) THEN
		SET Var_FechaExigibilidad   := (SELECT IFNULL(MIN(FechaExigible), Fecha_Vacia)
										FROM AMORTICREDITO
										WHERE CreditoID = Par_CreditoID
										  AND AmortizacionID = CASE WHEN Var_NumeroAmortizaciones >= 3 THEN (Var_MinAmortizacionID+2)
																	ELSE Var_MaxAmortizacionID
															   END
										  AND Estatus <> Estatus_Pagado);
	END IF;

	-- Si la Frecuencias es Bimiestral, Trimestral, Tetramestral, Semestral o Anual obtengo la fecha de exigibilidad de la primer amortización
	IF( Var_Frecuencia IN (Fre_Bimiestral, Fre_Trimestral, Fre_Tetramestral, Fre_Semestral, Fre_Anual) ) THEN
		SET Var_FechaExigibilidad   := (SELECT IFNULL(FechaExigible, Fecha_Vacia)
										FROM AMORTICREDITO
										WHERE CreditoID = Par_CreditoID
										  AND FechaInicio >= Par_Fecha
										  AND Estatus <> Estatus_Pagado
										LIMIT 1);
	END IF;

	-- Si la Frecuencias es Pago Unico o Pago Unico obtengo la a fecha de exigibilidad de la primer amortización
	IF( Var_Frecuencia IN (Fre_PagoUnico, Fre_PagoUnicoIntPeriodo) ) THEN
		SET Var_FechaExigibilidad   := DATE_ADD(Par_Fecha, INTERVAL 90 DAY);
	END IF;

	-- Si la Frecuencia es Periodica
	-- Si la periodicidad es de menor a 60 Dias y Tiene mas de una amortizacion obtengo la fecha de exigibilidad de la tercera amortizacion
		-- si no existe la tercer amortizacion obtengo la maxima fecha exigible del credito
	-- Si la periodicidad es de mayor a 60 Dias y Tiene mas de una amortizacion Obtengo la fecha de exigibilidad de la primer amortización
	-- Si Tiene una amortizacion Obtengo la fecha de exigibilidad de la primer amortización
	IF( Var_Frecuencia = Fre_Periodo ) THEN
		IF( Var_PeriodicidadCap < Con_60Dias AND Var_NumeroAmortizaciones > Entero_Uno ) THEN
			SET Var_FechaExigibilidad   := (SELECT IFNULL(MIN(FechaExigible), Fecha_Vacia)
											FROM AMORTICREDITO
											WHERE CreditoID = Par_CreditoID
											  AND AmortizacionID = CASE WHEN Var_NumeroAmortizaciones >= 3 THEN (Var_MinAmortizacionID+2)
																		ELSE Var_MaxAmortizacionID
																   END
											  AND Estatus <> Estatus_Pagado);
		END IF;

		IF( (Var_PeriodicidadCap >= Con_60Dias AND Var_NumeroAmortizaciones > Entero_Uno) OR Var_NumeroAmortizaciones = Entero_Uno ) THEN
			SET Var_FechaExigibilidad   := (SELECT IFNULL(FechaExigible, Fecha_Vacia)
											FROM AMORTICREDITO
											WHERE CreditoID = Par_CreditoID
											  AND FechaInicio >= Par_Fecha
											  AND Estatus <> Estatus_Pagado
											LIMIT 1);
		END IF;
	END IF;

	-- Si la Frecuencia es Libre
	-- Si el numero de Dias es de menor a 60 Dias y Tiene mas de una amortizacion obtengo la fecha de exigibilidad de la tercera amortizacion
		-- si no existe la tercer amortizacion obtengo la maxima fecha exigible del credito
	-- Si la numero de Dias es de mayor a 60 Dias y Tiene mas de una amortizacion Obtengo la fecha de exigibilidad de la primer amortización
	-- Si Tiene una amortizacion Obtengo la fecha de exigibilidad de la primer amortización

	-- Si la periodicidad de la primer Amortizacion es de menor a 60 Dias y Tiene mas de una amortizacion los pagos sostenidos seran 3
	-- Si la periodicidad de la primer Amortizacion es de mayor a 60 Dias y Tiene mas de una amortizacion los pagos sostenidos seran 1
	-- Si Tiene una amortizacion los pagos sostenidos seran 1
	IF( Var_Frecuencia = Fre_Libre ) THEN
		IF( Var_NumeroDias < Con_60Dias AND Var_NumeroAmortizaciones > Entero_Uno ) THEN
			SET Var_FechaExigibilidad   := (SELECT IFNULL(MIN(FechaExigible), Fecha_Vacia)
											FROM AMORTICREDITO
											WHERE CreditoID = Par_CreditoID
											  AND AmortizacionID = CASE WHEN Var_NumeroAmortizaciones >= 3 THEN (Var_MinAmortizacionID+2)
																		ELSE Var_MaxAmortizacionID
																   END
											  AND Estatus <> Estatus_Pagado);
		END IF;

		IF( (Var_NumeroDias >= Con_60Dias AND Var_NumeroAmortizaciones > Entero_Uno) OR Var_NumeroAmortizaciones = Entero_Uno ) THEN
			SET Var_FechaExigibilidad   := (SELECT IFNULL(FechaExigible, Fecha_Vacia)
											FROM AMORTICREDITO
											WHERE CreditoID = Par_CreditoID
											  AND FechaInicio >= Par_Fecha
											  AND Estatus <> Estatus_Pagado
											LIMIT 1);
		END IF;
	END IF;

	SET Var_FechaExigibilidad := IFNULL(Var_FechaExigibilidad, Fecha_Vacia);
	RETURN Var_FechaExigibilidad;

END$$