
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROVEEDORES
DELIMITER ;
DROP TABLE IF EXISTS `PROVEEDORES`;

DELIMITER $$
CREATE TABLE `PROVEEDORES` (
  `ProveedorID` int(11) NOT NULL,
  `InstitucionID` int(11) DEFAULT NULL,
  `ApellidoPaterno` varchar(50) DEFAULT NULL,
  `ApellidoMaterno` varchar(50) DEFAULT NULL,
  `PrimerNombre` varchar(50) DEFAULT NULL,
  `SegundoNombre` varchar(50) DEFAULT NULL,
  `TipoPersona` char(1) DEFAULT NULL,
  `FechaNacimiento` date DEFAULT NULL,
  `CURP` char(18) DEFAULT NULL,
  `RazonSocial` varchar(150) DEFAULT NULL,
  `RFC` char(13) DEFAULT NULL,
  `RFCpm` char(13) DEFAULT NULL,
  `TipoPago` char(1) DEFAULT NULL,
  `CuentaClave` char(18) DEFAULT NULL,
  `CuentaCompleta` char(25) DEFAULT NULL COMMENT 'Cuenta Contable donde contabilizara la Cuenta por PAGAR',
  `CuentaAnticipo` char(25) DEFAULT NULL,
  `TipoProveedor` int(11) DEFAULT NULL COMMENT 'Tipo de proveedor de acuerdo a clasificacion contable',
  `Correo` varchar(50) DEFAULT NULL COMMENT 'Correo del contacto \ndel proveedor',
  `Telefono` varchar(20) DEFAULT NULL COMMENT 'Telefono Celular \ndel contacto\ndel proveedor',
  `TelefonoCelular` varchar(20) DEFAULT NULL COMMENT 'Telefono Celular \ndel contacto\ndel proveedor',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus del proveedor\nA .- Activo\nB .- Baja',
  `ExtTelefonoPart` varchar(6) DEFAULT NULL COMMENT 'Contiene el número de extansión de teléfono',
  `TipoTerceroID` varchar(2) DEFAULT NULL COMMENT 'Tipo Tercero DIOT',
  `TipoOperacionID` varchar(4) DEFAULT NULL COMMENT 'Tipo Operacion (DIOT)',
  `PaisID` varchar(2) DEFAULT NULL COMMENT 'Pais (Catalogo de Paises DIOT)',
  `Nacionalidad` varchar(20) DEFAULT NULL COMMENT 'Nacionalidad',
  `NumIDFiscal` varchar(40) DEFAULT NULL COMMENT 'Num. de ID Fiscal.',
  `PaisNacimiento` int(11) DEFAULT NULL COMMENT 'Pais de Nacimiento.',
  `EstadoNacimiento` int(11) DEFAULT NULL COMMENT 'Entidad Federeativa de Nacimiento sólo cuando el país sea México.',
  `SoloNombres` varchar(500) NOT NULL COMMENT 'Primer Nombre y Segundo Nombre',
  `SoloApellidos` varchar(500) NOT NULL COMMENT 'Apellido Paterno y Apellido Materno',
  `RazonSocialPLD` varchar(200) DEFAULT '' COMMENT 'Razón Social limpio de caracteres especiales.',
  `NombreCompleto` varchar(200) DEFAULT '' COMMENT 'Nombre completo del Proveedor. Nombres y apellidos o Razon Social de la persona.',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`ProveedorID`),
  KEY `fk_PROVEEDORES_1` (`CuentaCompleta`),
  KEY `fk_PROVEEDORES_2` (`TipoProveedor`),
  KEY `INDEX_PROVEEDORES_1` (`SoloNombres`,`SoloApellidos`,`RFC`,`FechaNacimiento`,`PaisNacimiento`,`EstadoNacimiento`,`Estatus`,`TipoPersona`),
  KEY `INDEX_PROVEEDORES_2` (`SoloNombres`,`SoloApellidos`,`FechaNacimiento`,`RFC`,`Estatus`,`TipoPersona`),
  KEY `INDEX_PROVEEDORES_3` (`SoloNombres`,`SoloApellidos`,`PaisNacimiento`,`EstadoNacimiento`,`Estatus`,`TipoPersona`),
  KEY `INDEX_PROVEEDORES_4` (`SoloNombres`,`RFC`,`FechaNacimiento`,`PaisNacimiento`,`EstadoNacimiento`,`Estatus`,`TipoPersona`),
  KEY `INDEX_PROVEEDORES_5` (`SoloApellidos`,`RFC`,`FechaNacimiento`,`PaisNacimiento`,`EstadoNacimiento`,`Estatus`,`TipoPersona`),
  KEY `INDEX_PROVEEDORES_6` (`RazonSocial`,`RFCpm`,`Estatus`,`TipoPersona`),
  CONSTRAINT `fk_PROVEEDORES_1` FOREIGN KEY (`CuentaCompleta`) REFERENCES `CUENTASCONTABLES` (`CuentaCompleta`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_PROVEEDORES_2` FOREIGN KEY (`TipoProveedor`) REFERENCES `TIPOPROVEEDORES` (`TipoProveedorID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Proveedores'$$

