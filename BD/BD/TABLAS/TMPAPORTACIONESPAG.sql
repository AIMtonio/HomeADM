DELIMITER ;
DROP TABLE IF EXISTS `TMPAPORTACIONESPAG`;

DELIMITER $$
CREATE TABLE `TMPAPORTACIONESPAG` (
  `ConsecutivoID` int(11) NOT NULL COMMENT 'Numero o ID de Aportaciรณn.',
  `AportacionID` int(11) NOT NULL COMMENT 'Numero o ID de Aportaciรณn.',
  `AmortizacionID` int(11) NOT NULL DEFAULT '0' COMMENT 'Id de la Amortizacion o Calendario.',
  `CuentaAhoID` bigint(20) DEFAULT NULL COMMENT 'Cuenta de ahorro.',
  `PagoIntCapitaliza` char(1) DEFAULT 'I' COMMENT 'Indica si capitaliza interes S:Si, N:No, I:Indistinto',
  `TipoReinversion` char(3) DEFAULT NULL COMMENT 'Indica el tipo de reinversion\nC) Capital\nCI) Capital mas interes\nN) Ninguna',
  `NumMaxAmort` int(11) NOT NULL DEFAULT '0',
  `ReinversionAutomatica` char(3) DEFAULT NULL COMMENT 'Indica Si/No reinvierte automaticamente\nS) Si\nN) No',
  `OpcionAportID` int(11) DEFAULT NULL COMMENT 'ID del Tipo de Aportacion, hace referencia a la tabla APORTACIONOPCIONES',
  `NumTransaccion` bigint(20) NOT NULL DEFAULT '0',
  KEY `idx_TMPAPORTACIONESPAG1` (`AportacionID`,`NumTransaccion`),
  KEY `idx_TMPAPORTACIONESPAG2` (`AmortizacionID`,`PagoIntCapitaliza`,`NumTransaccion`),
  KEY `idx_TMPAPORTACIONESPAG3` (`CuentaAhoID`,`NumTransaccion`),
  KEY `idx_TMPAPORTACIONESPAG4` (`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: CONTROL DE APORTACIONES PAGADAS'$$
