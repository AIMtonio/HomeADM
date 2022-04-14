-- Creacion de tabla FOLIOSAPORTACIONES

DELIMITER ;

DROP TABLE IF EXISTS `FOLIOSAPORTACIONES`;

CREATE TABLE `FOLIOSAPORTACIONES`(
  `FolioClabeID`    INT(11)       NOT NULL    COMMENT 'Folio o consecutivo',
  PRIMARY KEY(FolioClabeID)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para almacenar los folios de Aportaciones.';