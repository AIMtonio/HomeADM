-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATFIRACAPNETO
DELIMITER ;
DROP TABLE IF EXISTS `CATFIRACAPNETO`;DELIMITER $$

CREATE TABLE `CATFIRACAPNETO` (
  `GrupoID` int(11) NOT NULL COMMENT 'Numero de Grupo',
  `Grupo` varchar(45) NOT NULL COMMENT 'Descripcion Grupo',
  `Concepto` varchar(200) NOT NULL COMMENT 'Descripcion del Concepto',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`GrupoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='CAT: Grupos para el reporte de Riesgo de Mercado FIRA'$$