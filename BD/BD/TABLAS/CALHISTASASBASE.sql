-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALHISTASASBASE
DELIMITER ;
DROP TABLE IF EXISTS `CALHISTASASBASE`;
DELIMITER $$


CREATE TABLE `CALHISTASASBASE` (
  `TasaBaseID` int(2) NOT NULL DEFAULT '0' COMMENT 'Tasa Base ID',
  `Fecha` date NOT NULL DEFAULT '1900-01-01' COMMENT 'Fecha de la Tasa Base',
  `Valor` decimal(12,4) DEFAULT NULL COMMENT 'Valor de la Tasa Base',
  PRIMARY KEY (`TasaBaseID`,`Fecha`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Contiene las Tasas Base de todos los dias'$$