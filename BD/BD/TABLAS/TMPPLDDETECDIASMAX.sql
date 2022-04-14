-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPPLDDETECDIASMAX
DELIMITER ;
DROP TABLE IF EXISTS `TMPPLDDETECDIASMAX`;DELIMITER $$

CREATE TABLE `TMPPLDDETECDIASMAX` (
  `Transaccion` bigint(20) NOT NULL COMMENT 'Numero de transaccion del pago',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Id del Credito',
  `CuentaAhoID` bigint(12) NOT NULL COMMENT 'ID de la Cuenta',
  `PorcDiasMax` decimal(14,2) DEFAULT '0.00' COMMENT 'Porcentaje de holgura para Dias de pago anticipado.',
  `AmortizacionID` int(4) NOT NULL COMMENT 'No\nAmortizacion',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Numero de Cliente\n',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de Inicio\n',
  `FechaExigible` date DEFAULT NULL COMMENT 'Fecha Exigible\nde Pago\n',
  `FechaPago` date NOT NULL COMMENT 'Fecha de\nVencimiento',
  `Dias` bigint(21) DEFAULT NULL,
  `DiasAnt` bigint(21) DEFAULT NULL,
  `DiasHolgura` decimal(35,2) DEFAULT NULL,
  KEY `IDX_TMPPLDDETECDIASMAX_1` (`Transaccion`),
  KEY `IDX_TMPPLDDETECDIASMAX_2` (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$