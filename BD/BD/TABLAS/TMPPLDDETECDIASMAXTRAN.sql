DELIMITER ;
DROP TABLE IF EXISTS `TMPPLDDETECDIASMAXTRAN`;
DELIMITER $$

CREATE TABLE `TMPPLDDETECDIASMAXTRAN` (
  `ConsecutivoID` bigint(12) unsigned NOT NULL AUTO_INCREMENT,
  `Transaccion` bigint(20) NOT NULL COMMENT 'Numero de transaccion del pago',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Id del Credito',
  `CuentaAhoID` bigint(12) NOT NULL COMMENT 'ID de la Cuenta',
  `PorcDiasMax` decimal(14,2) DEFAULT '0.00' COMMENT 'Porcentaje de holgura para Dias de pago anticipado.',
  `AmortizacionID` int(4) NOT NULL COMMENT 'No\nAmortizacion',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Numero de Cliente\n',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de Inicio\n',
  `FechaExigible` date DEFAULT NULL COMMENT 'Fecha Exigible\nde Pago\n',
  `FechaPago` date NOT NULL COMMENT 'Fecha de\nVencimiento',
  `FormaPago` char(1) DEFAULT NULL COMMENT 'Guarda forma de pago \nE = Efectivo\nC = Cargo a cuenta',
  `Dias` bigint(21) DEFAULT NULL,
  `DiasAnt` bigint(21) DEFAULT NULL,
  `DiasHolgura` decimal(35,2) DEFAULT NULL,
  `NumTransaccion` bigint(20) NOT NULL,
  PRIMARY KEY(ConsecutivoID),
  KEY `IDX_TMPPLDDETECDIASMAXTRAN_1` (`Transaccion`),
  KEY `IDX_TMPPLDDETECDIASMAXTRAN_2` (`ClienteID`),
  KEY `IDX_TMPPLDDETECDIASMAXTRAN_3` (`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT 'TMP: Registran como alertas, todos los pagos que se registraton W dias antes de su exigibilidad-PLDOPEINUSALERTTRANSPRO'$$