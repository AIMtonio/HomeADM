-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PRESUCURENC
DELIMITER ;
DROP TABLE IF EXISTS `PRESUCURENC`;DELIMITER $$

CREATE TABLE `PRESUCURENC` (
  `FolioID` int(11) DEFAULT NULL COMMENT 'Folio ID del presupuesto',
  `MesPresupuesto` int(2) NOT NULL COMMENT 'Mes del\npresupuesto',
  `AnioPresupuesto` int(4) NOT NULL COMMENT 'año del \npresupuesto',
  `UsuarioElaboro` varchar(11) DEFAULT NULL COMMENT 'Usuario que elaboro el presupuesto',
  `SucursalOrigen` varchar(11) NOT NULL COMMENT 'Sucursal a la que se le valora el presupuesto',
  `Fecha` date DEFAULT NULL,
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus de \npresupuesto\nP=Pendiente\nC= Cerrado',
  `EmpresaID` varchar(11) DEFAULT NULL,
  `Usuario` varchar(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`MesPresupuesto`,`AnioPresupuesto`,`SucursalOrigen`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Encabezado del Presupuesto por sucursal'$$