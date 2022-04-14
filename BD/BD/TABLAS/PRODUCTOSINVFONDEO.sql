-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PRODUCTOSINVFONDEO
DELIMITER ;
DROP TABLE IF EXISTS `PRODUCTOSINVFONDEO`;DELIMITER $$

CREATE TABLE `PRODUCTOSINVFONDEO` (
  `ProdInvKuboID` int(11) NOT NULL COMMENT 'ID o Numero Unico del Producto de Inv. Fondeo\n',
  `Descripcion` varchar(150) NOT NULL COMMENT 'Descripcion del Producto',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus del Producto de Inv.\nA .- Activo\nI .- Inactivo\nC .- Cancelado',
  `Empresa` int(11) DEFAULT NULL COMMENT 'Id de la Empresa',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Usuario',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Fecha de Registro',
  `DireccionIP` varchar(20) DEFAULT NULL COMMENT 'Direccion IP',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Programa',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Sucursal',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Numero de Transaccion',
  PRIMARY KEY (`ProdInvKuboID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Productos del Modelo de Inversionistas FONDEO'$$