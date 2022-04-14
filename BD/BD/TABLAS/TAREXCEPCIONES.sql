-- TAREXCEPCIONES
DELIMITER ;
DROP TABLE IF EXISTS `TAREXCEPCIONES`;
DELIMITER $$

CREATE TABLE `TAREXCEPCIONES` (
  `TarExcepcionesId`    INT(11)       NOT NULL COMMENT 'LLave primaria de la tabla',
  `NumTarExcep`         VARCHAR(16)   NOT NULL COMMENT 'Número de la tarjeta no se puden ocupar',
  `MotivoExcep`         VARCHAR(500)  NOT NULL COMMENT 'Motivo por la cual se registro la excepxión',
  `EmpresaID`           INT(11)       DEFAULT NULL COMMENT 'Parametro auditoria',
  `Usuario`             INT(11)       DEFAULT NULL COMMENT 'Parametro auditoria',
  `FechaActual`         DATETIME      DEFAULT NULL COMMENT 'Parametro auditoria',
  `DireccionIP`         VARCHAR(15)   DEFAULT NULL COMMENT 'Parametro auditoria',
  `ProgramaID`          VARCHAR(50)   DEFAULT NULL COMMENT 'Parametro auditoria',
  `Sucursal`            INT(11)       DEFAULT NULL COMMENT 'Parametro auditoria',
  `NumTransaccion`      BIGINT(20)    DEFAULT NULL COMMENT 'Parametro auditoria',
  PRIMARY KEY (`TarExcepcionesId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de registro de tarjetas que no se pueden ocupar'$$