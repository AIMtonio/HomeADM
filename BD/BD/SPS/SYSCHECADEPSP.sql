-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SYSCHECADEPSP
DELIMITER ;
DROP PROCEDURE IF EXISTS `SYSCHECADEPSP`;



	SELECT * FROM SYSDEPENDENCIAS WHERE NombreProcedimiento LIKE SP;

END TerminaStore$$