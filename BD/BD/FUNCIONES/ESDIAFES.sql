-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESDIAFES
DELIMITER ;
DROP FUNCTION IF EXISTS `ESDIAFES`;
DELIMITER $$

CREATE FUNCTION `ESDIAFES`(
	Par_Fecha			date
) RETURNS char(1) CHARSET latin1
	DETERMINISTIC
BEGIN
DECLARE	Var_FecSal		date;
DECLARE	Var_EsHabil		char(1);

call DIASFESTIVOSCAL(Par_Fecha,0,Var_FecSal,Var_EsHabil,1,	1,'','','',1,1);

RETURN Var_EsHabil;

END$$