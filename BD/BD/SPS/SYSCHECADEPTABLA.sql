-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SYSCHECADEPTABLA
DELIMITER ;
DROP PROCEDURE IF EXISTS `SYSCHECADEPTABLA`;DELIMITER $$

CREATE PROCEDURE `SYSCHECADEPTABLA`(Tabla varchar(30)	)
TerminaStore: BEGIN
	SELECT * FROM SYSDEPENDENCIAS WHERE NombreTabla LIKE Tabla;

END TerminaStore$$