-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPEDOCTAHEADERCRED
DELIMITER ;
DROP TABLE IF EXISTS `TMPEDOCTAHEADERCRED`;DELIMITER $$

CREATE TABLE `TMPEDOCTAHEADERCRED` (
  `AnioMes` int(11) DEFAULT NULL,
  `CreditoID` bigint(20) DEFAULT NULL,
  `ClienteID` int(11) DEFAULT NULL,
  `NombreProducto` varchar(100) DEFAULT NULL,
  `MontoOtorgado` decimal(14,2) DEFAULT NULL,
  `FechaVencimiento` date DEFAULT NULL,
  `SaldoInsoluto` decimal(14,2) DEFAULT NULL,
  `SaldoInicial` decimal(14,2) DEFAULT NULL,
  `Pagos` varchar(50) DEFAULT NULL,
  `Cat` decimal(18,2) DEFAULT NULL,
  `TasaFija` decimal(18,2) DEFAULT NULL,
  `TasaMoratoria` decimal(18,2) DEFAULT NULL,
  `IntPagadoPerido` decimal(18,2) DEFAULT NULL,
  `IvaIntPagadoPerido` decimal(18,2) DEFAULT NULL,
  `TotalComisionesPagar` decimal(14,2) DEFAULT NULL,
  `IvaComPagadoPeriodo` decimal(18,2) DEFAULT NULL,
  `TotalPagar` decimal(14,2) DEFAULT NULL,
  `CapitalApagar` decimal(14,2) DEFAULT NULL,
  `InteresNormalApagar` decimal(14,2) DEFAULT NULL,
  `IvaInteresNomalApagar` decimal(14,2) DEFAULT NULL,
  `OtrosCargosApagar` decimal(14,2) DEFAULT NULL,
  `IvaOtrosCargosApagar` decimal(14,2) DEFAULT NULL,
  `FechaProximoPago` date DEFAULT NULL,
  `FechaProxPagoLeyenda` varchar(50) DEFAULT NULL,
  `ValorIvaCred` decimal(14,2) DEFAULT NULL,
  `Moratorios` decimal(14,2) DEFAULT NULL,
  `IVAMoratorios` decimal(14,2) DEFAULT NULL,
  KEY `IDX_TMPEDOCTAHEADERCRED_ANIOMES` (`AnioMes`) USING BTREE,
  KEY `IDX_TMPEDOCTAHEADERCRED_CLIENTE` (`ClienteID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$