-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNGARANTIAINVERSIONID
DELIMITER ;
DROP FUNCTION IF EXISTS `FNGARANTIAINVERSIONID`;
DELIMITER $$

CREATE FUNCTION `FNGARANTIAINVERSIONID`(
	Par_CreditoID INT,
	Par_Fecha DATE
) RETURNS int(11)
	DETERMINISTIC
BEGIN
  DECLARE Var_InversionID int;

  select max(INVERSIONES.InversionID) into Var_InversionID
  from CREDITOINVGAR, INVERSIONES, CREDITOS
	where CREDITOINVGAR.InversionID=INVERSIONES.InversionID
	and CREDITOS.CreditoID=CREDITOINVGAR.CreditoID
	and CREDITOS.CreditoID=Par_CreditoID;


  RETURN Var_InversionID;
  END$$