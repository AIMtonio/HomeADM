--
-- Table structure for table `TMPPAGAMORSIM`
--
DELIMITER ;
DROP TABLE IF EXISTS `TMPPAGAMORSIM`;
DELIMITER $$


CREATE TABLE `TMPPAGAMORSIM` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `Tmp_Consecutivo` int(11) DEFAULT NULL,
  `Tmp_Dias` int(11) DEFAULT NULL,
  `Tmp_FecIni` date DEFAULT NULL,
  `Tmp_FecFin` date DEFAULT NULL,
  `Tmp_FecVig` date DEFAULT NULL,
  `Tmp_Capital` decimal(12,2) DEFAULT NULL,
  `Tmp_Interes` decimal(12,2) DEFAULT NULL,
  `Tmp_Iva` decimal(12,2) DEFAULT NULL,
  `Tmp_SubTotal` decimal(12,2) DEFAULT NULL,
  `Tmp_Insoluto` decimal(12,2) DEFAULT NULL,
  `Tmp_CapInt` char(1) DEFAULT NULL COMMENT 'Bandera para saber si se trata de un pago de\ncapital C\ninteres I\no ambos  G\n',
  `Tmp_CuotasCap` int(11) DEFAULT NULL,
  `Tmp_CuotasInt` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  `Tmp_InteresAco` decimal(12,2) DEFAULT NULL COMMENT 'para llevar la suma del monto de interes ',
  `Tmp_FrecuPago` int(11) DEFAULT NULL,
  `Tmp_Retencion` decimal(14,2) DEFAULT NULL,
  `Tmp_Cat` decimal(12,2) DEFAULT NULL,
  `Tmp_MontoSeguroCuota` decimal(12,2) DEFAULT NULL COMMENT 'Monto del seguro por cuota',
  `Tmp_IVASeguroCuota` decimal(12,2) DEFAULT NULL COMMENT 'Monto de Iva para el seguro por cuota',
  `Tmp_OtrasComisiones` decimal(12,2) DEFAULT '0.00' COMMENT 'Otras Comisiones',
  `Tmp_IVAOtrasComisiones` decimal(12,2) DEFAULT '0.00' COMMENT 'IVA Otras Comisiones',
  `Tmp_SalCapitalOriginal` DECIMAL(16,2) DEFAULT '0.00' COMMENT 'Saldo Capital Original del Crédito Activo',
  `Tmp_SalInteresOriginal` DECIMAL(16,2) DEFAULT '0.00' COMMENT 'Saldo Interés Original del Crédito Activo',
  `Tmp_SalMoraOriginal` DECIMAL(16,2) DEFAULT '0.00' COMMENT 'Saldo Moratorio Original del Crédito Activo',
  `Tmp_SalComOriginal` DECIMAL(16,2) DEFAULT '0.00' COMMENT 'Saldo Comisiones Original del Crédito Activo',
  `Tmp_InteresOtrasComisiones` DECIMAL(12,2) DEFAULT '0.00' COMMENT 'Interes Otras Comisiones',
  `Tmp_IVAInteresOtrasComisiones` DECIMAL(12,2) DEFAULT '0.00' COMMENT 'IVA Interes Otras Comisiones',
 KEY `indexConsecutivo` (`Tmp_Consecutivo`,`NumTransaccion`),
  KEY `indexNumTransaccion` (`NumTransaccion`),
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para temporal de amortizaciones'$$
