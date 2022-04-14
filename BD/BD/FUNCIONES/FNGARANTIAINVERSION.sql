-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNGARANTIAINVERSION
DELIMITER ;
DROP FUNCTION IF EXISTS `FNGARANTIAINVERSION`;DELIMITER $$

CREATE FUNCTION `FNGARANTIAINVERSION`(
    Par_CreditoID   BIGINT(12),
    Par_Fecha       DATE
) RETURNS decimal(12,2)
    DETERMINISTIC
BEGIN
    DECLARE Decimal_Cero    DECIMAL(12,2);
    DECLARE Var_FechaPago   DATE;
    DECLARE Var_Monto       DECIMAL(13,2);

    SET Decimal_Cero    =   0.0;
    SET Var_Monto       =   0.0;

    SELECT IFNULL(SUM(CREDITOINVGAR.MontoEnGar),Decimal_Cero) INTO Var_Monto
        FROM    CREDITOINVGAR,
                INVERSIONES,
                CREDITOS
        WHERE   CREDITOINVGAR.InversionID   = INVERSIONES.InversionID
         AND    CREDITOS.CreditoID          = CREDITOINVGAR.CreditoID
         AND    CREDITOS.CreditoID          = Par_CreditoID;

    RETURN Var_Monto;
END$$