-- SERVICIOSXEMPRESA
DELIMITER ;
DROP TABLE IF EXISTS `SERVICIOSXEMPRESA`;

DELIMITER $$

CREATE TABLE `SERVICIOSXEMPRESA` (
  `ServicioID` INT(11) NOT NULL COMMENT 'Numero de Serivicio Adicional',
  `InstitNominaID` INT(11) NOT NULL COMMENT 'Empresa de nomina',
  `EmpresaID` INT(11) NULL DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` INT(11) NULL DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` DATETIME NULL DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` VARCHAR(15) NULL DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` VARCHAR(50) NULL DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` INT(11) NULL DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` BIGINT(20) NULL DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`ServicioID`, `InstitNominaID`),
  CONSTRAINT `FK_SERVICIOSXEMPRESA_1` FOREIGN KEY (`ServicioID`) REFERENCES `SERVICIOSADICIONALES` (`ServicioID`) ON DELETE NO ACTION ON UPDATE NO ACTION
)ENGINE = InnoDB DEFAULT CHARSET=latin1 COMMENT = 'Tab: Tabla que almacena los servicios adicionales que puede tener una empresa de nomina'$$