-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPACTUALIZAFACTOR
DELIMITER ;
DROP TABLE IF EXISTS `TMPACTUALIZAFACTOR`;DELIMITER $$

CREATE TABLE `TMPACTUALIZAFACTOR` (
  `ClienteID` int(11) NOT NULL COMMENT 'Id Cliente',
  `InteresesGen` decimal(18,2) NOT NULL COMMENT 'Suma InteresG enerado',
  PRIMARY KEY (`ClienteID`),
  KEY `INDEX_ClienteID` (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Auxiliar para el Calculo del Factor Total de Productos de Captación'$$