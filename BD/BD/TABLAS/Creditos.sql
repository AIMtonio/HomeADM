-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- Creditos
DELIMITER ;
DROP TABLE IF EXISTS `Creditos`;DELIMITER $$

CREATE TABLE `Creditos` (
  `CreditoID` int(11) NOT NULL,
  `Cliente` int(11) NOT NULL,
  `Sucursal` int(11) NOT NULL,
  `FechaInicio` datetime NOT NULL,
  `FechaVencim` datetime NOT NULL,
  `ProductoCredito` int(11) NOT NULL,
  `FormulaInteres` int(11) NOT NULL,
  `TasaBase` int(11) DEFAULT NULL,
  `TasaFija` double DEFAULT NULL,
  `TasaPiso` double DEFAULT NULL,
  `TasaTecho` double DEFAULT NULL,
  `Monto` decimal(14,2) NOT NULL,
  `FactorMora` decimal(5,3) DEFAULT NULL,
  `Estatus` varchar(1) NOT NULL,
  PRIMARY KEY (`CreditoID`),
  KEY `CRECLIENTE` (`Cliente`) USING HASH
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para el Maestro  o Datos del Credito'$$