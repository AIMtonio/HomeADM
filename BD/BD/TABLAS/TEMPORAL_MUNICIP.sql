-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TEMPORAL_MUNICIP
DELIMITER ;
DROP TABLE IF EXISTS `TEMPORAL_MUNICIP`;DELIMITER $$

CREATE TABLE `TEMPORAL_MUNICIP` (
  `EstadoID` int(11) NOT NULL,
  `MunicipioID` int(11) NOT NULL,
  `NombreCorrecto` varchar(150) DEFAULT NULL,
  `Nombre` varchar(150) DEFAULT NULL,
  KEY `EstadoID` (`EstadoID`,`MunicipioID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$