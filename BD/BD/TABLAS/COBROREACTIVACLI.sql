-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COBROREACTIVACLI
DELIMITER ;
DROP TABLE IF EXISTS `COBROREACTIVACLI`;DELIMITER $$

CREATE TABLE `COBROREACTIVACLI` (
  `CobroReactCliID` int(11) NOT NULL COMMENT 'id de la tbla',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Numero de Cliente',
  `CajaID` int(11) DEFAULT NULL COMMENT 'Numero de Caja de Ventanilla',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Numero de Sucursal en la que se realiza la operacion',
  `MontoReactiva` decimal(14,2) DEFAULT NULL COMMENT 'Monto Cobrado',
  `FechaCobro` date DEFAULT NULL COMMENT 'Fecha de Cobro ',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus\nP = Pendiente (es decir el cte no se a reactivado)\nA= Aplicado (el cliente ya se reactivo)',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'moneda en la que se realizo la operacion',
  `PolizaID` bigint(20) DEFAULT NULL COMMENT 'Numero de poliza genrada en la operacion',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`CobroReactCliID`),
  KEY `fk_COBROREACTIVACLI_1` (`SucursalID`,`CajaID`),
  KEY `fk_COBROREACTIVACLI_2` (`MonedaID`),
  KEY `fk_COBROREACTIVACLI_3` (`ClienteID`),
  CONSTRAINT `fk_COBROREACTIVACLI_1` FOREIGN KEY (`SucursalID`, `CajaID`) REFERENCES `CAJASVENTANILLA` (`SucursalID`, `CajaID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_COBROREACTIVACLI_2` FOREIGN KEY (`MonedaID`) REFERENCES `MONEDAS` (`MonedaId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_COBROREACTIVACLI_3` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena informacion de los cobros realizados en ventanilla '$$