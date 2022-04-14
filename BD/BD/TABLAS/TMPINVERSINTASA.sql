-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPINVERSINTASA
DELIMITER ;
DROP TABLE IF EXISTS `TMPINVERSINTASA`;DELIMITER $$

CREATE TABLE `TMPINVERSINTASA` (
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
  `NuevaTasa` decimal(12,4) DEFAULT NULL,
  `ClienteID` int(11) DEFAULT NULL,
  `SaldoProvision` decimal(12,2) DEFAULT NULL,
  PRIMARY KEY (`InversionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Temporal para las Inversiones sin tasa  se usa en proceso INVERSINTASAPRO'$$