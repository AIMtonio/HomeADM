-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBTMPMOVSATM
DELIMITER ;
DROP TABLE IF EXISTS `TARDEBTMPMOVSATM`;DELIMITER $$

CREATE TABLE `TARDEBTMPMOVSATM` (
  `ConciliaID` int(11) NOT NULL,
  `DetalleID` int(11) NOT NULL,
  `NumCuenta` varchar(19) DEFAULT NULL,
  `Fecha` date DEFAULT NULL,
  `Hora` varchar(9) DEFAULT NULL,
  `MontoTransaccion` decimal(12,2) DEFAULT NULL,
  `ComisionTrsansaccion` decimal(12,2) DEFAULT NULL,
  `NumAutorizacion` varchar(10) DEFAULT NULL,
  `Secuencia` char(6) DEFAULT NULL,
  `EstatusConci` char(1) DEFAULT NULL,
  PRIMARY KEY (`ConciliaID`,`DetalleID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$