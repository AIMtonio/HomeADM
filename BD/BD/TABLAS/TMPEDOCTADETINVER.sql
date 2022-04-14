-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPEDOCTADETINVER
DELIMITER ;
DROP TABLE IF EXISTS `TMPEDOCTADETINVER`;DELIMITER $$

CREATE TABLE `TMPEDOCTADETINVER` (
  `AnioMes` int(11) NOT NULL,
  `SucursalID` int(11) NOT NULL,
  `ClienteID` int(11) NOT NULL,
  `InversionID` bigint(20) NOT NULL,
  `Descripcion` varchar(100) NOT NULL,
  `FechanMov` date NOT NULL,
  `Cargo` decimal(14,2) NOT NULL,
  `Abono` decimal(14,2) NOT NULL,
  `Orden` int(11) NOT NULL,
  `Referencia` bigint(20) NOT NULL,
  KEY `IDX_TMPEDOCTADETINVER_ANIOMES` (`AnioMes`) USING BTREE,
  KEY `IDX_TMPEDOCTADETINVER_CLIENTE` (`ClienteID`) USING BTREE,
  KEY `IDX_TMPEDOCTADETINVER_SUCURSAL` (`SucursalID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$