-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNMONTOGARANLIQUCUENTA
DELIMITER ;
DROP FUNCTION IF EXISTS `FNMONTOGARANLIQUCUENTA`;DELIMITER $$

CREATE FUNCTION `FNMONTOGARANLIQUCUENTA`(
        Par_CreditoID BIGINT(12)
) RETURNS bigint(12)
    DETERMINISTIC
BEGIN

  DECLARE Var_CuentaAho BIGINT(12);
  DECLARE Var_Monto DECIMAL(13,2);


  SELECT SUM(Blo.MontoBloq),MAX(CuentaAhoID)  INTO Var_Monto,Var_CuentaAho
                      FROM BLOQUEOS Blo,
                      CREDITOS Cre
                      WHERE
                    Cre.CreditoID = Blo.Referencia
                    AND Blo.NatMovimiento = 'B'
                    AND Blo.TiposBloqID = 8
                    AND IFNULL(Blo.FolioBloq, 0.0) = 0.0
                    AND Cre.CreditoID = Par_CreditoID;


    RETURN Var_CuentaAho;
END$$