-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOPORTUNIDADES
DELIMITER ;
DROP TABLE IF EXISTS `PAGOPORTUNIDADES`;DELIMITER $$

CREATE TABLE `PAGOPORTUNIDADES` (
  `Referencia` varchar(45) NOT NULL COMMENT 'Numero de Referencia o Folio  unico del pago',
  `Monto` decimal(14,2) DEFAULT NULL COMMENT 'Monto del Pago',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Solo Si es Cliente ',
  `NombreCompleto` varchar(200) DEFAULT NULL COMMENT 'Nombre Completo de la Persona o Cliente',
  `Direccion` varchar(500) DEFAULT NULL COMMENT 'Direccion Comleta de la Persona o cliente',
  `NumTelefono` varchar(20) DEFAULT NULL COMMENT 'Numero de Telefono (opcional)',
  `TipoIdentiID` int(11) DEFAULT NULL COMMENT 'Numero de Tipo de Identificacion coresponde con la tabla TIPOSIDENTI',
  `FolioIdentific` varchar(45) DEFAULT NULL COMMENT 'Folio de la identificacion ',
  `FormaPago` char(1) DEFAULT NULL COMMENT 'Forma de Pago\nR: Retiro de Efectivo\nD: Deposito a Cuenta',
  `NumeroCuenta` bigint(12) DEFAULT NULL,
  `Fecha` date DEFAULT NULL COMMENT 'Fecha del Pago',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Numero de Sucursal donde se realiza el pago corresponde con la tabla SUCURSALES',
  `CajaID` int(11) DEFAULT NULL COMMENT 'Numero de Caja donde se realiza el Pago. Corresponde con la tabla CAJASVENTANILLA',
  `MonedaID` int(11) DEFAULT NULL,
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'Numero de usuario',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`Referencia`),
  KEY `fk_PAGOPORTUNIDAES_1_idx` (`TipoIdentiID`),
  KEY `fk_PAGOPORTUNIDAES_2_idx` (`SucursalID`,`CajaID`),
  KEY `fk_PAGOPORTUNIDAES_3_idx` (`UsuarioID`),
  CONSTRAINT `fk_PAGOPORTUNIDAES_2` FOREIGN KEY (`SucursalID`, `CajaID`) REFERENCES `CAJASVENTANILLA` (`SucursalID`, `CajaID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_PAGOPORTUNIDAES_3` FOREIGN KEY (`UsuarioID`) REFERENCES `USUARIOS` (`UsuarioID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena la informacion del Pago del Programa Oportinudades'$$