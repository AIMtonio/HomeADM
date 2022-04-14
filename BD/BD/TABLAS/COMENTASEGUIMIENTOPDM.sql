DELIMITER ;
DROP TABLE IF EXISTS `COMENTASEGUIMIENTOPDM`;
DELIMITER $$
CREATE TABLE `COMENTASEGUIMIENTOPDM` (
  `SeguimientoID` INT NOT NULL COMMENT 'Identificador de la tabla SEGUIMIENTOSPDM y campo para la llave primaria de esta tabla',
  `ConsecutivoID` INT(11) NOT NULL COMMENT 'Valor consecutivo para los comentarios guardados y campo para llave primaria de esta tabla',
  `ComentarioUsuario` VARCHAR(200) NULL COMMENT 'Comentario realizado por el usuario que atinde el folio',
  `ComentarioCliente` VARCHAR(200) NULL COMMENT 'Comentario del Cliente',
  `EmpresaID` INT(11) NULL DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` INT(11) NULL DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` DATETIME NULL DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` VARCHAR(20) NULL DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` VARCHAR(50) NULL DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` INT(11) NULL DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` BIGINT(20) NULL DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY(SeguimientoID,ConsecutivoID),
  FOREIGN KEY (SeguimientoID) REFERENCES SEGUIMIENTOSPDM(SeguimientoID))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'TAB: detalles de los comentarios realizados por el cliente y el usuario'$$
