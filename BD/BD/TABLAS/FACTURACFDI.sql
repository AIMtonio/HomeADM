-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FACTURACFDI
DELIMITER ;
DROP TABLE IF EXISTS `FACTURACFDI`;
DELIMITER $$


CREATE TABLE `FACTURACFDI` (
  `FacturaID` int(11) NOT NULL,
  `FolioFactura` varchar(40) DEFAULT NULL COMMENT 'Folio consecutivo interno para control de Facturas',
  `FechaEmision` datetime DEFAULT NULL COMMENT 'Fecha de Emision de la Factura',
  `RFCEmisor` varchar(20) DEFAULT NULL COMMENT 'RFC del Emisor de la Factura',
  `RazonSocialEmisor` varchar(150) DEFAULT NULL COMMENT 'Razon social del emisor',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Identficador del Cliente\n',
  `RFCReceptor` varchar(20) DEFAULT NULL COMMENT 'RFC del Receptor de la Factura',
  `RazonSocialReceptor` varchar(150) DEFAULT NULL COMMENT 'Razon Social del Receptor de la Factura',
  `FolioFiscal` varchar(500) DEFAULT NULL COMMENT 'Folio Fiscal o UUID del CFDI',
  `SerieFact` varchar(15) DEFAULT NULL COMMENT 'Serie de la Factura',
  `SubTotalFac` decimal(12,2) DEFAULT NULL COMMENT 'Subtotal de la Factura\n',
  `DescuentoFact` decimal(12,2) DEFAULT NULL COMMENT 'Descuento Factura',
  `TotalFactura` decimal(12,2) DEFAULT NULL COMMENT 'Monto total de la Factura',
  `FechaCancelacion` datetime DEFAULT NULL COMMENT 'Fecha de Cancelacion de la Factura',
  `UsuarioCancelacion` int(11) DEFAULT NULL COMMENT 'Identificador del Usuario que cancelo la Factura',
  `MotivoCancelacion` varchar(200) DEFAULT NULL COMMENT 'Motivo por el cual se canceló el usuario',
  `RutaPDF` varchar(200) DEFAULT NULL COMMENT 'Ruta donde se encuentra el PDF',
  `Periodo` varchar(15) DEFAULT NULL COMMENT 'Periodo del Estado de Cuenta (AnioMes)',
  `SucursalCliente` int(11) DEFAULT NULL COMMENT 'Sucursal del Cliente',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus de la Factura V.- Vigente C.-Cancelado',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(45) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`FacturaID`),
  KEY `fk_FACTURACFDI_1_idx` (`SucursalCliente`),
  CONSTRAINT `fk_FACTURACFDI_1` FOREIGN KEY (`SucursalCliente`) REFERENCES `SUCURSALES` (`SucursalID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$