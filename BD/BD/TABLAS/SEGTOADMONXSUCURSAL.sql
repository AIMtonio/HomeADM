-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOADMONXSUCURSAL
DELIMITER ;
DROP TABLE IF EXISTS `SEGTOADMONXSUCURSAL`;DELIMITER $$

CREATE TABLE `SEGTOADMONXSUCURSAL` (
  `GestorID` int(11) NOT NULL COMMENT 'Id del Gestor al que se le asignara un Ambito',
  `TipoGestionID` int(11) NOT NULL COMMENT 'Tipo de Gestor al que pertenece el Ambito',
  `SucursalID` int(11) NOT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`GestorID`,`TipoGestionID`,`SucursalID`),
  KEY `fk_SEGTOADMONXSUCURSAL_1_idx` (`GestorID`),
  KEY `fk_SEGTOADMONXSUCURSAL_2_idx` (`TipoGestionID`),
  KEY `fk_SEGTOADMONXSUCURSAL_3_idx` (`SucursalID`),
  CONSTRAINT `fk_SEGTOADMONXSUCURSAL_1` FOREIGN KEY (`TipoGestionID`) REFERENCES `TIPOGESTION` (`TipoGestionID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_SEGTOADMONXSUCURSAL_3` FOREIGN KEY (`SucursalID`) REFERENCES `SUCURSALES` (`SucursalID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para almacenar informacion de \nGestores que atienden Seguimientos por Sucursal'$$