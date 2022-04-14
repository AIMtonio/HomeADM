-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTARESUMCTA
DELIMITER ;
DROP TABLE IF EXISTS `EDOCTARESUMCTA`;
DELIMITER $$


CREATE TABLE `EDOCTARESUMCTA` (
  `AnioMes` int(11) NOT NULL DEFAULT '0',
  `SucursalID` int(11) NOT NULL DEFAULT '0',
  `ClienteID` int(11) DEFAULT NULL,
  `CuentaAhoID` bigint(12) NOT NULL DEFAULT '0',
  `MonedaID` int(11) DEFAULT NULL,
  `MonedaDescri` varchar(45) DEFAULT NULL,
  `Etiqueta` varchar(60) DEFAULT NULL,
  `Depositos` decimal(14,2) DEFAULT NULL,
  `Retiros` decimal(14,2) DEFAULT NULL,
  `Interes` decimal(14,2) DEFAULT NULL,
  `ISR` decimal(14,2) DEFAULT NULL,
  `SaldoActual` decimal(14,2) DEFAULT NULL,
  `SaldoMesAnterior` decimal(14,2) DEFAULT NULL,
  `SaldoPromedio` decimal(14,2) DEFAULT NULL,
  `TasaBruta` decimal(14,2) DEFAULT NULL,
  `Estatus` varchar(20) DEFAULT NULL,
  `GAT` decimal(12,2) DEFAULT NULL,
  `CLABE` varchar(18) DEFAULT NULL,
  `TipoCuentaID` int(11) DEFAULT NULL COMMENT 'Tipo de cuenta',
  `SaldoMInReq` decimal(12,2) DEFAULT NULL,
  `Comisiones` decimal(12,2) DEFAULT NULL,
  `GatInformativo` decimal(12,2) DEFAULT NULL,
  `ParteSocial` decimal(14,2) DEFAULT NULL,
  `GeneraInteres` CHAR(1) NOT NULL COMMENT 'Indica si el producto genera interes /S.- si /N.- no/',
  PRIMARY KEY (`AnioMes`,`SucursalID`,`CuentaAhoID`),
  KEY `CuentaAhoID` (`CuentaAhoID`),
  INDEX INDEX_EDOCTARESUMCTA_2 (ClienteID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Resumen de las cuentas por Cliente	'$$
