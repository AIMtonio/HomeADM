-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTADETACTA
DELIMITER ;
DROP TABLE IF EXISTS `EDOCTADETACTA`;
DELIMITER $$


CREATE TABLE `EDOCTADETACTA` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `AnioMes` int(11) DEFAULT NULL,
  `SucursalID` int(11) DEFAULT NULL,
  `ClienteID` int(11) DEFAULT NULL,
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `Etiqueta` varchar(60) DEFAULT NULL,
  `SaldoInicial` decimal(14,2) DEFAULT NULL,
  `CuentaClabe` char(18) DEFAULT NULL,
  `Fecha` datetime DEFAULT NULL,
  `Transaccion` bigint(20) DEFAULT NULL,
  `DescripcionMov` varchar(150) DEFAULT NULL,
  `Deposito` decimal(14,2) DEFAULT NULL,
  `Retiro` decimal(14,2) DEFAULT NULL,
  `Saldo` decimal(14,2) DEFAULT NULL,
  `TipoMovAhoID` int(11) DEFAULT NULL COMMENT 'TIpo de Movimiento de Ahorro',
  `PolizaID` bigint(20) DEFAULT NULL COMMENT 'Referencia para actuaizar el Folio UUID en DetallePoliza despues del Timbrado.',
  KEY `index1` (`PolizaID`),
  PRIMARY KEY (RegistroID),
  INDEX INDEX_EDOCTADETACTA_2 (ClienteID),
  INDEX INDEX_EDOCTADETACTA_3 (CuentaAhoID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Detalle de los movimientos de cada cuenta mostrada en el res'$$
