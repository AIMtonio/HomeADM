-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FINALEXCELSUM
DELIMITER ;
DROP TABLE IF EXISTS `FINALEXCELSUM`;DELIMITER $$

CREATE TABLE `FINALEXCELSUM` (
  `ProveedorID` int(11) DEFAULT NULL COMMENT 'ID Proveedor',
  `NombreProv` varchar(200) DEFAULT NULL COMMENT 'Nombre Proveedor',
  `CURP` char(18) DEFAULT NULL COMMENT 'CURP',
  `RFC` char(13) DEFAULT NULL COMMENT 'RFC',
  `NoFactura` varchar(50) DEFAULT NULL COMMENT 'Numero de Factura',
  `Usuario` varchar(100) DEFAULT NULL COMMENT 'Nombre Usuario',
  `Subtotal` decimal(14,2) DEFAULT NULL COMMENT 'Monto',
  `Tasa16` decimal(14,2) DEFAULT NULL,
  `Tasa0` decimal(14,2) DEFAULT NULL COMMENT 'Suma IVA: SI',
  `Excento` decimal(14,2) DEFAULT NULL COMMENT 'Suma IVA: NO',
  `IVA` decimal(14,2) DEFAULT NULL,
  `RET_IVA` decimal(14,2) DEFAULT NULL,
  `RET_ISR` decimal(14,2) DEFAULT NULL,
  `EFS_GVA` decimal(14,2) DEFAULT NULL,
  `EFS_RTN` decimal(14,2) DEFAULT NULL,
  `SaldoFactura` decimal(14,2) DEFAULT NULL COMMENT 'Saldo Factura',
  `FechaRegistro` date DEFAULT NULL COMMENT 'Fecha Emision',
  `FechaVencimiento` date DEFAULT NULL COMMENT 'Fecha Vencimiento',
  `FechaEfectivaDePago` date DEFAULT NULL COMMENT 'Fecha Preferencia pago',
  `Estatus` varchar(30) DEFAULT NULL COMMENT 'Estatus'
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$