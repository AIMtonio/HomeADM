-- CATMARCATARJETA
DELIMITER ;
DROP TABLE IF EXISTS `CATMARCATARJETA`;
DELIMITER $$

CREATE TABLE `CATMARCATARJETA` (
  `CatMarcaTarjetaID`   INT(11)       NOT NULL COMMENT 'Identificador de la tabla',
  `Clabe`               CHAR(3)       NOT NULL COMMENT 'Clabe de la tarjeta',
  `Descripcion`         VARCHAR(150)  NOT NULL COMMENT 'Descripción de la tarjeta',
  `EmpresaID`           INT(11)       NOT NULL COMMENT 'Parametros de Auditoria',
  `Usuario`             INT(11)       NOT NULL COMMENT 'Parametros de Auditoria',
  `FechaActual`         DATETIME      NOT NULL COMMENT 'Parametros de Auditoria',
  `DireccionIP`         VARCHAR(15)   NOT NULL COMMENT 'Parametros de Auditoria',
  `ProgramaID`          VARCHAR(50)   NOT NULL COMMENT 'Parametros de Auditoria',
  `Sucursal`            INT(11)       NOT NULL COMMENT 'Parametros de Auditoria',
  `NumTransaccion`      BIGINT(20)    NOT NULL COMMENT 'Parametros de Auditoria',
  PRIMARY KEY (`CatMarcaTarjetaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de taejetas para maquina en SAFI'$$