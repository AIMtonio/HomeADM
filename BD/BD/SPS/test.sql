-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- test
DELIMITER ;
DROP PROCEDURE IF EXISTS `test`;DELIMITER $$

CREATE PROCEDURE `test`(	)
TerminaStore: BEGIN

DECLARE folio bigint;
call FOLIOSAPLICAACT('POLIZACONTABLE',folio);
select folio;

END TerminaStore$$