-- Creacion de tabla FOLIOSCUENTASCLABES

DELIMITER ;

DROP TABLE IF EXISTS `FOLIOSCUENTASCLABES`;

CREATE TABLE `FOLIOSCUENTASCLABES`(
  `FolioClabeID`    INT(11)       NOT NULL    COMMENT 'Folio o consecutivo',
  PRIMARY KEY(FolioClabeID)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para almacenar los folios de las cuentas clabes.';