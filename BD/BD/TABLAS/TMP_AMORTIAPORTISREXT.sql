
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMP_AMORTIAPORTISREXT

DELIMITER ;
DROP TABLE IF EXISTS `TMP_AMORTIAPORTISREXT`;

DELIMITER $$
CREATE TABLE `TMP_AMORTIAPORTISREXT` (
  `TmpID` bigint(20) NOT NULL COMMENT 'Numero Consecutivo.',
  `AportacionID` int(11) NOT NULL COMMENT 'Numero o ID de Aportación.',
  `AmortizacionID` int(11) NOT NULL DEFAULT '0' COMMENT 'Id de la Amortizacion o Calendario.',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de Inicio.',
  `FechaPago` date DEFAULT NULL COMMENT 'Fecha en que se pagan los intereses, mientras no sea la fecha en que se paga capital se refiere a un dia habil antes\n.',
  `Capital` decimal(18,2) DEFAULT NULL COMMENT 'Monto del Capital.',
  `Interes` decimal(18,2) DEFAULT NULL COMMENT 'Interes.',
  `InteresRetener` decimal(18,2) DEFAULT NULL COMMENT 'Interes a Retener ISR.',
  `Total` decimal(18,2) DEFAULT NULL COMMENT 'Total Capital + Interes - ISR .',
  `SaldoCap` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT 'Saldo capital para aportaciones que permiten capitalizacion.',
  `TipoPeriodo` char(1) DEFAULT '' COMMENT 'Tipo de Periodo para el Cálculo de Interés e ISR.\nR.- Periodo Regular.\nI.- Periodo Irregular.',
  `PagoIntCapitaliza` char(1) DEFAULT 'I' COMMENT 'Indica si capitaliza interes S:Si, N:No, I:Indistinto',
  `Dias1erPer` int(11) DEFAULT NULL COMMENT 'Núm. de dias que hay entre la fecha de incio y la fecha de cambio de tasa.',
  `FechaFin1erPer` date DEFAULT '1900-01-01' COMMENT 'Fecha Fin del primer corte respecto al cambio de tasa.',
  `ISR1erPer` decimal(18,2) DEFAULT NULL COMMENT 'Interes a Retener ISR con la tasa anterior.',
  `Dias2doPer` int(11) DEFAULT NULL COMMENT 'Núm. de dias que hay entre la fecha de cambio de tasa y la fecha de pago.',
  `FechaFin2doPer` date DEFAULT '1900-01-01' COMMENT 'Fecha Fin del segundo corte respecto al cambio de tasa.',
  `ISR2doPer` decimal(18,2) DEFAULT NULL COMMENT 'Interes a Retener ISR con la nueva tasa.',
  `FechaCalculo` date DEFAULT NULL COMMENT 'Fecha de cierre.',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria.',
  PRIMARY KEY (`NumTransaccion`,`AportacionID`,`AmortizacionID`),
  KEY `INDEX_TMP_AMORTIAPORTISREXT_001` (`AportacionID`,`AmortizacionID`),
  KEY `INDEX_TMP_AMORTIAPORTISREXT_002` (`TmpID`,`NumTransaccion`),
  KEY `INDEX_TMP_AMORTIAPORTISREXT_003` (`AportacionID`),
  KEY `INDEX_TMP_AMORTIAPORTISREXT_004` (`AmortizacionID`),
  KEY `INDEX_TMP_AMORTIAPORTISREXT_005` (`NumTransaccion`),
  KEY `INDEX_TMP_AMORTIAPORTISREXT_006` (`TmpID`,`NumTransaccion`,`FechaCalculo`),
  KEY `INDEX_TMP_AMORTIAPORTISREXT_007` (`NumTransaccion`,`FechaCalculo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Cuotas que se verán afectadas por el cambio de tasa ISR en Aportaciones de clientes extranjeros.'$$
