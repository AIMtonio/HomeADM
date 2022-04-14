-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPNUMEMPSUCURSAL
DELIMITER ;
DROP TABLE IF EXISTS `TMPNUMEMPSUCURSAL`;DELIMITER $$

CREATE TABLE `TMPNUMEMPSUCURSAL` (
  `Anio` int(11) NOT NULL DEFAULT '0' COMMENT 'Anio del registro',
  `Periodo` int(11) NOT NULL DEFAULT '0' COMMENT 'Periodo en el que esta el empleado',
  `SucursalID` int(11) NOT NULL DEFAULT '0' COMMENT 'Sucursal del que se realiza el conteo de empleados',
  `PersonalInterno` int(11) DEFAULT NULL COMMENT 'Numero de Empleados en el SAFI para la sucursal',
  `PersonalExterno` int(11) DEFAULT NULL COMMENT 'Numero de Empleados que no estan registrados en el SAFI',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Paramentro de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Paramentro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Paramentro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Paramentro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Paramentro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Paramentro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Paramentro de auditoria',
  PRIMARY KEY (`Anio`,`Periodo`,`SucursalID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla donde se almacenan el numero de empleados contrados por sucursal capturados de forma manual.'$$