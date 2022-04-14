DELIMITER ;
DROP TABLE IF EXISTS `TMPIDDEPOSITOSREFEAPLICA`;
DELIMITER $$

CREATE TABLE `TMPIDDEPOSITOSREFEAPLICA` (
  `ConsecutivoID` int(11) NOT NULL COMMENT 'Consecutivo identificador de los depositos a procesar',
  `NumTran` bigint(20) NOT NULL COMMENT 'Numero de Transaccion de Carga.',
  `NumeroFila` int(11) NOT NULL COMMENT 'Numero de Fila del deposito en el archivo cargado',
  PRIMARY KEY(`ConsecutivoID`,`NumTran`),
  KEY `IDX_TMPIDDEPOSITOSREFEAPLICA_1` (`ConsecutivoID`),
  KEY `IDX_TMPIDDEPOSITOSREFEAPLICA_2` (`NumTran`,`NumeroFila`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT 'TMP: Tabla temporal para identificar los depositos referenciados que si se aplciaran'$$
