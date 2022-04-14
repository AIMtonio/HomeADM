-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOPRODXSEGTO
DELIMITER ;
DROP TABLE IF EXISTS `SEGTOPRODXSEGTO`;DELIMITER $$

CREATE TABLE `SEGTOPRODXSEGTO` (
  `SeguimientoID` int(11) NOT NULL COMMENT 'PK Compuesta de Seguimiento por Producto',
  `ProductoID` int(11) NOT NULL COMMENT 'PK Compuesta de Seguimiento por Producto',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` date DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`SeguimientoID`,`ProductoID`),
  KEY `fk_SEGTOPRODXSEGTO_1` (`SeguimientoID`),
  CONSTRAINT `fk_SEGTOPRODXSEGTO_1` FOREIGN KEY (`SeguimientoID`) REFERENCES `SEGUIMIENTOCAMPO` (`SeguimientoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Productos a los que aplica cada Segto ID'$$