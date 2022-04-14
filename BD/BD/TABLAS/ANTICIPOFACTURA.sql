-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ANTICIPOFACTURA
DELIMITER ;
DROP TABLE IF EXISTS `ANTICIPOFACTURA`;DELIMITER $$

CREATE TABLE `ANTICIPOFACTURA` (
  `AnticipoFactID` int(11) NOT NULL COMMENT 'Consecutivo de tabla anticipos por factura',
  `ProveedorID` int(11) DEFAULT NULL COMMENT 'Proveedor de la factura',
  `NoFactura` varchar(20) DEFAULT NULL COMMENT 'Numero de factura',
  `ClaveDispMov` int(11) DEFAULT '0',
  `FechaAnticipo` date DEFAULT NULL COMMENT 'Fecha del Anticipo',
  `EstatusAnticipo` char(1) DEFAULT NULL COMMENT 'Estatus del Anticipo\nR .- Registrado (se usa al grabar )\nP .- Pagado (cuando se dispersa)\nC .- Cancelado ',
  `FormaPago` char(1) DEFAULT NULL COMMENT 'Forma Pago\nC .-Cheque\nS .-Spei\nB .-Banca Electrónica\nT .-Tarjeta Empresarial',
  `MontoAnticipo` decimal(12,2) DEFAULT NULL COMMENT 'Monto del anticipo',
  `TotalFactura` decimal(12,2) DEFAULT NULL COMMENT 'Total de la factura',
  `SaldoFactura` decimal(12,2) DEFAULT NULL COMMENT 'Saldo de la factura',
  `FechaCancela` date DEFAULT NULL COMMENT 'Fecha en que el anticipo fue cancelado o pagado',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`AnticipoFactID`),
  KEY `fk_ANTICIPOFACTURA_1_idx` (`ProveedorID`,`NoFactura`),
  CONSTRAINT `fk_ANTICIPOFACTURA_1` FOREIGN KEY (`ProveedorID`, `NoFactura`) REFERENCES `FACTURAPROV` (`ProveedorID`, `NoFactura`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla en la que se guardan los anticipos de facturas'$$