-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAORDENPRODUCTOS
DELIMITER ;
DROP TABLE IF EXISTS `EDOCTAORDENPRODUCTOS`;DELIMITER $$

CREATE TABLE `EDOCTAORDENPRODUCTOS` (
  `ProductoID` int(11) NOT NULL COMMENT 'Identificador del producto de ahorro, credito, inversion o CEDE (TIPOSCUENTAS, PRODUCTOSCREDITO, CATINVERSION o TIPOSCEDES)',
  `TipoProducto` char(1) NOT NULL COMMENT 'Corresponde al tipo de producto que puede ser de Ahorro (A), Credito (C), Inversion (I) o CEDE (E)',
  `Orden` int(11) NOT NULL COMMENT 'Orden en el cual se mostraran los productos en el estado de cuenta',
  `EmpresaID` int(11) NOT NULL COMMENT 'Campo de auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Campo de auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Campo de auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Campo de auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Campo de auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Campo de auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Campo de auditoria',
  PRIMARY KEY (`ProductoID`,`TipoProducto`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para registrar el orden en el cual se mostraran los productos en el estado de cuenta'$$