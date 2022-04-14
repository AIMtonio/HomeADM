-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TEMINVERSIONES
DELIMITER ;
DROP TABLE IF EXISTS `TEMINVERSIONES`;DELIMITER $$

CREATE TABLE `TEMINVERSIONES` (
  `InversionID` int(11) NOT NULL DEFAULT '0',
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `TipoInversionID` int(11) DEFAULT NULL,
  `MonedaID` int(11) DEFAULT NULL,
  `FechaInicio` date DEFAULT NULL,
  `Monto` decimal(12,2) DEFAULT NULL,
  `Plazo` int(11) DEFAULT NULL,
  `Tasa` decimal(12,4) DEFAULT NULL,
  `TasaISR` decimal(12,4) DEFAULT NULL,
  `TasaNeta` decimal(12,4) DEFAULT NULL,
  `InteresGenerado` decimal(12,2) DEFAULT NULL,
  `InteresRecibir` decimal(12,2) DEFAULT NULL,
  `InteresRetener` decimal(12,2) DEFAULT NULL,
  `ConsecutivoTabla` int(11) DEFAULT NULL,
  `FechaPosibleVencimiento` date DEFAULT NULL,
  `NuevoPlazo` int(11) DEFAULT NULL,
  `FechaVencimiento` date DEFAULT NULL,
  `MontoReinvertir` decimal(12,2) DEFAULT NULL,
  `NuevaTasa` decimal(12,4) DEFAULT NULL,
  `NuevaTasaISR` decimal(12,4) DEFAULT NULL,
  `NuevaTasaNeta` decimal(12,4) DEFAULT NULL,
  `NuevoInteresGenerado` decimal(12,2) DEFAULT NULL,
  `NuevoInteresRetener` decimal(12,2) DEFAULT NULL,
  `NuevoInteresRecibir` decimal(12,2) DEFAULT NULL,
  `Reinvertir` char(5) DEFAULT NULL,
  `ClienteID` int(11) DEFAULT NULL,
  `SaldoProvision` decimal(12,2) DEFAULT NULL,
  `Etiqueta` varchar(100) DEFAULT NULL COMMENT 'Etiqueta o \nReferencia del\nMotivo de Apertura\nde la Inversion',
  `ValorGat` decimal(12,2) DEFAULT NULL COMMENT 'Valor Calculado de Ganancia Anual Total',
  `NuevaInversionID` int(11) DEFAULT '0' COMMENT 'ID de la Nueva Inversion',
  `Beneficiario` char(1) DEFAULT NULL COMMENT 'Tipo de Beneficiario de la inversión, puede ser: Cuenta Socio "S"   o Propio de la Inversión "I"',
  `ValorGatReal` decimal(12,2) DEFAULT NULL,
  PRIMARY KEY (`InversionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Temporal para las Renovaciones Masivas Automaticas de Invers'$$