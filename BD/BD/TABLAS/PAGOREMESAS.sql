-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOREMESAS
DELIMITER ;
DROP TABLE IF EXISTS `PAGOREMESAS`;DELIMITER $$

CREATE TABLE `PAGOREMESAS` (
  `RemesaFolio` varchar(45) NOT NULL COMMENT 'Referencia de la Remesa',
  `Monto` decimal(14,2) DEFAULT NULL COMMENT 'Cantidad de la Remesa',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Solo en caso de ser cliente.',
  `NombreCompleto` varchar(200) DEFAULT NULL COMMENT 'Nombre completo de la persona o cliente',
  `Direccion` varchar(500) DEFAULT NULL COMMENT 'Direccion de la perosna o cliente',
  `NumTelefono` varchar(20) DEFAULT NULL COMMENT 'Numero de Telefono de la persona que recibe la remesa',
  `TipoIdentiID` int(11) DEFAULT NULL COMMENT 'Numero de identificacion. Corresponde con la tabla TIPOSIDENTI',
  `FolioIdentific` varchar(45) DEFAULT NULL COMMENT 'Numero de Folio de la identificacion',
  `FormaPago` char(1) DEFAULT NULL COMMENT 'Forma de Pago\nR: Retiro de Efectivo\nD: Deposito a Cuenta\nC: Cheque',
  `NumeroCuenta` bigint(12) DEFAULT NULL,
  `Fecha` date DEFAULT NULL COMMENT 'Fecha de Pago de la Remesa',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Sucursal en la que se Pago la remesa',
  `CajaID` int(11) DEFAULT NULL COMMENT 'Numero de Caja en la que se pago la remesa',
  `MonedaID` int(11) DEFAULT NULL,
  `UsuarioID` int(11) DEFAULT NULL,
  `RemesaCatalogoID` int(11) DEFAULT NULL COMMENT 'Id de la tabla REMESACATALOGO',
  `NumeroImpresiones` int(11) DEFAULT NULL COMMENT 'Indica el numero de impresiones',
  `Origen` varchar(10) DEFAULT NULL COMMENT 'Indica el Origen de la transaccion',
  `CLABE` varchar(18) DEFAULT NULL COMMENT 'Indica la clabe del cliente',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`RemesaFolio`),
  KEY `fk_REMESAS_2_idx` (`TipoIdentiID`),
  KEY `fk_REMESAS_3_idx` (`SucursalID`,`CajaID`),
  KEY `fk_REMESAS_4_idx` (`MonedaID`),
  KEY `fk_REMESAS_5_idx` (`UsuarioID`),
  KEY `fk_PAGOREMESAS_1_idx` (`RemesaCatalogoID`),
  CONSTRAINT `fk_REMESAS_1` FOREIGN KEY (`RemesaCatalogoID`) REFERENCES `REMESACATALOGO` (`RemesaCatalogoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_REMESAS_2` FOREIGN KEY (`TipoIdentiID`) REFERENCES `TIPOSIDENTI` (`TipoIdentiID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_REMESAS_3` FOREIGN KEY (`SucursalID`, `CajaID`) REFERENCES `CAJASVENTANILLA` (`SucursalID`, `CajaID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_REMESAS_4` FOREIGN KEY (`MonedaID`) REFERENCES `MONEDAS` (`MonedaId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_REMESAS_5` FOREIGN KEY (`UsuarioID`) REFERENCES `USUARIOS` (`UsuarioID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena informacion referente a las remesas pagadas'$$ 