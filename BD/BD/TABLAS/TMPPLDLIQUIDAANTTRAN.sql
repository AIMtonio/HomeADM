
DELIMITER ;
DROP TABLE IF EXISTS `TMPPLDLIQUIDAANTTRAN`;

DELIMITER $$
CREATE TABLE `TMPPLDLIQUIDAANTTRAN` (
  `RegistroID` bigint(12) UNSIGNED NOT NULL AUTO_INCREMENT,
  `Transaccion` bigint(20) NOT NULL COMMENT 'Numero de transaccion del pago',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Id del Credito',
  `CuentaAhoID` bigint(12) NOT NULL COMMENT 'ID de la Cuenta',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Numero de Cliente\n',
  `TotalPago` decimal(14,2) DEFAULT NULL COMMENT 'Monto Total Pagado',
  `FormaPago` char(1) DEFAULT NULL COMMENT 'Guarda forma de pago \nE = Efectivo\nC = Cargo a cuenta',
  `MontoTotal` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto Total del Crédito que es la sumatoria de Capital, Interés e IVA de AMORTICREDITO.',
  `PorcLiqAnt` decimal(14,2) DEFAULT '0.00' COMMENT 'Porcentaje de holgura Liquidación Anticipada de Créditos sobre el Monto Total del Crédito.',
  `MontoLimite` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto Total del Crédito + el % de Holgura.',
  `PlazoDias` bigint(12) DEFAULT '0' COMMENT 'Plazo en Días del Crédito.\nDiferencia entre la Fecha de Incio y de Vencimeinto.',
  `PlazoAlPago` bigint(12) DEFAULT '0' COMMENT 'Plazo en Días.\nDiferencia entre la Fecha de Pago y de Vencimeinto.',
  `PorcDiasLiqAnt` decimal(14,2) DEFAULT '0.00' COMMENT 'Porcentaje de Días que se tendrá permitido Liquidar un Crédito de manera Anticipada.',
  `PlazoLimite` bigint(12) DEFAULT '0' COMMENT 'Plazo en Días con el % de Holgura.',
  `AlertaXMonto` char(1) DEFAULT 'N' COMMENT 'Indica si genera Alerta por Liq. por Monto.\nS.- Sí.\nN.- No.',
  `AlertaXDias` char(1) DEFAULT 'N' COMMENT 'Indica si genera Alerta por Liq. por Dias.\nS.- Sí.\nN.- No.',
  `NumTransaccion` bigint(20) NOT NULL,
  PRIMARY KEY(RegistroID),
  KEY `IDX_TMPPLDLIQUIDAANTTRAN_1` (`Transaccion`,`CreditoID`),
  KEY `IDX_TMPPLDLIQUIDAANTTRAN_2` (`ClienteID`),
  KEY `IDX_TMPPLDLIQUIDAANTTRAN_3` (`NumTransaccion`),
  KEY `IDX_TMPPLDLIQUIDAANTTRAN_4` (`CreditoID`),
  KEY `IDX_TMPPLDLIQUIDAANTTRAN_5` (`AlertaXMonto`),
  KEY `IDX_TMPPLDLIQUIDAANTTRAN_6` (`AlertaXDias`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT 'TMP:Tabla temporal liquidaciones anticipadas en deteccion de  operaciones inusuales-PLDOPEINUSALERTTRANSPRO'$$

