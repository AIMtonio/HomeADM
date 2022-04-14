-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALCULARSALDOINSOLUTO
DELIMITER ;
DROP FUNCTION IF EXISTS `CALCULARSALDOINSOLUTO`;DELIMITER $$

CREATE FUNCTION `CALCULARSALDOINSOLUTO`(
    Par_Credito         BIGINT(12),
    Par_Amortizacion    INT(11)

) RETURNS decimal(18,4)
    DETERMINISTIC
BEGIN

    DECLARE Var_CapitalInsoluto     DECIMAL(18,4);

    SELECT SUM(Amo.SaldoCapVigente + Amo.SaldoCapAtrasa + Amo.SaldoCapVencido + Amo.SaldoCapVenNExi) CapInsol
    INTO Var_CapitalInsoluto
    FROM AMORTICREDITO Amo
    WHERE Amo.CreditoID = Par_Credito
    AND Amo.AmortizacionID >= Par_Amortizacion
    AND Amo.Estatus IN ('V', 'A', 'B', 'K')
    GROUP BY Amo.CreditoID;

    SET Var_CapitalInsoluto = IFNULL(Var_CapitalInsoluto, 0.0);

    RETURN Var_CapitalInsoluto;
END$$