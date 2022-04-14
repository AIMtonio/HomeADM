-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNULTDEPAHO
DELIMITER ;
DROP FUNCTION IF EXISTS `FNULTDEPAHO`;
DELIMITER $$

CREATE FUNCTION `FNULTDEPAHO`(
	Par_CuentaAhoID BIGINT(12),
	Par_Fecha DATE
) RETURNS date
	DETERMINISTIC
BEGIN

	DECLARE Var_Fecha date;
	DECLARE Var_Monto DECIMAL(13,2);

	Select Fecha into Var_Fecha from  `HIS-CUENAHOMOV` where CuentaAhoID=Par_CuentaAhoID
	and NatMovimiento='A'
	and TIpoMovAhoID in (10,102,14,16)
	and `HIS-CUENAHOMOV`.Fecha<=Par_Fecha
	order by Fecha desc limit 1;

	RETURN Var_Fecha;

END$$