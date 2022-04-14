-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOVIVIENDA
DELIMITER ;
DROP TABLE IF EXISTS `TIPOVIVIENDA`;DELIMITER $$

CREATE TABLE `TIPOVIVIENDA` (
  `TipoViviendaID` int(11) NOT NULL COMMENT 'Llave primaria para Catalogo de Tipos de Vivienda',
  `Descripcion` varchar(50) DEFAULT NULL COMMENT 'Descripcion  del Tipo de Vivienda',
  `Puntos` int(11) DEFAULT NULL COMMENT 'indica los puntos que le corresponde a cada tipo de Vivienda para el Calculo del ratios',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de auditoria',
  PRIMARY KEY (`TipoViviendaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo para el Tipo de Vivineda'$$