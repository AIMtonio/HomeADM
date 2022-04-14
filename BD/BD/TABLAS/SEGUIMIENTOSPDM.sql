DELIMITER ;
DROP TABLE IF EXISTS `SEGUIMIENTOSPDM`;
DELIMITER $$
CREATE TABLE `SEGUIMIENTOSPDM` (
  `SeguimientoID` INT(11) NOT NULL COMMENT 'Identificador de la tabla',
  `ClienteID` INT(11) NULL COMMENT 'Identificador del cliente al que se le dara el seguimiento',
  `Telefono` VARCHAR(20) NULL COMMENT 'Telefono con el que se identifico para el seguimiento',
  `TipoSoporteID` INT(11) NULL COMMENT 'Tipo de soporte que se le proporcionara',
  `UsuarioRegistra` INT(11) NULL COMMENT 'Usuario que da de alta el folio',
  `UsuarioFinaliza` INT(11) NULL COMMENT 'Usuario que finaliza el seguimiento',
  `UsuarioCancela` INT(11) NULL COMMENT 'Usuario que calcela el seguimiento',
  `FechaRegistra` DATETIME NULL COMMENT 'Fecha de alta del folio',
  `FechaFinaliza` DATETIME NULL COMMENT 'Fecha en que se finaliza el seguimiento',
  `FechaCancela` DATETIME NULL COMMENT 'Fecha en que se cancela el seguimiento',
  `Estatus` VARCHAR(45) NULL COMMENT 'Estatus del seguimiento \nP = En proceso\nC = Cancelado\nR = Resuelto ',
  `EmpresaID` INT(11) NULL DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` INT(11) NULL DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` DATETIME NULL DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` VARCHAR(20) NULL DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` VARCHAR(50) NULL DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` INT(11) NULL DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` BIGINT(20) NULL DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`SeguimientoID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Tab: Para el registro de los folios que se generaran en la verificacion de preguntas'$$
