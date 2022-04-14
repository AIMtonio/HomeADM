-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BUROCREDINTF
DELIMITER ;
DROP TABLE IF EXISTS `BUROCREDINTF`;DELIMITER $$

CREATE TABLE `BUROCREDINTF` (
  `CintaID` int(11) NOT NULL,
  `ClienteID` int(11) DEFAULT NULL,
  `Clave` varchar(10) DEFAULT NULL,
  `Fecha` date DEFAULT NULL,
  `Cinta` varchar(5000) DEFAULT NULL,
  KEY `Cliente_Buro` (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena la Cinta individual por Clave y Fecha de EnvÃ­o'$$