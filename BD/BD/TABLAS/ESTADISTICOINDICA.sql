-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESTADISTICOINDICA
DELIMITER ;
DROP TABLE IF EXISTS `ESTADISTICOINDICA`;DELIMITER $$

CREATE TABLE `ESTADISTICOINDICA` (
  `EstadisIndID` int(11) NOT NULL DEFAULT '0' COMMENT 'Consecutivo de la tabla',
  `ConEstadisIndID` int(11) DEFAULT NULL COMMENT 'Llave foranea, corresponde con la tabla CONCEPESTAINDICA',
  `Mes` int(11) DEFAULT NULL COMMENT 'Mes para el que se genera el estadistico',
  `Anio` int(11) DEFAULT NULL COMMENT 'Año para el que se genera el estadistico',
  `Indicador` decimal(18,4) DEFAULT NULL COMMENT 'Indicador',
  PRIMARY KEY (`EstadisIndID`),
  KEY `ConEstadisIndID_1` (`ConEstadisIndID`),
  CONSTRAINT `ConEstadisIndID_1` FOREIGN KEY (`ConEstadisIndID`) REFERENCES `CONCEPESTAINDICA` (`ConEstadisIndID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena los estadisticos para Indicadores'$$