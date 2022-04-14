-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PUESTOSRELACIONADO
DELIMITER ;
DROP TABLE IF EXISTS `PUESTOSRELACIONADO`;DELIMITER $$

CREATE TABLE `PUESTOSRELACIONADO` (
  `PuestoRelID` int(11) NOT NULL COMMENT 'Consecutivo',
  `Descripcion` varchar(50) NOT NULL COMMENT 'Descripcion del Puesto',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria',
  PRIMARY KEY (`PuestoRelID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Puestos de Relacionados de Empleados(Se utiliza en la pantalla Relacionados de Empleados)'$$