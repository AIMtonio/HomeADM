-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPEDOCTAHEADER099INV
DELIMITER ;
DROP TABLE IF EXISTS `TMPEDOCTAHEADER099INV`;DELIMITER $$

CREATE TABLE `TMPEDOCTAHEADER099INV` (
  `AnioMes` int(11) DEFAULT NULL,
  `SucursalID` int(11) DEFAULT NULL,
  `ClienteID` int(11) DEFAULT NULL,
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `NombreProducto` varchar(100) DEFAULT NULL,
  `GatReal` decimal(14,2) DEFAULT NULL,
  `TotalComisionesCobradas` decimal(14,2) DEFAULT NULL,
  `IvaComision` decimal(14,2) DEFAULT NULL,
  `ISRretenido` decimal(14,2) DEFAULT NULL,
  `InversionID` bigint(11) DEFAULT NULL,
  `TipoCuenta` varchar(150) DEFAULT NULL,
  `InvCapital` decimal(18,2) DEFAULT NULL,
  `FechaInicio` date DEFAULT NULL,
  `FechaVence` date DEFAULT NULL,
  `TasaBruta` decimal(18,2) DEFAULT NULL,
  `Plazo` int(11) DEFAULT NULL,
  `Estatus` char(1) DEFAULT NULL,
  `Gat` decimal(14,2) DEFAULT NULL,
  `SucursalOrigen` int(11) DEFAULT NULL,
  KEY `IDX_TMPEDOCTAHEADER099INV_ANIOMES` (`AnioMes`) USING BTREE,
  KEY `IDX_TMPEDOCTAHEADER099INV_CLIENTE` (`ClienteID`) USING BTREE,
  KEY `IDX_TMPEDOCTAHEADER099INV_SUCURSAL` (`SucursalID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$