-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PRODUCTOARRENDA
DELIMITER ;
DROP TABLE IF EXISTS `PRODUCTOARRENDA`;DELIMITER $$

CREATE TABLE `PRODUCTOARRENDA` (
  `ProductoArrendaID` int(4) NOT NULL COMMENT 'ID del Producto de Arrendamiento',
  `NombreCorto` varchar(30) DEFAULT NULL COMMENT 'Nombre corto del producto o nombre por el cual se le conoce',
  `Descripcion` varchar(100) DEFAULT NULL COMMENT 'descripcion del Producto',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ProductoArrendaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para productos de arrendamiento '$$