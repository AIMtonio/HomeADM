-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPRENDIAPORTISR
DELIMITER ;
DROP TABLE IF EXISTS `TMPRENDIAPORTISR`;DELIMITER $$

CREATE TABLE `TMPRENDIAPORTISR` (
  `AportacionID` int(11) NOT NULL DEFAULT '0' COMMENT 'Identificador de la Aportación.',
  `ClienteID` int(11) NOT NULL DEFAULT '0' COMMENT 'Cliente',
  `ISRCal` decimal(18,2) DEFAULT NULL COMMENT 'ISR Calculado',
  PRIMARY KEY (`AportacionID`,`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Guarda el ISR calculado en Aportaciones.'$$