-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ClienteGet
DELIMITER ;
DROP PROCEDURE IF EXISTS `ClienteGet`;DELIMITER $$

CREATE PROCEDURE `ClienteGet`(NumCliente INTEGER	)
BEGIN
	Select `ClienteID`,`NombreCli`,`ApellidopCli`, `ApellidomCli`
	from clientes where ClienteID = NumCliente;

END$$