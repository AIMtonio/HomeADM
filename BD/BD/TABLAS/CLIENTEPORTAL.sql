-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTEPORTAL
DELIMITER ;
DROP TABLE IF EXISTS `CLIENTEPORTAL`;DELIMITER $$

CREATE TABLE `CLIENTEPORTAL` (
  `CtePortalID` varchar(45) NOT NULL COMMENT 'id del cliente en el portal',
  `ClienteID` int(11) NOT NULL COMMENT 'Id del cliente en la tabla CLIENTES del core\n'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla CLIENTEPORTAL vinculo entre el cliente del portal y el'$$