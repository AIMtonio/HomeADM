-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DENOMINACIONMOVS
DELIMITER ;
DROP TABLE IF EXISTS `DENOMINACIONMOVS`;
DELIMITER $$


CREATE TABLE `DENOMINACIONMOVS` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `SucursalID` int(11) NOT NULL COMMENT 'Sucursal donde se encuentra Asignada la Caja',
  `CajaID` int(11) NOT NULL COMMENT 'ID o Numero de Caja',
  `Fecha` date NOT NULL COMMENT 'Fecha del Movimiento',
  `Transaccion` bigint(20) NOT NULL COMMENT 'Numero de \nTransaccion',
  `Naturaleza` int(11) NOT NULL COMMENT 'Naturaleza de la\n Operacion\n1 .- Entrada\n2 .- Salida',
  `DenominacionID` int(11) NOT NULL COMMENT 'Consecutivo de denominación',
  `Cantidad` decimal(14,2) NOT NULL COMMENT 'Cantidad de la Denominacion',
  `Monto` decimal(14,2) NOT NULL COMMENT 'Monto del Movimiento = Cantidad * Valor Denominacion',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Numero o ID de la Moneda',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  KEY `fk_DENOMINACIONMOVS_3` (`DenominacionID`),
  KEY `fk_DENOMINACIONMOVS_4` (`MonedaID`),
  KEY `fk_DENOMINACIONMOVS_1` (`SucursalID`,`CajaID`),
  KEY `fk_DENOMINACIONMOVS_2` (`SucursalID`),
  KEY `index_ValidaOperCaja` (`SucursalID`,`CajaID`,`Fecha`,`Transaccion`),
  CONSTRAINT `fk_DENOMINACIONMOVS_1` FOREIGN KEY (`SucursalID`, `CajaID`) REFERENCES `CAJASVENTANILLA` (`SucursalID`, `CajaID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_DENOMINACIONMOVS_2` FOREIGN KEY (`SucursalID`) REFERENCES `SUCURSALES` (`SucursalID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_DENOMINACIONMOVS_3` FOREIGN KEY (`DenominacionID`) REFERENCES `DENOMINACIONES` (`DenominacionID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_DENOMINACIONMOVS_4` FOREIGN KEY (`MonedaID`) REFERENCES `MONEDAS` (`MonedaId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Movimientos de las Denominaciones'$$
