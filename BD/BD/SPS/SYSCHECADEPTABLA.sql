-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SYSCHECADEPTABLA
DELIMITER ;
DROP PROCEDURE IF EXISTS `SYSCHECADEPTABLA`;



	SELECT * FROM SYSDEPENDENCIAS WHERE NombreTabla LIKE Tabla;

END TerminaStore$$