-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- Amortizaciones
DELIMITER ;
DROP TABLE IF EXISTS `Amortizaciones`;DELIMITER $$

CREATE TABLE `Amortizaciones` (
  `AmortizacionID` int(11) NOT NULL,
  `CreditoID` bigint(12) NOT NULL,
  `FechaInicio` datetime DEFAULT NULL,
  `FechaVencim` datetime DEFAULT NULL,
  `FechaExigible` datetime DEFAULT NULL,
  `FechaLiquida` datetime DEFAULT NULL,
  `Estatus` varchar(1) DEFAULT NULL,
  `Capital` decimal(14,2) DEFAULT NULL,
  `Interes` decimal(14,2) DEFAULT NULL,
  `IVAInteres` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`AmortizacionID`,`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Amortizaciones de los Creditos'$$