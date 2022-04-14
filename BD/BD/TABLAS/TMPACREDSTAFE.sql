-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPACREDSTAFE
DELIMITER ;
DROP TABLE IF EXISTS `TMPACREDSTAFE`;DELIMITER $$

CREATE TABLE `TMPACREDSTAFE` (
  `ConsecutivoID` bigint(12) DEFAULT NULL,
  `ClienteID` int(11) DEFAULT NULL,
  `SolicitudCreditoID` int(11) DEFAULT NULL,
  `ProductoCreditoID` int(11) DEFAULT NULL,
  `NombreProducto` varchar(100) DEFAULT NULL,
  `NombreCompleto` varchar(500) DEFAULT '',
  `Domicilio` varchar(500) DEFAULT '',
  `Telefono` varchar(500) DEFAULT '',
  `RFC` varchar(20) DEFAULT '',
  `CorreoElect` varchar(100) DEFAULT '',
  `CURP` varchar(20) DEFAULT '',
  `DocIdentificacion` varchar(100) DEFAULT '',
  `CreditoIDInt` bigint(12) DEFAULT NULL,
  `FechaMinistrado` date DEFAULT NULL,
  `FechaExigible` date DEFAULT NULL,
  `NumAmortizacion` int(11) DEFAULT NULL,
  `PeriodicidadCap` int(11) DEFAULT NULL,
  `MontoCredito` decimal(18,2) DEFAULT '0.00',
  `MontoCreditoTot` decimal(18,2) DEFAULT '0.00',
  `MontoComApert` decimal(18,2) DEFAULT '0.00',
  `MontoCATI` decimal(18,2) DEFAULT '0.00',
  `MontoCAP` decimal(18,2) DEFAULT '0.00',
  `MontoAT` decimal(18,2) DEFAULT '0.00',
  `AporteCliente` decimal(18,2) DEFAULT '0.00',
  `FechaVencimien` date DEFAULT NULL,
  `EsGrupal` char(1) DEFAULT NULL,
  `DestinoCreID` int(11) DEFAULT NULL,
  `NombreDestinoCred` varchar(500) DEFAULT '',
  `ClasificacionID` int(11) DEFAULT NULL,
  `DescripClasifica` varchar(300) DEFAULT '',
  `MontoCuota` decimal(18,2) DEFAULT NULL,
  `ValorCAT` decimal(18,4) DEFAULT NULL,
  `PlazoID` varchar(20) DEFAULT NULL,
  `PlazoDescripcion` varchar(50) DEFAULT NULL,
  `TasaFija` decimal(18,4) DEFAULT NULL,
  `FactorMora` decimal(18,4) DEFAULT NULL,
  `LineaCreditoID` bigint(20) DEFAULT NULL,
  `MontoLinea` decimal(18,2) DEFAULT NULL,
  `SeguroVidaID` int(11) DEFAULT NULL,
  `CobraSeguroCuota` char(1) DEFAULT NULL,
  `GarantiaID1er` int(11) DEFAULT NULL,
  `NombreGarante1er` varchar(200) DEFAULT NULL,
  `TipoGarantia` varchar(1000) DEFAULT NULL,
  `ObservacionesGar` varchar(1000) DEFAULT NULL,
  `NoChequeTransf` bigint(20) DEFAULT NULL,
  `CreditoID` bigint(12) DEFAULT NULL,
  KEY `ConsecutivoID` (`ConsecutivoID`),
  KEY `ClienteID` (`ClienteID`),
  KEY `SolicitudCreditoID` (`SolicitudCreditoID`),
  KEY `ProductoCreditoID` (`ProductoCreditoID`),
  KEY `CreditoIDInt` (`CreditoIDInt`),
  KEY `GarantiaID1er` (`GarantiaID1er`),
  KEY `PlazoID` (`PlazoID`),
  KEY `LineaCreditoID` (`LineaCreditoID`),
  KEY `DestinoCreID` (`DestinoCreID`),
  KEY `CreditoID` (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$