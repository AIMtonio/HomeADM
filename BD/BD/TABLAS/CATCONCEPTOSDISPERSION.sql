-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATCONCEPTOSDISPERSION
DELIMITER ;
DROP TABLE IF EXISTS `CATCONCEPTOSDISPERSION`;
DELIMITER $$

CREATE TABLE `CATCONCEPTOSDISPERSION` (
  `ConceptoDispersionID` INT(11) NOT NULL COMMENT 'ID de Catalogo de Conceptos de Dispersion.',
  `NombreConcepto` VARCHAR(100) NOT NULL COMMENT 'Nombre del Conceptos de Dispersion.',
  `Descripcion` VARCHAR(200) NOT NULL COMMENT 'Descripcion del Conceptos de Dispersion.',
  `Estatus` CHAR(1) NULL DEFAULT 'I' COMMENT 'Estatus del Conceptos de Dispersion.\nA: Activo\nI: Inactivo',
  `EmpresaID` INT(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` INT(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` DATETIME DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` VARCHAR(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` VARCHAR(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` INT(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` BIGINT(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`ConceptoDispersionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='CAT: Catalogo de Conceptos de Dispersion'$$