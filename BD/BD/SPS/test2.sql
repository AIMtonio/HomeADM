-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- test2
DELIMITER ;
DROP PROCEDURE IF EXISTS `test2`;DELIMITER $$

CREATE PROCEDURE `test2`(	)
TerminaStore: BEGIN
DECLARE Eti varchar(50);
start transaction;
select Etiqueta from CUENTASAHO where CuentaAhoID > 0
        for update;
update CUENTASAHO
        set Etiqueta := "Etiqueta1"
        where CuentaAhoID  > 0;
commit;
END TerminaStore$$