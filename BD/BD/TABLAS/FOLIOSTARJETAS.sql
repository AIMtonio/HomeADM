-- Creacion de tabla FOLIOSTARJETA
DELIMITER ;

DROP TABLE IF EXISTS `FOLIOSTARJETA`;

CREATE TABLE `FOLIOSTARJETA`(
  `FolioTarjetaID`		BIGINT(12)     	NOT NULL    COMMENT 'Folio o consecutivo',
  `BINCompleto`			CHAR(8)			NOT NULL	COMMENT 'Valor del BIN completo',
  PRIMARY KEY(FolioTarjetaID)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para almacenar los folios de las tarejatas.';