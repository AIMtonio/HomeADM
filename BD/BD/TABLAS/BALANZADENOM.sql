-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BALANZADENOM
DELIMITER ;
DROP TABLE IF EXISTS `BALANZADENOM`;DELIMITER $$

CREATE TABLE `BALANZADENOM` (
  `SucursalID` int(11) NOT NULL COMMENT 'Numero de \nSucursal',
  `CajaID` int(11) NOT NULL COMMENT 'ID o Numero\n de Caja',
  `DenominacionID` int(11) NOT NULL COMMENT 'Consecutivo \nde denominación',
  `MonedaID` int(11) NOT NULL COMMENT 'Numero de \nMoneda',
  `Cantidad` decimal(14,2) NOT NULL COMMENT 'Cantidad de billetes o monedas\n',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`SucursalID`,`CajaID`,`DenominacionID`),
  KEY `fk_BALANZADENOM_2` (`MonedaID`),
  KEY `fk_BALANZADENOM_4` (`DenominacionID`),
  KEY `fk_BALANZADENOM_1` (`SucursalID`,`CajaID`),
  KEY `fk_BALANZADENOM_3` (`SucursalID`),
  CONSTRAINT `fk_BALANZADENOM_1` FOREIGN KEY (`SucursalID`, `CajaID`) REFERENCES `CAJASVENTANILLA` (`SucursalID`, `CajaID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_BALANZADENOM_2` FOREIGN KEY (`MonedaID`) REFERENCES `MONEDAS` (`MonedaId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_BALANZADENOM_3` FOREIGN KEY (`SucursalID`) REFERENCES `SUCURSALES` (`SucursalID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_BALANZADENOM_4` FOREIGN KEY (`DenominacionID`) REFERENCES `DENOMINACIONES` (`DenominacionID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Balanza Actual de Denominaciones, Efectivo'$$