-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMTABLAREAL
DELIMITER ;
DROP TABLE IF EXISTS `PARAMTABLAREAL`;
DELIMITER $$

CREATE TABLE `PARAMTABLAREAL` (
  `NumRegistro` INT(11) NOT NULL COMMENT 'ID de la institucion de nomina',
  `EmpresaNominaID` INT(11) NOT NULL COMMENT 'ID de la institucion de nomina',
  `ProductoCreditoID` INT(11) NOT NULL COMMENT 'ID producto de credito',
  `NumDias` INT(11) NOT NULL COMMENT 'Numero de dias permitidos para crear tabla real',
  `EmpresaID` INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` DATETIME DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` VARCHAR(15) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` VARCHAR(50) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` BIGINT(20) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`NumRegistro`),
  KEY `fk_NumRegistro_1_idx` (`NumRegistro`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla de parametros para tabla real'$$