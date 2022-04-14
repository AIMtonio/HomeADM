-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TRANSFERBANCO
DELIMITER ;
DROP TABLE IF EXISTS `TRANSFERBANCO`;
DELIMITER $$


CREATE TABLE `TRANSFERBANCO` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `TransferBancoID` int(11) NOT NULL COMMENT 'ID de la Transferencia de Banco',
  `InstitucionID` int(11) DEFAULT NULL COMMENT 'Id Del Banco (Institucion) de donde es la Cuenta',
  `NumCtaInstit` varchar(20) DEFAULT NULL COMMENT 'Numero de Cuenta En el Banco(Institucion)',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Sucursal a la que pertenece la Caja 	',
  `CajaID` int(11) DEFAULT NULL COMMENT 'Identificador de la Caja que envia o Recibe Efectivo',
  `MonedaID` int(11) DEFAULT NULL,
  `Cantidad` decimal(14,2) DEFAULT NULL COMMENT 'Monto de Efectivo a Enviar o Recibir',
  `PolizaID` bigint(20) DEFAULT NULL COMMENT 'Corresponde con la tabla\\nPOLIZACONTABLE, nos ayuda a\\ncuadrar la poliza cuando \\ntransfiere y recibe efectivo',
  `DenominacionID` int(11) DEFAULT NULL COMMENT 'Corresponde a la Tabla DENOMINACIONES, para definir el tipo de denominacion\\\\n',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus de la Transferencia\\nE.- Envio  R.- Recibido',
  `Fecha` date DEFAULT NULL,
  `Referencia` varchar(50) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  KEY `fk_TRANSFERBANCO_1_idx` (`InstitucionID`,`NumCtaInstit`),
  KEY `fk_TRANSFERBANCO_2_idx` (`SucursalID`,`CajaID`),
  KEY `fk_TRANSFERBANCO_3_idx` (`MonedaID`),
  KEY `fk_TRANSFERBANCO_4_idx` (`DenominacionID`),
  CONSTRAINT `fk_TRANSFERBANCO_1` FOREIGN KEY (`InstitucionID`, `NumCtaInstit`) REFERENCES `CUENTASAHOTESO` (`InstitucionID`, `NumCtaInstit`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_TRANSFERBANCO_2` FOREIGN KEY (`SucursalID`, `CajaID`) REFERENCES `CAJASVENTANILLA` (`SucursalID`, `CajaID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_TRANSFERBANCO_3` FOREIGN KEY (`MonedaID`) REFERENCES `MONEDAS` (`MonedaId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_TRANSFERBANCO_4` FOREIGN KEY (`DenominacionID`) REFERENCES `DENOMINACIONES` (`DenominacionID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Transferencias de Efectivo entre Cajas Principales o Boveda '$$
