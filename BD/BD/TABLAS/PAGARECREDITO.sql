-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGARECREDITO
DELIMITER ;
DROP TABLE IF EXISTS `PAGARECREDITO`;DELIMITER $$

CREATE TABLE `PAGARECREDITO` (
  `AmortizacionID` int(4) NOT NULL,
  `CreditoID` bigint(12) NOT NULL COMMENT 'Numero de Credito Corresponde con Creditos',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Numero de Cliente corresponde con CLIENTES',
  `CuentaID` bigint(12) DEFAULT NULL,
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de Inicio de la cuota',
  `FechaVencim` date DEFAULT NULL COMMENT 'Fecha de Vencimiento de la cuota',
  `FechaExigible` date DEFAULT NULL COMMENT 'Fecha exigible de Pago de la cuota',
  `Capital` decimal(14,2) DEFAULT NULL,
  `Interes` decimal(14,2) DEFAULT NULL,
  `IVAInteres` decimal(10,2) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`AmortizacionID`,`CreditoID`),
  KEY `fk_PAGARECREDITO_1_idx` (`CreditoID`),
  KEY `fk_PAGARECREDITO_2_idx` (`ClienteID`),
  KEY `fk_PAGARECREDITO_3` (`CuentaID`),
  CONSTRAINT `fk_PAGARECREDITO_2` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_PAGARECREDITO_3` FOREIGN KEY (`CuentaID`) REFERENCES `CUENTASAHO` (`CuentaAhoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Table que alamcena la tabla de Amortizacion para reimprimir '$$