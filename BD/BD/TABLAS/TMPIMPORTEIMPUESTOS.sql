-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPIMPORTEIMPUESTOS
DELIMITER ;
DROP TABLE IF EXISTS `TMPIMPORTEIMPUESTOS`;DELIMITER $$

CREATE TABLE `TMPIMPORTEIMPUESTOS` (
  `IVA` decimal(14,2) DEFAULT NULL,
  `RET_IVA` decimal(14,2) DEFAULT NULL,
  `RET_ISR` decimal(14,2) DEFAULT NULL,
  `EFS_GVA` decimal(14,2) DEFAULT NULL,
  `EFS_RTN` decimal(14,2) DEFAULT NULL,
  `NoFactura` varchar(20) DEFAULT NULL,
  `ProveedorID` int(11) DEFAULT NULL,
  `ImpuestoID` int(11) DEFAULT NULL,
  KEY `id_indexImpuestos` (`ProveedorID`,`NoFactura`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$