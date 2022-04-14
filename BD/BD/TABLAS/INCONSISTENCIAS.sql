-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INCONSISTENCIAS
DELIMITER ;
DROP TABLE IF EXISTS `INCONSISTENCIAS`;DELIMITER $$

CREATE TABLE `INCONSISTENCIAS` (
  `ClienteID` int(11) DEFAULT '0' COMMENT 'Identificador del Cliente',
  `ProspectoID` bigint(20) DEFAULT '0' COMMENT 'Identificador del Prospecto',
  `AvalID` bigint(20) DEFAULT '0' COMMENT 'Idenficador del Aval',
  `GaranteID` int(11) DEFAULT '0' COMMENT 'Identificador del Garante',
  `NombreCompleto` varchar(200) DEFAULT '' COMMENT 'Inconsistencia del Nombre',
  `Comentario` varchar(200) DEFAULT '' COMMENT 'Comentario acerca de la inconsistencia registrada',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  KEY `INDEX_INCONSISTENCIAS_4` (`GaranteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla de Inconsistencias en los nombres de Cliente, Prospecto Aval o Garante'$$