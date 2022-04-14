-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FUNCIONDEUCRECONTNOIVA
DELIMITER ;
DROP FUNCTION IF EXISTS `FUNCIONDEUCRECONTNOIVA`;DELIMITER $$

CREATE FUNCTION `FUNCIONDEUCRECONTNOIVA`(
    /* DEVUELVE EL MONTO TOTAL DE CREDITO CONTINGENTE SIN INCLUIR EL IVA*/
    Par_CreditoID   BIGINT


) RETURNS decimal(14,2)
    DETERMINISTIC
BEGIN

	-- Declaracion de variables
	DECLARE Var_MontoDeuda  DECIMAL(14,2);
	DECLARE Var_FecActual   DATE;
	DECLARE Var_CreEstatus  CHAR(1);

	-- Declaracion de constantes
	DECLARE Cadena_Vacia    CHAR(1);
	DECLARE Fecha_Vacia     DATE;
	DECLARE Entero_Cero     INT;
	DECLARE Decimal_Cero    DECIMAL(14,2);
	DECLARE EstatusPagado   CHAR(1);

	-- Asignacion de constantes
	SET Cadena_Vacia      := '';
	SET Fecha_Vacia       := '1900-01-01';
	SET Entero_Cero       := 0;
	SET Decimal_Cero      := 0.00;
	SET EstatusPagado     := 'P';

	SET Var_MontoDeuda    := Decimal_Cero;

	SELECT FechaSistema INTO Var_FecActual
	  FROM PARAMETROSSIS;

	SELECT  Cre.Estatus
		INTO Var_CreEstatus
		FROM CREDITOSCONT   Cre
		WHERE   Cre.CreditoID = Par_CreditoID;

	SET Var_CreEstatus := IFNULL(Var_CreEstatus, Cadena_Vacia);

	IF(Var_CreEstatus != Cadena_Vacia) THEN
		SELECT   ROUND( IFNULL(
						SUM(ROUND(SaldoCapVigente,2) + ROUND(SaldoCapAtrasa,2) +
							ROUND(SaldoCapVencido,2) + ROUND(SaldoCapVenNExi,2) +

							  ROUND(SaldoInteresOrd + SaldoInteresAtr +
									SaldoInteresVen + SaldoInteresPro + SaldoIntNoConta,2) +

							  ROUND(SaldoComFaltaPa,2) + ROUND(SaldoSeguroCuota,2) +
							  ROUND(SaldoOtrasComis,2) + ROUND(SaldoComisionAnual,2) +
							  ROUND(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen,2)),
						   Entero_Cero)
					, 2)
				INTO Var_MontoDeuda
				FROM AMORTICREDITOCONT
				WHERE CreditoID     =  Par_CreditoID
				  AND Estatus       <> EstatusPagado;
		SET Var_MontoDeuda = IFNULL(Var_MontoDeuda, Decimal_Cero);

	END IF;

RETURN Var_MontoDeuda;

END$$