-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOXSUCURSAL
DELIMITER ;
DROP TABLE IF EXISTS `SEGTOXSUCURSAL`;DELIMITER $$

CREATE TABLE `SEGTOXSUCURSAL` (
  `SeguimientoID` int(11) NOT NULL COMMENT 'Identificador del Seguimiento ',
  `SucursalID` int(11) NOT NULL COMMENT 'Identificador de Sucursal al que se le aplica el seguimiento   ',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`SeguimientoID`,`SucursalID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Sucursales a las que aplica cada Seguimiento'$$