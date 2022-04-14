-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATPASIVOSFONDEOAGRO
DELIMITER ;
DROP TABLE IF EXISTS `CATPASIVOSFONDEOAGRO`;
DELIMITER $$

CREATE TABLE `CATPASIVOSFONDEOAGRO` (
  `TipoID` int(11) NOT NULL COMMENT 'Tipo ID',
  `Tipo` varchar(100) NOT NULL COMMENT 'Descripcion del Pasivo',
  `Secuencial` varchar(45) DEFAULT NULL COMMENT 'Numero de Orden',
  `InstitutFondID` int(11) DEFAULT NULL COMMENT 'ID de Instituciones de Fondeo',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`TipoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='CAT: Catalogo de Pasivos de Fondeo para el Reporte Pasivos de Fondeo.'$$