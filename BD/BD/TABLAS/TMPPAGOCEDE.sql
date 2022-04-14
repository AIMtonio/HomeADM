-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPPAGOCEDE
DELIMITER ;
DROP TABLE IF EXISTS `TMPPAGOCEDE`;
DELIMITER $$


CREATE TABLE `TMPPAGOCEDE` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Numero de Transaccion',
  `CedeID` bigint(20) DEFAULT NULL COMMENT 'Id del CEDE',
  `CuentaAhoID` bigint(20) DEFAULT NULL COMMENT 'Cuenta de Ahorro',
  `TipoCedeID` int(11) DEFAULT NULL COMMENT 'Tipo de CEDE',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'ID de la Moneda',
  `Capital` decimal(18,2) DEFAULT NULL COMMENT 'Capital',
  `Interes` decimal(18,2) DEFAULT NULL COMMENT 'Monto del Inteers',
  `InteresRetener` decimal(18,2) DEFAULT NULL COMMENT 'Interes a Retener',
  `ClienteID` decimal(18,2) DEFAULT NULL COMMENT 'ID del Cliente',
  `SaldoProvision` decimal(18,2) DEFAULT NULL COMMENT 'Saldo d ela Provision',
  `SucursalOrigen` int(11) DEFAULT NULL COMMENT 'Sucursal Origen',
  `AmortizacionID` int(11) DEFAULT NULL COMMENT 'ID de la Amortizacion',
  `FechaVencimiento` date DEFAULT NULL COMMENT 'Fecha de Vencimiento',
  `FechaPago` date DEFAULT NULL COMMENT 'Fecha de Pago',
  `CalculoInteres` int(11) DEFAULT NULL COMMENT 'Tipo de Calculo de Interes',
  `FechaIniAmo` date DEFAULT NULL COMMENT 'Fecha de Inicio de la Amortizacion',
  `FechaVenciAmo` date DEFAULT NULL COMMENT 'Fecha de Vencimiento de Amortizacion',
  `PagaISR` char(1) DEFAULT 'S' COMMENT 'Paga ISR',
  `TasaISR` decimal(12,4) DEFAULT NULL COMMENT 'tasa ISR',
  KEY `TMPPAGOCEDE_IDX_1` (`NumTransaccion`),
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Temporal para el Pago o Vencimiento de los CEDES'$$
