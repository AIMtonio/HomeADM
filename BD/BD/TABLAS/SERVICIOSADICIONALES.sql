-- SERVICIOSADICIONALES
DELIMITER ;
DROP TABLE IF EXISTS `SERVICIOSADICIONALES`;

DELIMITER $$

CREATE TABLE `SERVICIOSADICIONALES` (
  `ServicioID` INT(11) NOT NULL COMMENT 'Número de Servicio',
  `Descripcion` VARCHAR(100) NOT NULL COMMENT 'Descripción del servicio',
  `ValidaDocs` CHAR(1) NULL COMMENT 'Indicacion para validar documentos',
  `TipoDocumento` INT(11) NULL COMMENT 'Tipo de Documento',
  `Estatus` CHAR(1) DEFAULT 'A' COMMENT 'Estatus de la solicitud A - Activo, I - Inactivo',
  `EmpresaID` INT(11) NULL DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` INT(11) NULL DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` DATETIME NULL DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` VARCHAR(15) NULL DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` VARCHAR(50) NULL DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` INT(11) NULL DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` BIGINT(20) NULL DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`ServicioID`)
) ENGINE = InnoDB DEFAULT CHARSET=latin1 COMMENT = 'Tab: Tabla que almacena los servicios adicionales que puede tener un convenio'$$