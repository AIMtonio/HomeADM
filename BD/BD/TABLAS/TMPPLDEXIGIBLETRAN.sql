
DELIMITER ;
DROP TABLE IF EXISTS `TMPPLDEXIGIBLETRAN`;

DELIMITER $$
CREATE TABLE `TMPPLDEXIGIBLETRAN` (
  `RegistroID` bigint(12) unsigned NOT NULL AUTO_INCREMENT,
  `Transaccion` bigint(20) NOT NULL COMMENT 'Numero de transaccion del pago',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Id del Credito',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Numero de Cliente\n',
  `CuentaAhoID` bigint(12) DEFAULT NULL COMMENT 'Numero de Cuenta',
  `NumTransaccion` bigint(20) NOT NULL,
  `AlertaXCuota1` char(1) DEFAULT 'N' COMMENT 'Indica si genera Alerta por Pago Mayor al Exigible.\nS.- Sí.\nN.- No.',
  `AlertaXCuota2` char(1) DEFAULT 'N' COMMENT 'Indica si genera Alerta por Pago Sup. al Exigible. Nva Alerta.\nS.- Sí.\nN.- No.',
  PRIMARY KEY (`RegistroID`),
  KEY `IDX_TMPPLDEXIGIBLETRAN_1` (`NumTransaccion`),
  KEY `IDX_TMPPLDEXIGIBLETRAN_2` (`Transaccion`),
  KEY `IDX_TMPPLDEXIGIBLETRAN_3` (`Transaccion`,`CreditoID`),
  KEY `IDX_TMPPLDEXIGIBLETRAN_4` (`NumTransaccion`,`AlertaXCuota1`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT 'TMP:Tabla temporal operaciones resultados exigible en deteccion de  operaciones inusuales-PLDOPEINUSALERTTRANSPRO'$$

