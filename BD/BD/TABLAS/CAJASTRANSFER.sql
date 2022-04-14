-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAJASTRANSFER
DELIMITER ;
DROP TABLE IF EXISTS `CAJASTRANSFER`;
DELIMITER $$


CREATE TABLE `CAJASTRANSFER` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `CajasTransferID` int(11) NOT NULL COMMENT 'Consecutivo de Cajas Transferencias',
  `SucursalOrigen` int(11) DEFAULT NULL COMMENT 'Sucursal Origen para la Transferencia de Efectivo',
  `SucursalDestino` int(11) DEFAULT NULL COMMENT 'Sucursal Destino para la Transferencia de Efectivo',
  `Fecha` datetime DEFAULT NULL COMMENT 'Fecha de Transferencia',
  `DenominacionID` int(11) DEFAULT NULL COMMENT 'Corresponde a la Tabla DENOMINACIONES, para definir el tipo de denominacion\\n',
  `Cantidad` decimal(14,2) DEFAULT NULL,
  `CajaOrigen` int(11) DEFAULT NULL COMMENT 'Caja Origen para la Transferencia',
  `CajaDestino` int(11) DEFAULT NULL COMMENT 'Caja Destino de la Transferencia',
  `Estatus` char(1) DEFAULT NULL COMMENT 'A : Alta\\nR: Recibido\\n',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Corresponde a la Tabla MONEDAS',
  `PolizaID` bigint(20) DEFAULT NULL COMMENT 'Corresponde con la tabla\nPOLIZACONTABLE, nos ayuda a\ncuadrar la poliza cuando \ntransfiere y recibe efectivo',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  KEY `fk_CAJASTRANSFER_3_idx` (`DenominacionID`),
  KEY `fk_CAJASTRANSFER_1_idx` (`SucursalOrigen`,`CajaOrigen`),
  KEY `fk_CAJASTRANSFER_2_idx` (`SucursalDestino`,`CajaDestino`),
  KEY `fk_CAJASTRANSFER_4_idx` (`MonedaID`),
  CONSTRAINT `fk_CAJASTRANSFER_1` FOREIGN KEY (`SucursalOrigen`, `CajaOrigen`) REFERENCES `CAJASVENTANILLA` (`SucursalID`, `CajaID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CAJASTRANSFER_2` FOREIGN KEY (`SucursalDestino`, `CajaDestino`) REFERENCES `CAJASVENTANILLA` (`SucursalID`, `CajaID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CAJASTRANSFER_3` FOREIGN KEY (`DenominacionID`) REFERENCES `DENOMINACIONES` (`DenominacionID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CAJASTRANSFER_4` FOREIGN KEY (`MonedaID`) REFERENCES `MONEDAS` (`MonedaId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Transferencia entre cajas'$$
