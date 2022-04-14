-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATREPFIRARIESGOCRED
DELIMITER ;
DROP TABLE IF EXISTS `CATREPFIRARIESGOCRED`;DELIMITER $$

CREATE TABLE `CATREPFIRARIESGOCRED` (
  `Numero` int(11) NOT NULL COMMENT 'Numero de cap',
  `GrupoID` varchar(50) NOT NULL COMMENT 'Grupo ID',
  `Concepto` varchar(150) NOT NULL COMMENT 'Descripcion del concepto',
  `OperFonFira` decimal(18,2) DEFAULT NULL COMMENT 'OPERACIONES FONDEO FIRA',
  `OperOtrasFuen` decimal(18,2) DEFAULT NULL COMMENT 'OPERACIONES OTRAS FUENTES DE FONDEO',
  `OperNoLegibles` decimal(18,2) DEFAULT NULL COMMENT 'OPERACIONES NO ELEGIBLES FIRA',
  `EmpresaID` int(11) DEFAULT '1' COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT '1' COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT '127.0.0.1' COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT 'WORKBENCH' COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT '1' COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT '1' COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`Numero`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo del Reporte de Riesgo de Credito'$$