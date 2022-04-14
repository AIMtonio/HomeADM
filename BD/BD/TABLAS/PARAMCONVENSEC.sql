-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMCONVENSEC
DELIMITER ;
DROP TABLE IF EXISTS `PARAMCONVENSEC`;DELIMITER $$

CREATE TABLE `PARAMCONVENSEC` (
  `ConvenSecID` bigint(20) NOT NULL COMMENT 'ID de los parametros de las convenciones seccionales',
  `SucursalID` int(11) NOT NULL COMMENT 'ID de la sucursal',
  `Fecha` date NOT NULL COMMENT 'Fecha de la convencion seccional',
  `CantSocio` int(11) NOT NULL COMMENT 'Cantidad de socios',
  `EsGral` char(1) NOT NULL COMMENT 'Si la asamblea es gral. o no',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`ConvenSecID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que almacena las fechas de las Convenciones seccionales.'$$