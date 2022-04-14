-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FUNCIONIMPORTEPAGO
DELIMITER ;
DROP FUNCTION IF EXISTS `FUNCIONIMPORTEPAGO`;

DELIMITER $$
CREATE FUNCTION `FUNCIONIMPORTEPAGO`(
	-- Funcion para presentar el adeudo de un credito en Buro de Credito
	Par_CreditoID	BIGINT(12),		-- Numero de Credito
	Par_Fecha		DATE			-- Fecha de Reporte

) RETURNS DECIMAL(14,2)
	DETERMINISTIC
BEGIN

	-- Declaracion de Variables
	DECLARE Var_MontoExigible		DECIMAL(14,2);	-- Variable Monto Exigible
	DECLARE Var_IVA					DECIMAL(12,2);	-- Variable IVA
	DECLARE Var_PorcentajeIVA		DECIMAL(12,2);	-- Variable Porcentaje de IVA
	DECLARE Var_FechaSiguienteCuota	DATE;			-- Variable Fecha Siguiente Cuota
	DECLARE Var_CreEstatus			CHAR(1);		-- Variable Estatus del Credito

	DECLARE Var_CliPagIVA			CHAR(1);		-- Variable si el Cliente paga IVA
	DECLARE Var_ProCobIVA			CHAR(1);		-- Variable si el Producto Cobra IVA
	DECLARE Var_SiguienteCuota		DECIMAL(12,2);	-- Variable para la siguiente Cuota
	DECLARE Var_ExigibleActual		DECIMAL(12,2);	-- Variable Exigible Actual
	DECLARE Var_FechaSistema		DATE;			-- Variable Fecha del Sistema

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia			CHAR(1);		-- Constante Cadena Vacia
	DECLARE Fecha_Vacia				DATE;			-- Constante Fecha Vacia
	DECLARE Entero_Cero				INT(11);		-- Constante Entero Cero
	DECLARE Decimal_Cero			DECIMAL(14,2);	-- Constante Decimal Cero
	DECLARE EstatusPagado			CHAR(1);		-- Constante Estatus Pagado
	DECLARE SiPagaIVA				CHAR(1);		-- Constante Si paga IVA

	DECLARE CreditoVencido			CHAR(1);		-- Constante Estatus Vencido

	-- Asignacion de Constantes
	SET Cadena_Vacia				:= '';
	SET Fecha_Vacia					:= '1900-01-01';
	SET Entero_Cero					:= 0;
	SET Decimal_Cero				:= 0.00;
	SET EstatusPagado				:= 'P';

	SET SiPagaIVA					:= 'S';
	SET CreditoVencido				:= 'B';
	SET Var_MontoExigible			:= Decimal_Cero;
	SET Var_IVA						:= Decimal_Cero;
	SET Var_PorcentajeIVA			:= Decimal_Cero;

	SET Var_FechaSiguienteCuota		:= Par_Fecha;

	SELECT FechaSistema
	INTO Var_FechaSistema
	FROM PARAMETROSSIS
	LIMIT 1;

	SET Var_CreEstatus := ( SELECT EstatusCredito
							FROM SALDOSCREDITOS
							WHERE FechaCorte = CASE WHEN Par_Fecha = Var_FechaSistema THEN DATE_SUB(Par_Fecha, INTERVAL 1 DAY)
													ELSE Par_Fecha END
							  AND CreditoID = Par_CreditoID LIMIT 1);


	SET Var_CreEstatus := IFNULL(Var_CreEstatus, Cadena_Vacia);

	IF( Var_CreEstatus != CreditoVencido ) THEN
		-- Obtenemos la Fecha del vencimiento posterior a la Fecha de Corte
		SET Var_FechaSiguienteCuota := (SELECT min(FechaExigible)
										FROM AMORTICREDITO
										WHERE FechaExigible >= Par_Fecha
										  AND (Estatus <> EstatusPagado OR (Estatus = EstatusPagado AND FechaLiquida > Par_Fecha))
										  AND CreditoID =  Par_CreditoID);

		SET Var_FechaSiguienteCuota = IFNULL(Var_FechaSiguienteCuota, Fecha_Vacia);


		IF( Var_FechaSiguienteCuota != Fecha_Vacia ) THEN
			-- Obtenemos el importe de la siguiente cuota, posterior a la fecha de corte
			SET Var_SiguienteCuota :=  (SELECT  (Capital)
										FROM AMORTICREDITO
										WHERE FechaExigible = Var_FechaSiguienteCuota
										  AND CreditoID = Par_CreditoID
										LIMIT 1);
		END IF;

		SET Var_SiguienteCuota := IFNULL(Var_SiguienteCuota, Decimal_Cero);

		SET Var_ExigibleActual := ( SELECT SUM(Capital+Interes)
									FROM AMORTICREDITO
									WHERE FechaExigible < COALESCE(Var_FechaSiguienteCuota,Par_Fecha)
									  AND COALESCE(FechaLiquida,Par_Fecha) > Par_Fecha
									  AND CreditoID = Par_CreditoID
									GROUP BY CreditoID );

		SET Var_ExigibleActual := IFNULL(Var_ExigibleActual, Decimal_Cero);

		SET Var_MontoExigible := Var_ExigibleActual + Var_SiguienteCuota;

	ELSE
		 -- si el credito esta vencido, el importe de pago es todo lo vencido y provisionado
		SET Var_MontoExigible:=(SELECT SUM(SalCapAtrasado+SalCapVencido+SalIntOrdinario+SalIntAtrasado+SalIntVencido+SalIntProvision+SalIntNoConta) AS Monto
								FROM SALDOSCREDITOS
								WHERE FechaCorte = CASE WHEN Par_Fecha = Var_FechaSistema THEN DATE_SUB(Par_Fecha, INTERVAL 1 DAY)
														ELSE Par_Fecha END
								  AND CreditoID = Par_CreditoID);
	END IF;

	SET Var_MontoExigible := CEIL(Var_MontoExigible);

	return Var_MontoExigible;

END$$