-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASAHOMOV
DELIMITER ;
DROP TABLE IF EXISTS `CUENTASAHOMOV`;
DELIMITER $$


CREATE TABLE `CUENTASAHOMOV` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `NumeroMov` bigint(20) NOT NULL COMMENT 'Numero de transaccion',
  `Fecha` date NOT NULL COMMENT 'fecha del movimiento',
  `NatMovimiento` char(1) NOT NULL COMMENT 'Naturaleza del Movimiento C cargo A abono',
  `CantidadMov` decimal(12,2) DEFAULT NULL,
  `DescripcionMov` varchar(150) NOT NULL COMMENT 'Descripcion del movimiento en estado de cuenta',
  `ReferenciaMov` varchar(50) NOT NULL COMMENT 'Origen del Movimiento, referencia',
  `TipoMovAhoID` char(4) NOT NULL COMMENT 'Tipo de\nMovimiento',
  `MonedaID` int(11) NOT NULL,
  `PolizaID` bigint(20) DEFAULT NULL COMMENT 'Numero de Poliza Generado para el movimiento',
  `EmpresaID` int(11) NOT NULL,
  `Usuario` int(11) NOT NULL,
  `FechaActual` datetime NOT NULL,
  `DireccionIP` varchar(15) NOT NULL,
  `ProgramaID` varchar(50) NOT NULL,
  `Sucursal` int(11) NOT NULL,
  `NumTransaccion` bigint(20) NOT NULL,
  KEY `fk_CUENTASAHOMOV_2` (`TipoMovAhoID`),
  KEY `fk_CUENTASAHOMOV_1` (`CuentaAhoID`),
  KEY `fk_CUENTASAHOMOV_3` (`MonedaID`),
  KEY `index4` (`CantidadMov`),
  KEY `INDEX_CUENTASAHOMOV_6` (`CuentaAhoID`,`Fecha`,`NumTransaccion`),
  CONSTRAINT `fk_CUENTASAHOMOV_1` FOREIGN KEY (`CuentaAhoID`) REFERENCES `CUENTASAHO` (`CuentaAhoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CUENTASAHOMOV_2` FOREIGN KEY (`TipoMovAhoID`) REFERENCES `TIPOSMOVSAHO` (`TipoMovAhoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CUENTASAHOMOV_3` FOREIGN KEY (`MonedaID`) REFERENCES `MONEDAS` (`MonedaId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Movimientos de la Cuenta de Ahorro'$$
