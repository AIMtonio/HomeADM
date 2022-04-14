-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWTMPBACKAMORSIM
DELIMITER ;
DROP TABLE IF EXISTS `CRWTMPBACKAMORSIM`;
DELIMITER $$


CREATE TABLE `CRWTMPBACKAMORSIM` (
  `Tmp_Consecutivo` int(11) NOT NULL COMMENT 'Consecutivo ',
  `Tmp_Dias` int(11) NOT NULL COMMENT 'Dias',
  `Tmp_FecIni` date NOT NULL COMMENT 'Fecha inicial',
  `Tmp_FecFin` date NOT NULL COMMENT 'Fecha final',
  `Tmp_FecVig` date NOT NULL COMMENT 'Fecha vigencia',
  `Tmp_Capital` decimal(12,2) NOT NULL COMMENT 'Capital',
  `Tmp_Interes` decimal(12,2) NOT NULL COMMENT 'Interes',
  `Tmp_Iva` decimal(12,2) NOT NULL COMMENT 'IVA',
  `Tmp_SubTotal` decimal(12,2) NOT NULL COMMENT 'Sub total',
  `Tmp_Insoluto` decimal(12,2) NOT NULL COMMENT 'insoluto',
  `Tmp_CapInt` char(1) NOT NULL COMMENT 'Bandera para saber si se trata de un pago de\ncapital C\ninteres I\no ambos  G\n',
  `Tmp_CuotasCap` int(11) NOT NULL COMMENT 'Cuotas capital',
  `Tmp_CuotasInt` int(11) NOT NULL COMMENT 'Cuotas interes',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Numero de la transaccion',
  `Tmp_InteresAco` decimal(12,2) NOT NULL COMMENT 'para llevar la suma del monto de interes ',
  `Tmp_FrecuPago` int(11) NOT NULL COMMENT 'Frecuencia pago',
  `Tmp_ISR` decimal(12,2) NOT NULL COMMENT 'ISR o Retencion por el Rendimiento (Aplica en Simulaciones de Cartera Pasiva)',
  `Tmp_TotalRec` decimal(14,2) NOT NULL COMMENT 'Total recaudado',
  KEY `TMPBACKAMORSIM_1` (`NumTransaccion`),
  KEY `TMPBACKAMORSIM_2` (`NumTransaccion`,`Tmp_Consecutivo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para Respaldo temporal de amortizaciones'$$
