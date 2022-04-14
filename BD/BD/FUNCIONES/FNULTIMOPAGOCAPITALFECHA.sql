-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNULTIMOPAGOCAPITALFECHA
DELIMITER ;
DROP FUNCTION IF EXISTS `FNULTIMOPAGOCAPITALFECHA`;DELIMITER $$

CREATE FUNCTION `FNULTIMOPAGOCAPITALFECHA`(
# SP QUE DEVUELVE LA FECHA DEL ULTIMO PAGO DE CAPITAL
		Par_CreditoID BIGINT(12),	-- Numero de Credito
		Par_Fecha DATE				-- Fecha
) RETURNS date
    DETERMINISTIC
BEGIN

  DECLARE Var_FechaPago DATE;
  DECLARE Var_Monto DECIMAL(13,2);

  SELECT FechaPago,IFNULL(SUM(MontoCapOrd+MontoCapAtr+MontoCapVen),0.0)  INTO Var_FechaPago,Var_Monto FROM DETALLEPAGCRE WHERE CreditoID= Par_CreditoID AND FechaPago<=Par_Fecha
  GROUP BY FechaPago HAVING SUM(MontoCapOrd+MontoCapAtr+MontoCapVen)>0.0
  ORDER BY FechaPago DESC LIMIT 1;

  IF IFNULL(Var_FechaPago,0.0)=0.0 THEN
	  BEGIN
		SELECT FechaExigible INTO Var_FechaPago
		FROM AMORTICREDITO WHERE CreditoID=Par_CreditoID AND Estatus='P'
		ORDER BY AmortizacionID DESC LIMIT 1;
	  END;
  END IF;

  RETURN Var_FechaPago;
END$$