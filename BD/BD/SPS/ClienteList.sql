-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ClienteList
DELIMITER ;
DROP PROCEDURE IF EXISTS `ClienteList`;




	select `ClienteID`,`NombreCompleto`
	from clientes
	where `NombreCompleto` like concat("%", NombreCliente, "%");
END$$