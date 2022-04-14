-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITODEVGL
DELIMITER ;
DROP TABLE IF EXISTS `CREDITODEVGL`;DELIMITER $$

CREATE TABLE `CREDITODEVGL` (
  `CreditoID` bigint(12) NOT NULL COMMENT 'Número de Crédito',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Numero de Cliente',
  `CuentaID` bigint(12) DEFAULT NULL,
  `Monto` decimal(14,2) DEFAULT NULL COMMENT 'Monto total de la devolucion',
  `CajaID` int(11) DEFAULT NULL COMMENT 'Numero de  caja',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Numero de Sucursal',
  `Fecha` datetime DEFAULT NULL COMMENT 'Fecha',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`CreditoID`),
  KEY `fk_CREDITODEVGL_1_idx` (`ClienteID`),
  KEY `fk_CREDITODEVGL_2_idx` (`CuentaID`),
  KEY `fk_CREDITODEVGL_4_idx` (`SucursalID`),
  KEY `fk_CREDITODEVGL_5_idx` (`SucursalID`,`CajaID`),
  CONSTRAINT `fk_CREDITODEVGL_1` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CREDITODEVGL_2` FOREIGN KEY (`CuentaID`) REFERENCES `CUENTASAHO` (`CuentaAhoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CREDITODEVGL_3` FOREIGN KEY (`CreditoID`) REFERENCES `CREDITOS` (`CreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CREDITODEVGL_4` FOREIGN KEY (`SucursalID`) REFERENCES `SUCURSALES` (`SucursalID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CREDITODEVGL_5` FOREIGN KEY (`SucursalID`, `CajaID`) REFERENCES `CAJASVENTANILLA` (`SucursalID`, `CajaID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='ALMACENA TODAS LAS DEVOLUCIONES DE GARANTIA LIQUIDA QUE SE R'$$