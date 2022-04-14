-- SERVICIOSXPRODUCTO
DELIMITER ;
DROP TABLE IF EXISTS `SERVICIOSXPRODUCTO`;

DELIMITER $$

CREATE TABLE `SERVICIOSXPRODUCTO` (
  `ServicioID` INT(11) NOT NULL COMMENT 'Numero de Servicio Adicional',
  `ProducCreditoID` INT(11) NOT NULL COMMENT 'Numero de Tipo de Producto',
  `EmpresaID` INT(11) NULL DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` INT(11) NULL DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` DATETIME NULL DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` VARCHAR(15) NULL DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` VARCHAR(50) NULL DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` INT(11) NULL DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` BIGINT(20) NULL DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`ServicioID`, `ProducCreditoID`),
  CONSTRAINT `FK_SERVICIOSXPRODUCTO_1` FOREIGN KEY (`ServicioID`) REFERENCES `SERVICIOSADICIONALES` (`ServicioID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB DEFAULT CHARSET=latin1 COMMENT = 'Tab:Tabla que indica que servicios tiene una Empresa de Nomina'$$