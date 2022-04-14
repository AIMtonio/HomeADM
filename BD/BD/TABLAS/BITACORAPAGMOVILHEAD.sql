-- BITACORAPAGMOVILHEAD
DELIMITER ;
DROP TABLE IF EXISTS `BITACORAPAGMOVILHEAD`;
DELIMITER $$

CREATE TABLE `BITACORAPAGMOVILHEAD` (
  `RegistroID`         BIGINT(20)      UNSIGNED     NOT NULL AUTO_INCREMENT   COMMENT 'Numero del Registro',
  `DispositivoID`      VARCHAR(32)                  NOT NULL                  COMMENT 'Identificador del dispositivo',
  `Fecha`              DATETIME                     NOT NULL                  COMMENT 'Parametro de auditoria',
  `ClaveProm`          VARCHAR(45)                  NOT NULL                  COMMENT 'Numero del promotor',
  `EmpresaID`          INT(11)                      NOT NULL                  COMMENT 'Parametro de auditoria',
  `Usuario`            INT(11)                      NOT NULL                  COMMENT 'Parametro de auditoria',
  `FechaActual`        DATETIME                     NOT NULL                  COMMENT 'Parametro de auditoria',
  `DireccionIP`        VARCHAR(15)                  NOT NULL                  COMMENT 'Parametro de auditoria',
  `ProgramaID`         VARCHAR(50)                  NOT NULL                  COMMENT 'Parametro de auditoria',
  `Sucursal`           INT(11)                      NOT NULL                  COMMENT 'Parametro de auditoria',
  `NumTransaccion`     BIGINT(20)                   NOT NULL                  COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`RegistroID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cat: Guarda la bitacora de General de la app movil'$$