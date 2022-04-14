-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOMATERIALVIV
DELIMITER ;
DROP TABLE IF EXISTS `TIPOMATERIALVIV`;DELIMITER $$

CREATE TABLE `TIPOMATERIALVIV` (
  `TipoMaterialID` int(11) NOT NULL COMMENT 'Llave primaria para Catalogo de Tipo de Material de Construccion de la Vivienda',
  `Descripcion` varchar(50) DEFAULT NULL COMMENT 'Descripcion  del Tipo de Vivienda',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de auditoria',
  PRIMARY KEY (`TipoMaterialID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo para el Tipo de Material de construccion de la Vivi'$$