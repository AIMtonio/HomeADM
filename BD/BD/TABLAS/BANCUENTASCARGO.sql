-- BANCUENTASCARGO

DELIMITER ;

DROP TABLE IF EXISTS `BANCUENTASCARGO`;

DELIMITER $$

CREATE TABLE `BANCUENTASCARGO` (
  `CuentaAhoID` BIGINT(12) NOT NULL COMMENT 'ID de la cuenta de ahorro.',
  `ClienteID` INT(11) NOT NULL DEFAULT '1' COMMENT 'ID del cliente',
  `TipoCta` INT(11) NOT NULL COMMENT 'Campo de tipo de cuenta.',
  `Estatus` CHAR(1) NOT NULL COMMENT 'Campo de estatus de la cuenta cargo',
  `Origen` CHAR(1) NOT NULL COMMENT 'Campor de origen',
  `EmpresaID` INT(11) NOT NULL DEFAULT '1' COMMENT 'Auditoria.',
  `Usuario` INT(11) NOT NULL DEFAULT '1' COMMENT 'Auditoria.',
  `FechaActual` DATETIME NOT NULL DEFAULT '1900-01-01 00:00:00' COMMENT 'Auditoria.',
  `DireccionIP` VARCHAR(15) NOT NULL DEFAULT '' COMMENT 'Auditoria.',
  `ProgramaID` VARCHAR(50) NOT NULL DEFAULT '' COMMENT 'Auditoria.',
  `Sucursal` INT(11) NOT NULL DEFAULT '1' COMMENT 'Auditoria.',
  `NumTransaccion` BIGINT(20) NOT NULL DEFAULT '1' COMMENT 'Auditoria.',
  PRIMARY KEY (`CuentaAhoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de cuentas cargos.';
