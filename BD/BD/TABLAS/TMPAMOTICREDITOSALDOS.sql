-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPAMOTICREDITOSALDOS
DELIMITER ;
DROP TABLE IF EXISTS `TMPAMOTICREDITOSALDOS`;DELIMITER $$

CREATE TABLE `TMPAMOTICREDITOSALDOS` (
  `AmortizacionID` int(11) DEFAULT NULL,
  `CreditoID` bigint(12) DEFAULT NULL,
  `ClienteID` int(11) DEFAULT NULL,
  `CuentaID` bigint(12) DEFAULT NULL,
  `FechaInicio` date DEFAULT NULL,
  `FechaVencim` date DEFAULT NULL,
  `FechaExigible` date DEFAULT NULL,
  `Estatus` varchar(1) DEFAULT NULL,
  `FechaLiquida` date DEFAULT NULL,
  `Capital` decimal(14,2) DEFAULT NULL,
  `Interes` decimal(14,2) DEFAULT NULL,
  `IVAInteres` decimal(10,2) DEFAULT NULL,
  `SaldoCapVigente` decimal(14,2) DEFAULT NULL,
  `SaldoCapAtrasa` decimal(14,2) DEFAULT NULL,
  `SaldoCapVencido` decimal(14,2) DEFAULT NULL,
  `SaldoCapVenNExi` decimal(14,2) DEFAULT NULL,
  `SaldoInteresOrd` decimal(14,4) DEFAULT NULL,
  `SaldoInteresAtr` decimal(14,4) DEFAULT NULL,
  `SaldoInteresVen` decimal(14,4) DEFAULT NULL,
  `SaldoInteresPro` decimal(14,4) DEFAULT NULL,
  `SaldoIntNoConta` decimal(12,4) DEFAULT NULL,
  `SaldoIVAInteres` decimal(14,2) DEFAULT NULL,
  `SaldoMoratorios` decimal(14,2) DEFAULT NULL,
  `SaldoIVAMorato` decimal(14,2) DEFAULT NULL,
  `SaldoComFaltaPa` decimal(14,2) DEFAULT NULL,
  `SaldoIVAComFalP` decimal(14,2) DEFAULT NULL,
  `SaldoOtrasComis` decimal(14,2) DEFAULT NULL,
  `SaldoIVAComisi` decimal(14,2) DEFAULT NULL,
  `ProvisionAcum` decimal(14,4) DEFAULT NULL,
  `SaldoCapital` decimal(14,2) DEFAULT NULL,
  `NumProyInteres` int(11) DEFAULT NULL,
  `SaldoMoraVencido` decimal(14,2) DEFAULT NULL,
  `SaldoMoraCarVen` decimal(14,2) DEFAULT NULL,
  `TotalCuotaMasIVA` decimal(14,2) DEFAULT NULL,
  `TotalCuotaSinIVA` decimal(14,2) DEFAULT NULL,
  `MontoCuota` decimal(14,2) DEFAULT NULL,
  `TotalCapital` decimal(14,2) DEFAULT NULL,
  `TotalInteres` decimal(14,2) DEFAULT NULL,
  `TotalIva` decimal(14,2) DEFAULT NULL,
  KEY `CreditoID` (`CreditoID`,`AmortizacionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla temporal que guarda datos de las amortizaciones para hacer el calculo del iva de los interes de un credito.'$$