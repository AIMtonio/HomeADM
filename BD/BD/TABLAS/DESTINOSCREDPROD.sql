-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DESTINOSCREDPROD
DELIMITER ;
DROP TABLE IF EXISTS `DESTINOSCREDPROD`;DELIMITER $$

CREATE TABLE `DESTINOSCREDPROD` (
  `ProductoCreditoID` int(11) NOT NULL DEFAULT '0',
  `DestinoCreID` int(11) NOT NULL DEFAULT '0',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ProductoCreditoID`,`DestinoCreID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para Almacenar Destinos de Credito por Producto'$$