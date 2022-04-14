-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNULTIMOPAGOCAPITAL
DELIMITER ;
DROP FUNCTION IF EXISTS `FNULTIMOPAGOCAPITAL`;DELIMITER $$

CREATE FUNCTION `FNULTIMOPAGOCAPITAL`(
	# Funcion que devuelve el monto del ultimo pago de capital
	Par_CreditoID BIGINT(12),	-- Numero de Credito
	Par_Fecha DATE				-- Fecha
) RETURNS decimal(18,4)
    DETERMINISTIC
BEGIN

  DECLARE Var_FechaPago DATE;
  DECLARE Var_Monto DECIMAL(18,2);

  SELECT FechaPago,IFNULL(SUM(MontoCapOrd+MontoCapAtr+MontoCapVen),0.0)  INTO Var_FechaPago,Var_Monto FROM DETALLEPAGCRE WHERE CreditoID= Par_CreditoID AND FechaPago<=Par_Fecha
  GROUP BY FechaPago HAVING SUM(MontoCapOrd+MontoCapAtr+MontoCapVen)>0.0
  ORDER BY FechaPago DESC LIMIT 1;

  IF IFNULL(Var_Monto,0.0)=0.0 THEN
  BEGIN
    SELECT Capital INTO Var_Monto
    FROM AMORTICREDITO WHERE CreditoID=Par_CreditoID AND Estatus='P'
    ORDER BY AmortizacionID DESC LIMIT 1;
  END;
  END IF;

  RETURN Var_Monto;
END$$