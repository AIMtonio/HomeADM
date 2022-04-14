-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPFACTURASEXCEL
DELIMITER ;
DROP TABLE IF EXISTS `TMPFACTURASEXCEL`;DELIMITER $$

CREATE TABLE `TMPFACTURASEXCEL` (
  `ProveedorID` int(11) DEFAULT NULL,
  `NombreProv` varchar(100) DEFAULT NULL,
  `CURP` char(18) DEFAULT NULL,
  `RFC` char(13) DEFAULT NULL,
  `NoFactura` varchar(50) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `NombreUsuario` varchar(100) DEFAULT NULL,
  `Monto` decimal(14,2) DEFAULT NULL,
  `SaldoFactura` decimal(14,2) DEFAULT NULL,
  `FechaEmision` date DEFAULT NULL,
  `Estatus` varchar(30) DEFAULT NULL,
  `FechaPrefPago` date DEFAULT NULL,
  `FechaVencim` date DEFAULT NULL,
  `SumIVANoNo` decimal(14,2) DEFAULT NULL,
  `SumIVASiSi` decimal(14,2) DEFAULT NULL,
  `SumIVASiNo` decimal(14,2) DEFAULT NULL,
  `Importe16` decimal(13,2) DEFAULT NULL,
  `Importe0` decimal(13,2) DEFAULT NULL,
  `ImporteExcento` decimal(13,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$