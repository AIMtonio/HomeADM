-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPEDCTAHEADERCTA
DELIMITER ;
DROP TABLE IF EXISTS `TMPEDCTAHEADERCTA`;DELIMITER $$

CREATE TABLE `TMPEDCTAHEADERCTA` (
  `AnioMes` int(11) DEFAULT NULL,
  `SucursalID` int(11) DEFAULT NULL,
  `ClienteID` int(11) DEFAULT NULL,
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `ProductoDesc` varchar(60) DEFAULT NULL,
  `Clabe` varchar(18) DEFAULT NULL,
  `SaldoMesAnterior` decimal(14,2) DEFAULT NULL,
  `SaldoActual` decimal(14,2) DEFAULT NULL,
  `SaldoPromedio` decimal(14,2) DEFAULT NULL,
  `SaldoMinimo` decimal(14,2) DEFAULT NULL,
  `ISRRetenido` decimal(14,2) DEFAULT NULL,
  `GatNominal` decimal(5,2) DEFAULT NULL,
  `GatReal` decimal(5,2) DEFAULT NULL,
  `TasaBruta` decimal(5,2) DEFAULT NULL,
  `InteresPerido` decimal(14,2) DEFAULT NULL,
  `MontoComision` decimal(14,2) DEFAULT NULL,
  `IvaComision` decimal(14,2) DEFAULT NULL,
  `MonedaID` int(11) DEFAULT NULL,
  `MonedaDescri` varchar(45) DEFAULT NULL,
  `Etiqueta` varchar(60) DEFAULT NULL,
  `Depositos` decimal(14,2) DEFAULT NULL,
  `Retiros` decimal(14,2) DEFAULT NULL,
  `Estatus` varchar(25) DEFAULT NULL,
  KEY `IDX_TMPEDCTAHEADERCTA_ANIOMES` (`AnioMes`) USING BTREE,
  KEY `IDX_TMPEDCTAHEADERCTA_CLIENTE` (`ClienteID`) USING BTREE,
  KEY `IDX_TMPEDCTAHEADERCTA_SUCURSAL` (`SucursalID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$