-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPFACTEXCELDET
DELIMITER ;
DROP TABLE IF EXISTS `TMPFACTEXCELDET`;DELIMITER $$

CREATE TABLE `TMPFACTEXCELDET` (
  `ProveedorID` int(11) NOT NULL,
  `RazonSocial` varchar(203) DEFAULT NULL,
  `NoFactura` varchar(20) NOT NULL DEFAULT '' COMMENT 'Numero de factura entregada por el proveedor',
  `NombreUsuario` varchar(150) NOT NULL COMMENT 'Nombre del\nUsuario',
  `TipoProveedorID` int(12) NOT NULL COMMENT 'Identificador tipo proveedor',
  `Descripcion` varchar(200) DEFAULT NULL COMMENT 'Descripción tipo proveedor',
  `RFC` varchar(13) DEFAULT NULL,
  `CURP` varchar(18) NOT NULL DEFAULT '',
  `FechaFactura` date DEFAULT NULL COMMENT 'Fecha de la factura',
  `SubTotal` decimal(13,2) DEFAULT NULL COMMENT 'Monto para tomar como base calculo IVA',
  `TotalFactura` decimal(13,2) DEFAULT NULL COMMENT 'Monto Total Neto a Pagar de la Factura',
  `TipoPago` varchar(50) DEFAULT NULL,
  `TipoDispersion` varchar(26) DEFAULT NULL,
  `SaldoFactura` decimal(13,2) DEFAULT NULL COMMENT 'Saldo de la factura por su hubo pagos parciales',
  `DescripcionCompra` varchar(200) DEFAULT NULL,
  `Importe16` decimal(13,2) DEFAULT NULL,
  `Importe0` decimal(13,2) DEFAULT NULL,
  `ImporteExcento` decimal(13,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$