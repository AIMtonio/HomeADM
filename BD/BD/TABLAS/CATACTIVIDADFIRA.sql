-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATACTIVIDADFIRA
DELIMITER ;
DROP TABLE IF EXISTS `CATACTIVIDADFIRA`;DELIMITER $$

CREATE TABLE `CATACTIVIDADFIRA` (
  `CveActividadFIRA` int(11) NOT NULL COMMENT 'Clave de Actividad FIRA',
  `DesActividadFIRA` varchar(45) DEFAULT NULL COMMENT 'Descripción de Actividad FIRA',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  PRIMARY KEY (`CveActividadFIRA`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Actividades FIRA'$$