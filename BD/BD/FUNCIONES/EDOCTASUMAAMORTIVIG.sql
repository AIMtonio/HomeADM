-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTASUMAAMORTIVIG
DELIMITER ;
DROP FUNCTION IF EXISTS `EDOCTASUMAAMORTIVIG`;DELIMITER $$

CREATE FUNCTION `EDOCTASUMAAMORTIVIG`(
    Credito     BIGINT(12),
    FecFinMes   DATE,
    ValorIVAInt DECIMAL(14,2)

) RETURNS decimal(14,2)
    DETERMINISTIC
BEGIN

    DECLARE resultado DECIMAL(14,2);

    DECLARE Var_AmoExigible INT(11);

    SET ValorIVAInt := IFNULL(ValorIVAInt, 0.0) + 1;

    SET Var_AmoExigible := (SELECT MAX(AmortizacionID)
                                FROM AMORTICREDITO
                                WHERE CreditoID = Credito
                                  AND FechaExigible <= FecFinMes);

    SELECT IFNULL( (SaldoCapVigente +(SaldoInteresOrd * ValorIVAInt)), 0.0)
    INTO resultado
    FROM AMORTICREDITO
    WHERE CreditoID = Credito
      AND AmortizacionID = Var_AmoExigible
      AND Estatus IN('V');



      RETURN resultado;
END$$