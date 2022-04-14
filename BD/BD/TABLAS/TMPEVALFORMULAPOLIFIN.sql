-- TMPEVALFORMULAPOLIFIN

DELIMITER ;
DROP TABLE IF EXISTS TMPEVALFORMULAPOLIFIN;

DELIMITER $$
CREATE TABLE `TMPEVALFORMULAPOLIFIN` (
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Numero de Transaccion de la operacion',
  `CentroCostoID` int(11) NOT NULL COMMENT 'Centro de Costo ',
  `CuentaCompleta` varchar(50) NOT NULL COMMENT 'Numero de cuenta completa - CUENTASCONTABLES',
  `Cargos` decimal(14,4) DEFAULT NULL COMMENT 'Monto de los cargos',
  `Abonos` decimal(14,4) DEFAULT NULL COMMENT 'Monto de los Abonos',
  `Ubicacion` char(1) DEFAULT NULL COMMENT 'Ubicacion de los saldos A - Actual, H-Historico',
  PRIMARY KEY (`CuentaCompleta`,`CentroCostoID`,`NumTransaccion`),
  KEY `fk_CentroCostoPoliza` (`CentroCostoID`),
  KEY `fk_CuentaContablePoliza` (`CuentaCompleta`),
  KEY `IDXFechaAplicacion2` (`Ubicacion`),
  KEY `INDEX_DETALLEPOLIZA_1` (`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT 'TMP: Temporal que guarda el saldo por cuenta contable '$$
