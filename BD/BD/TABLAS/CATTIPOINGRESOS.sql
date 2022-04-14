-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATTIPOINGRESOS
DELIMITER ;
DROP TABLE IF EXISTS `CATTIPOINGRESOS`;DELIMITER $$

CREATE TABLE `CATTIPOINGRESOS` (
  `Numero` int(11) NOT NULL COMMENT 'Consecutivo',
  `Tipo` char(1) NOT NULL COMMENT 'Tipo \nI: Ingreso\n',
  `Descripcion` varchar(100) NOT NULL COMMENT 'Descripcion del Ingreso',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus del Ingreso\nA: Activo\nI: Inactivo',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria',
  PRIMARY KEY (`Numero`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$