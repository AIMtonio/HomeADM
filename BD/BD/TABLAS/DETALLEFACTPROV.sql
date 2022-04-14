-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEFACTPROV
DELIMITER ;
DROP TABLE IF EXISTS `DETALLEFACTPROV`;DELIMITER $$

CREATE TABLE `DETALLEFACTPROV` (
  `ProveedorID` int(11) NOT NULL COMMENT 'Numero de proveedor de la factura',
  `NoFactura` varchar(20) NOT NULL COMMENT 'Numero de factura entregada por el proveedor',
  `NoPartidaID` int(11) NOT NULL DEFAULT '0' COMMENT 'Numero de partida del proveedor',
  `TipoGastoID` int(11) DEFAULT NULL COMMENT 'Tipo de gasto de la partida, el tipo de gasto define la contabilizacion',
  `Cantidad` decimal(13,2) DEFAULT NULL COMMENT 'Cantidad de la partida',
  `PrecioUnitario` decimal(13,2) DEFAULT NULL COMMENT 'PrecioUnitario',
  `Importe` decimal(13,2) DEFAULT NULL COMMENT 'Cantidad por Precio Unitario no editable',
  `Descripcion` varchar(50) DEFAULT NULL COMMENT 'Descripcion de la partida',
  `Gravable` char(1) DEFAULT NULL COMMENT 'Si tiene S si cuenta para campo TotalGravable, si no no\\nS=SI\\nN=NO',
  `GravaCero` char(1) DEFAULT NULL COMMENT 'Si el campo tiene S, Significa que si grava al 0%\\nSi el campo tiene N, significa que grava el iva normalmente',
  `CentroCostoID` int(11) DEFAULT NULL COMMENT 'Centro de Costos ',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'ID de Instituciones de Fondeo',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Usuario que Registro el Movimiento',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Fecha de Sistema con Hora',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Direccion de IP de la Maquina que realizo el Registro',
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Sucursal que realizo el registro',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Numero Unico de Transaccion del Movimiento Registrado',
  PRIMARY KEY (`ProveedorID`,`NoFactura`,`NoPartidaID`),
  KEY `fk_DETALLEFACTPROV_1_idx` (`ProveedorID`),
  CONSTRAINT `fk_DETALLEFACTPROV_1` FOREIGN KEY (`ProveedorID`, `NoFactura`) REFERENCES `FACTURAPROV` (`ProveedorID`, `NoFactura`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Detalla de las facturas de proveedores.'$$