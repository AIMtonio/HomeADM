DELIMITER ;
DROP TABLE IF EXISTS `TMPOPERINUDETEEMAILTRAN`;
DELIMITER $$

CREATE TABLE `TMPOPERINUDETEEMAILTRAN` (
  `ConsecutivoID` bigint(12) unsigned NOT NULL AUTO_INCREMENT,
  `OpeInusualID` bigint(20) NOT NULL COMMENT 'Numero de Operacion inusual',
  `Transaccion` bigint(20) NOT NULL COMMENT 'Numero de transaccion',
  `NumTransaccion` bigint(20) NOT NULL,
  PRIMARY KEY(ConsecutivoID),
  KEY `IDX_TMPOPERINUDETEEMAILTRAN_1` (`OpeInusualID`),
  KEY `IDX_TMPOPERINUDETEEMAILTRAN_2` (`Transaccion`),
  KEY `IDX_TMPOPERINUDETEEMAILTRAN_3` (`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT 'TMP: Tabla para envio de correo de deteccion de operaciones inusuales-PLDOPEINUSALERTTRANSPRO'$$