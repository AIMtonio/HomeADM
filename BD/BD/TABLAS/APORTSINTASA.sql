-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTSINTASA
DELIMITER ;
DROP TABLE IF EXISTS `APORTSINTASA`;DELIMITER $$

CREATE TABLE `APORTSINTASA` (
  `AportacionID` int(11) NOT NULL DEFAULT '0' COMMENT 'AportacionId sin Nueva Tasa.',
  `CuentaAhoID` bigint(20) DEFAULT NULL COMMENT 'CuentaAhoID.',
  `TipoAportacionID` int(11) DEFAULT NULL COMMENT 'Tipo de Aportacion.',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'MonedaID.',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha Inicio de la Aportacion.',
  `Monto` decimal(18,2) DEFAULT NULL COMMENT 'Monto de la Aportacion.',
  `Plazo` int(11) DEFAULT NULL COMMENT 'Plazo de la Aportacion.',
  `Tasa` decimal(14,4) DEFAULT NULL COMMENT 'Tasa de la Aportacion.',
  `TasaISR` decimal(14,4) DEFAULT NULL COMMENT 'TasaISR a Aplicar.',
  `TasaNeta` decimal(14,4) DEFAULT NULL COMMENT 'Tasa Neta de la Aportacion.',
  `InteresGenerado` decimal(18,2) DEFAULT NULL COMMENT 'Interes Generado de la Aportacion.',
  `InteresRetener` decimal(18,2) DEFAULT NULL COMMENT 'Interes a Retener de la Aportacion.',
  `InteresRecibir` decimal(18,2) DEFAULT NULL COMMENT 'Interes a Recibir de la Aportacion',
  `SaldoProvision` decimal(18,2) DEFAULT NULL COMMENT 'Saldo Provision de la Amortizacion a Pagar',
  `AmortizacionID` int(11) DEFAULT NULL COMMENT 'Numero de amortizacion',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'ID del cliente relacionado al Aportacion',
  `TasaFV` char(1) DEFAULT NULL COMMENT 'Tipo Tasa F.- FIja V.- Variable',
  `FechaVencimiento` date DEFAULT NULL COMMENT 'Fecha de Vencimiento de la Aportacion',
  PRIMARY KEY (`AportacionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para Aportaciones sin tasa.'$$