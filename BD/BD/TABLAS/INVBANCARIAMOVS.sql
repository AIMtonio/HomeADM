-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INVBANCARIAMOVS
DELIMITER ;
DROP TABLE IF EXISTS `INVBANCARIAMOVS`;
DELIMITER $$


CREATE TABLE `INVBANCARIAMOVS` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `InversionID` int(12) NOT NULL COMMENT 'Numero de Inversion',
  `NumeroMov` bigint(20) NOT NULL COMMENT 'Numero de transaccion',
  `Fecha` date NOT NULL COMMENT 'fecha del movimiento',
  `NatMovimiento` char(1) NOT NULL COMMENT 'Naturaleza del Movimiento C cargo A abono',
  `Cantidad` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT 'Monto del movimiento',
  `Descripcion` varchar(150) NOT NULL COMMENT 'Descripcion del movimiento',
  `TipoMovInbID` char(4) NOT NULL COMMENT 'Tipo de\nMovimiento',
  `MonedaID` int(11) NOT NULL,
  `EmpresaID` int(11) NOT NULL,
  `Usuario` int(11) NOT NULL,
  `FechaActual` datetime NOT NULL,
  `DireccionIP` varchar(15) NOT NULL,
  `ProgramaID` varchar(50) NOT NULL,
  `Sucursal` int(11) NOT NULL,
  `NumTransaccion` bigint(20) NOT NULL,
  KEY `fk_INVBANCARIAMOVS_2` (`TipoMovInbID`),
  KEY `fk_INVBANCARIAMOVS_1` (`InversionID`),
  KEY `fk_INVBANCARIAMOVS_3` (`MonedaID`),
  CONSTRAINT `fk_INVBANCARIAMOVS_1` FOREIGN KEY (`InversionID`) REFERENCES `INVBANCARIA` (`InversionID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_INVBANCARIAMOVS_2` FOREIGN KEY (`TipoMovInbID`) REFERENCES `TIPOSMOVSINVBAN` (`TipoMovInbID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_INVBANCARIAMOVS_3` FOREIGN KEY (`MonedaID`) REFERENCES `MONEDAS` (`MonedaId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Movimientos de Inversiones Bancarias'$$
