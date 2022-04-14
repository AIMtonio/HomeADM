-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FECHAANUM
DELIMITER ;
DROP FUNCTION IF EXISTS `FECHAANUM`;
DELIMITER $$

CREATE FUNCTION `FECHAANUM`(
	Par_Fecha date
) RETURNS int(11)
	DETERMINISTIC
BEGIN

   DECLARE fecha int;
   set fecha = DATEDIFF (Par_Fecha,'1900-01-01') ;
   return  (fecha + 2 );

END$$