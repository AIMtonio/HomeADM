-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATCAJEROSATM
DELIMITER ;
DROP TABLE IF EXISTS `CATCAJEROSATM`;DELIMITER $$

CREATE TABLE `CATCAJEROSATM` (
  `CajeroID` varchar(20) NOT NULL COMMENT 'Identificador del Cajero',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Sucursal a la que pertenece el cajero',
  `NumCajeroPROSA` varchar(30) DEFAULT NULL COMMENT 'Numero de Cajero exclusivo de PROSA',
  `Ubicacion` varchar(500) DEFAULT NULL COMMENT 'Ubicacion del Cajero',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'Id del usuario responsable del Cajero',
  `SaldoMN` decimal(12,2) DEFAULT NULL COMMENT 'Saldo en Moneda Nacional',
  `SaldoME` decimal(12,2) DEFAULT NULL COMMENT 'Saldo del cajero en Moneda Extranjera',
  `CtaContableMN` varchar(25) DEFAULT NULL COMMENT 'Numero de Cuenta Contable MOneda Nacional',
  `CtaContableME` varchar(25) DEFAULT NULL COMMENT 'Cuenta Contable Moneda Extranjera',
  `CtaContaMNTrans` varchar(25) DEFAULT NULL COMMENT 'Cuenta Contable Moneda Nacional En transito',
  `CtaContaMETrans` varchar(25) DEFAULT NULL COMMENT 'CuentaContable Moneda Extrangera en Transito',
  `EstadoID` int(11) DEFAULT NULL COMMENT 'FK de Estado ',
  `MunicipioID` int(11) DEFAULT NULL,
  `LocalidadID` int(11) DEFAULT NULL,
  `ColoniaID` int(11) DEFAULT NULL,
  `Calle` varchar(150) DEFAULT NULL,
  `Numero` varchar(20) DEFAULT NULL,
  `NumInterior` varchar(20) DEFAULT NULL,
  `CP` char(5) DEFAULT NULL,
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus\nI = Inactivo\nA = Activo',
  `FechaAlta` date DEFAULT NULL COMMENT 'Fecha en la que se da alta el Cajero',
  `FechaBaja` date DEFAULT NULL COMMENT 'Fecha en la que se da baja(Inactiva) el Cajero',
  `NomenclaturaCR` varchar(45) DEFAULT NULL COMMENT '&SO.-Sucursal del Cajero\n&SC.-Sucursal del Cliente',
  `TipoCajeroID` int(11) DEFAULT NULL COMMENT 'Tabla CATTIPOCAJERO',
  `Latitud` varchar(10) DEFAULT NULL,
  `Longitud` varchar(11) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`CajeroID`),
  KEY `fk_CATCAJEROSATM_1` (`SucursalID`),
  KEY `fk_CATCAJEROSATM_2` (`UsuarioID`),
  KEY `fk_CATCAJEROSATM_3_idx` (`EstadoID`),
  KEY `fk_CATCAJEROSATM_4_idx` (`MunicipioID`),
  KEY `fk_CATCAJEROSATM_8_idx` (`TipoCajeroID`),
  CONSTRAINT `fk_CATCAJEROSATM_1` FOREIGN KEY (`SucursalID`) REFERENCES `SUCURSALES` (`SucursalID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CATCAJEROSATM_2` FOREIGN KEY (`UsuarioID`) REFERENCES `USUARIOS` (`UsuarioID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CATCAJEROSATM_3` FOREIGN KEY (`EstadoID`) REFERENCES `ESTADOSREPUB` (`EstadoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CATCAJEROSATM_4` FOREIGN KEY (`MunicipioID`) REFERENCES `MUNICIPIOSREPUB` (`MunicipioID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CATCAJEROSATM_8` FOREIGN KEY (`TipoCajeroID`) REFERENCES `CATTIPOCAJERO` (`TipoCajeroID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Cajeros ATM '$$