-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCREDFONDAS
DELIMITER ;
DROP TABLE IF EXISTS `TMPCREDFONDAS`;DELIMITER $$

CREATE TABLE `TMPCREDFONDAS` (
  `ConsecutivoID` bigint(20) NOT NULL AUTO_INCREMENT,
  `FormaSeleccion` char(1) DEFAULT NULL,
  `CreditoID` bigint(12) DEFAULT NULL,
  `NombreCliente` varchar(200) DEFAULT NULL,
  `FechaInicio` date DEFAULT NULL,
  `FechaVencim` date DEFAULT NULL,
  `MontoCredito` decimal(12,2) DEFAULT NULL,
  `SaldoCapital` decimal(12,2) DEFAULT NULL,
  `TipoPersona` varchar(15) DEFAULT NULL,
  `ProductoCredito` varchar(100) DEFAULT NULL,
  `DireccionCompleta` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`ConsecutivoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TABLA TEMPORAL DE LA ASIGNACION DE LOS CREDITOS DOS '$$