-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INVERSIONESMOV
DELIMITER ;
DROP TABLE IF EXISTS `INVERSIONESMOV`;
DELIMITER $$


CREATE TABLE `INVERSIONESMOV` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `InversionID` int(11) DEFAULT NULL COMMENT 'Numero de \nInversion',
  `NumeroMovimiento` bigint(20) NOT NULL COMMENT 'Numero de \nMovimiento',
  `Fecha` varchar(45) NOT NULL COMMENT 'Fecha',
  `TipoMovInvID` char(4) NOT NULL COMMENT 'Tipo de \nMovimiento',
  `Monto` decimal(12,2) DEFAULT NULL,
  `NatMovimiento` char(1) NOT NULL COMMENT 'Tipo de\nMovimiento\nC .- Cargo\nA .- Abono',
  `Referencia` varchar(100) DEFAULT NULL COMMENT 'Referencia',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Moneda',
  `PolizaID` bigint(20) DEFAULT NULL COMMENT 'Numero de Poliza Generado para el movimiento',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(50) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  KEY `fk_INVERSIONESMOV_1` (`InversionID`),
  KEY `fk_INVERSIONESMOV_2` (`MonedaID`),
  KEY `fk_INVERSIONESMOV_3` (`TipoMovInvID`),
  CONSTRAINT `fk_INVERSIONESMOV_1` FOREIGN KEY (`InversionID`) REFERENCES `INVERSIONES` (`InversionID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_INVERSIONESMOV_2` FOREIGN KEY (`MonedaID`) REFERENCES `MONEDAS` (`MonedaId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_INVERSIONESMOV_3` FOREIGN KEY (`TipoMovInvID`) REFERENCES `TIPOSMOVSINV` (`TipoMovInvID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Movimientos de Inversiones'$$
