-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCOTIZADORINV
DELIMITER ;
DROP TABLE IF EXISTS `TMPCOTIZADORINV`;DELIMITER $$

CREATE TABLE `TMPCOTIZADORINV` (
  `Tmp_Consecutivo` int(11) DEFAULT NULL,
  `Tmp_Dias` int(11) DEFAULT NULL,
  `Tmp_FecIni` date DEFAULT NULL,
  `Tmp_FecFin` date DEFAULT NULL,
  `Tmp_FecVig` date DEFAULT NULL,
  `Tmp_Capital` decimal(12,2) DEFAULT NULL,
  `Tmp_Interes` decimal(12,2) DEFAULT NULL,
  `Tmp_Iva` decimal(12,2) DEFAULT NULL,
  `Tmp_SubTotal` decimal(12,2) DEFAULT NULL COMMENT ' Subtotal = cap + Int',
  `Tmp_TotalRec` decimal(12,2) DEFAULT NULL COMMENT 'totalrecibir = cap + int -isr',
  `Tmp_Insoluto` decimal(12,2) DEFAULT NULL,
  `Tmp_CapInt` char(1) DEFAULT NULL COMMENT 'Bandera para saber si se trata de un pago de\ncapital C\ninteres I\no ambos  G\n',
  `Tmp_CuotasCap` int(11) DEFAULT NULL,
  `Tmp_CuotasInt` int(11) DEFAULT NULL,
  `Tmp_ISR` decimal(14,2) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  `Tmp_InteresAco` decimal(12,2) DEFAULT NULL COMMENT 'para llevar la suma del monto de interes ',
  `Tmp_FrecuPago` int(11) DEFAULT NULL,
  KEY `indexConsecutivo` (`Tmp_Consecutivo`,`NumTransaccion`),
  KEY `indexNumTransaccion` (`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para temporal para el cotizador de inversiones'$$