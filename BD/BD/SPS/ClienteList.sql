-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ClienteList
DELIMITER ;
DROP PROCEDURE IF EXISTS `ClienteList`;DELIMITER $$

CREATE PROCEDURE `ClienteList`(NombreCliente VARCHAR(50)	)
BEGIN

	select `ClienteID`,`NombreCompleto`
	from clientes
	where `NombreCompleto` like concat("%", NombreCliente, "%");
END$$