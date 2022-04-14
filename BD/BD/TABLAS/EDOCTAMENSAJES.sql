-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAMENSAJES
DELIMITER ;
DROP TABLE IF EXISTS `EDOCTAMENSAJES`;DELIMITER $$

CREATE TABLE `EDOCTAMENSAJES` (
  `SucursalID` int(11) NOT NULL DEFAULT '0',
  `TipoPersona` char(1) NOT NULL DEFAULT '',
  `Mensaje1` varchar(500) DEFAULT NULL,
  `Mensaje2` varchar(500) DEFAULT NULL,
  `Mensaje3` varchar(500) DEFAULT NULL,
  `Mensaje4` varchar(500) DEFAULT NULL,
  `Mensaje5` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`TipoPersona`,`SucursalID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Mensajes Generales para los Estados de Cuenta'$$