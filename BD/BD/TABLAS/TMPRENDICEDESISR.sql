-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPRENDICEDESISR
DELIMITER ;
DROP TABLE IF EXISTS `TMPRENDICEDESISR`;DELIMITER $$

CREATE TABLE `TMPRENDICEDESISR` (
  `CedeID` int(11) NOT NULL DEFAULT '0' COMMENT 'Identificador de la Cede.',
  `ClienteID` int(11) NOT NULL DEFAULT '0' COMMENT 'Cliente',
  `ISRCal` decimal(18,2) DEFAULT NULL COMMENT 'ISR Calculado',
  PRIMARY KEY (`CedeID`,`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para guardar el ISR calculado'$$