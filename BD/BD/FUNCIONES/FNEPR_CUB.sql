-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNEPR_CUB
DELIMITER ;
DROP FUNCTION IF EXISTS `FNEPR_CUB`;
DELIMITER $$

CREATE FUNCTION `FNEPR_CUB`(
	Par_CreditoID INT,
	Par_Fecha date
) RETURNS decimal(13,2)
	DETERMINISTIC
BEGIN
  DECLARE Var_Fecha date;
  DECLARE Var_Monto DECIMAL(13,2);

  Select ReservaTotCubierto into Var_Monto
  from CALRESCREDITOS where CreditoID=Par_CreditoID
  and Fecha=Par_Fecha;

  RETURN Var_Monto;
END$$