-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPIMPUESTOS
DELIMITER ;
DROP TABLE IF EXISTS `TMPIMPUESTOS`;DELIMITER $$

CREATE TABLE `TMPIMPUESTOS` (
  `IVA` decimal(14,2) DEFAULT NULL,
  `RET_IVA` decimal(14,2) DEFAULT NULL,
  `RET_ISR` decimal(14,2) DEFAULT NULL,
  `EFS_GVA` decimal(14,2) DEFAULT NULL,
  `EFS_RTN` decimal(14,2) DEFAULT NULL,
  `NoFactura` varchar(20) DEFAULT NULL,
  `ProveedorID` int(11) DEFAULT NULL,
  `ImpuestoID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$