-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATSUBACTIVIDADFIRA
DELIMITER ;
DROP TABLE IF EXISTS `CATSUBACTIVIDADFIRA`;DELIMITER $$

CREATE TABLE `CATSUBACTIVIDADFIRA` (
  `CveActividadFIRA` int(11) NOT NULL COMMENT 'Clave de la Actividad (CATACTIVIDADFIRA)',
  `CveSubactividadFIRA` int(11) NOT NULL COMMENT 'Clave de la SubActividad',
  `DescSubactividad` varchar(20) NOT NULL COMMENT 'Descripcion de la Sub Actividad',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  PRIMARY KEY (`CveActividadFIRA`,`CveSubactividadFIRA`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Sub Actividades FIRA'$$