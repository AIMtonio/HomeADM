-- LLAVEPRIVADATARJETAS
DELIMITER ;
DROP TABLE IF EXISTS `LLAVEPRIVADATARJETAS`;
DELIMITER $$


CREATE TABLE `LLAVEPRIVADATARJETAS` (
  `LlavePrivadaTarjetaID` INT(11) NOT NULL COMMENT 'Numero o id de llave privada de tarjetas',
  `NombreLlave`	VARCHAR(100) NOT NULL	COMMENT 'Nombre de la llave privada',
  `Descripcion`	VARCHAR(150) NOT NULL COMMENT 'Descripcion de la llave privada',
  `RutaLlave`	VARCHAR(100) NOT NULL COMMENT 'Ruta del propertis de la llave privada',
  `NombreVariableKey` VARCHAR(50) NOT NULL COMMENT 'Nombre de la variable para la llave',
  `NombreVariableTweak` VARCHAR(50) NOT NULL COMMENT '',
  `EmpresaID` INT(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `Usuario` INT(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `FechaActual` DATETIME DEFAULT NULL COMMENT 'Campo de auditoria',
  `DireccionIP` VARCHAR(15) DEFAULT NULL COMMENT 'Campo de auditoria',
  `ProgramaID` VARCHAR(50) DEFAULT NULL COMMENT 'Campo de auditoria',
  `Sucursal` INT(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `NumTransaccion` BIGINT(20) DEFAULT NULL COMMENT 'Campo de auditoria',
  PRIMARY KEY (`LlavePrivadaTarjetaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para guardar las llaves privadas de las tajetas'$$
