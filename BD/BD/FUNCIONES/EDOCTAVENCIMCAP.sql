-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAVENCIMCAP
DELIMITER ;
DROP FUNCTION IF EXISTS `EDOCTAVENCIMCAP`;DELIMITER $$

CREATE FUNCTION `EDOCTAVENCIMCAP`(
    Credito       BIGINT(12),
    Amortizacion  INT(11),
    FecIniMes     DATE,
    FecExigible   DATE

) RETURNS decimal(14,2)
    DETERMINISTIC
BEGIN
    DECLARE resultado DECIMAL(14,2);

    SELECT SUM(Mov.Cantidad)
    INTO resultado
    FROM CREDITOSMOVS Mov
    WHERE Mov.CreditoID = Credito
      AND Mov.AmortiCreID = Amortizacion
      AND Mov.FechaOperacion >= FecIniMes
      AND Mov.FechaOperacion < FecExigible
      AND Mov.TipoMovCreID IN (1)
      AND Mov.NatMovimiento = 'A';

    RETURN resultado;

END$$