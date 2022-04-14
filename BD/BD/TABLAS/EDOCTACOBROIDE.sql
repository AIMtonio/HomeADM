-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTACOBROIDE
DELIMITER ;
DROP TABLE IF EXISTS `EDOCTACOBROIDE`;DELIMITER $$

CREATE TABLE `EDOCTACOBROIDE` (
  `AnioMes` int(11) NOT NULL,
  `SucursalID` varchar(45) NOT NULL,
  `ClienteID` int(11) NOT NULL,
  `PeriodoID` int(11) NOT NULL,
  `Cantidad` decimal(14,2) DEFAULT NULL,
  `MontoIDE` decimal(14,2) DEFAULT NULL,
  `CantidadCob` decimal(14,2) DEFAULT NULL,
  `CantidadPen` decimal(14,2) DEFAULT NULL,
  PRIMARY KEY (`AnioMes`,`ClienteID`,`SucursalID`,`PeriodoID`),
  KEY `CLIPERIO` (`ClienteID`,`PeriodoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$