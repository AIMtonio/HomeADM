-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPEDOCTAGRAFICA
DELIMITER ;
DROP TABLE IF EXISTS `TMPEDOCTAGRAFICA`;DELIMITER $$

CREATE TABLE `TMPEDOCTAGRAFICA` (
  `AnioMes` int(11) DEFAULT NULL,
  `SucursalID` int(11) DEFAULT NULL,
  `ClienteID` int(11) DEFAULT NULL,
  `Descripcion` varchar(45) DEFAULT NULL,
  `Monto` decimal(14,2) DEFAULT NULL,
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  KEY `IDX_TMPEDOCTAGRAFICA_ANIOMES` (`AnioMes`) USING BTREE,
  KEY `IDX_TMPEDOCTAGRAFICA_CLIENTE` (`ClienteID`) USING BTREE,
  KEY `IDX_TMPEDOCTAGRAFICA_SUCURSAL` (`SucursalID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$