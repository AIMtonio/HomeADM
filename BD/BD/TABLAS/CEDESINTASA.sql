-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CEDESINTASA
DELIMITER ;
DROP TABLE IF EXISTS `CEDESINTASA`;DELIMITER $$

CREATE TABLE `CEDESINTASA` (
  `CedeID` int(11) NOT NULL DEFAULT '0' COMMENT 'CedeId sin Nueva Tasa.',
  `CuentaAhoID` bigint(20) DEFAULT NULL COMMENT 'CuentaAhoID.',
  `TipoCedeID` int(11) DEFAULT NULL COMMENT 'Tipo de Cede.',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'MonedaID.',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha Inicio de la Cede.',
  `Monto` decimal(18,2) DEFAULT NULL COMMENT 'Monto de la Cede.',
  `Plazo` int(11) DEFAULT NULL COMMENT 'Plazo de la Cede.',
  `Tasa` decimal(14,4) DEFAULT NULL COMMENT 'Tasa de la Cede.',
  `TasaISR` decimal(14,4) DEFAULT NULL COMMENT 'TasaISR a Aplicar.',
  `TasaNeta` decimal(14,4) DEFAULT NULL COMMENT 'Tasa Neta de la Cede.',
  `InteresGenerado` decimal(18,2) DEFAULT NULL COMMENT 'Interes Generado de la Cede.',
  `InteresRetener` decimal(18,2) DEFAULT NULL COMMENT 'Interes a Retener de la cede.',
  `InteresRecibir` decimal(18,2) DEFAULT NULL COMMENT 'Interes a Recibir de la Cede',
  `SaldoProvision` decimal(18,2) DEFAULT NULL COMMENT 'Saldo Provision de la Amoritzacion a Pagar',
  `AmortizacionID` int(11) DEFAULT NULL COMMENT 'Numero de amortizacion',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'ID del cliente relacionado al Cede',
  `TasaFV` char(1) DEFAULT NULL COMMENT 'Tipo Tasa F.- FIja V.- Variable',
  `FechaVencimiento` date DEFAULT NULL COMMENT 'Fecha de Vencimiento de la Cede',
  PRIMARY KEY (`CedeID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Temporal para Cedes sin tasa.'$$