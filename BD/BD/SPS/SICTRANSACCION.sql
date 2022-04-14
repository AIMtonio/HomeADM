-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SICTRANSACCION
DELIMITER ;
DROP PROCEDURE IF EXISTS `SICTRANSACCION`;DELIMITER $$

CREATE PROCEDURE `SICTRANSACCION`(
    out Var_NumeroTransaccion   bigint
	)
TerminaStore: BEGIN

update TRANSACCIONES set
	NumeroTransaccion = NumeroTransaccion + 1;

set Var_NumeroTransaccion := (select NumeroTransaccion from TRANSACCIONES);

END TerminaStore$$