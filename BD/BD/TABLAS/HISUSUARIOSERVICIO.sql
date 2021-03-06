-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISUSUARIOSERVICIO
DELIMITER ;
DROP TABLE IF EXISTS `HISUSUARIOSERVICIO`;DELIMITER $$

CREATE TABLE `HISUSUARIOSERVICIO` (
  `NumTransaccionAct` bigint(20) NOT NULL COMMENT 'Numero de Transaccion que realizo la actualización de los datos',
  `UsuarioServicioID` int(11) NOT NULL COMMENT 'Usuario ID',
  `TipoPersona` char(1) DEFAULT NULL COMMENT 'Tipo de Responsabilidad del Usuario \nM.- Persona Moral \nA.- Persona Fisica Con Actividad Empresarial \nF.- Persona Fisica Sin Actividad Empresarial',
  `PrimerNombre` varchar(50) DEFAULT NULL COMMENT 'Primer Nombre del Usuario de Servicios',
  `SegundoNombre` varchar(50) DEFAULT NULL COMMENT 'Segundo Nombre del Usuario de Servicios',
  `TercerNombre` varchar(50) DEFAULT NULL COMMENT 'Tercer Nombre del Usuario de Servicios',
  `ApellidoPaterno` varchar(50) DEFAULT NULL COMMENT 'Apellido Paterno del Usuario de Servicios',
  `ApellidoMaterno` varchar(50) DEFAULT NULL COMMENT 'Apellido Materno del Usuario de Servicios',
  `FechaNacimiento` date DEFAULT NULL COMMENT 'Fecha de Nacimiento del Usuario de Servicios',
  `Nacionalidad` char(1) DEFAULT NULL COMMENT 'Nacionalidad del Usuario de Servicios\n''N'' = Nacional\n''E'' = Extranjero',
  `PaisNacimiento` int(11) DEFAULT NULL COMMENT 'Pais de Nacimiento, llave foranea a PAISES',
  `EstadoNacimiento` int(11) DEFAULT NULL COMMENT 'Pais de Nacimiento, llave foranea a ESTADOSREPUB',
  `Sexo` char(1) DEFAULT NULL COMMENT 'Codigo de sexo del Usuario de Servicios\nClave Sexo:\n''M'' = Masculino\n''F''  = Femenino',
  `CURP` char(18) DEFAULT NULL COMMENT 'Clave Unica de Registro Poblacional',
  `RazonSocial` varchar(150) DEFAULT NULL COMMENT 'Razon Social, tratandose de Personas Morales',
  `TipoSociedadID` int(11) DEFAULT NULL COMMENT 'Tipo de Sociedad, tiene llave foranea a la tabla  TIPOSOCIEDAD, para personas Morales',
  `RFC` char(13) DEFAULT NULL COMMENT 'Registro Federal de Contribuyentes del Usuario de Servicios',
  `RFCpm` char(13) DEFAULT NULL COMMENT 'Registro Federal de Contribuyentes del Usuario de Servicios, cuando esta sea Persona Moral',
  `RFCOficial` char(13) DEFAULT NULL COMMENT 'RFC del cliente ya sea RFC que es asignado como persona fisica o el RFC como persona moral',
  `FEA` varchar(250) DEFAULT NULL COMMENT 'Firma Electrónica Avanzada, en caso de contar con ella.',
  `FechaConstitucion` date DEFAULT NULL COMMENT 'Fecha de Constitucion ante el Registro Federal de Contribuyentes.',
  `PaisRFC` int(11) DEFAULT NULL COMMENT 'Pais que Asigna el Registro Federal de Contribuyentes.',
  `OcupacionID` int(5) DEFAULT NULL COMMENT 'Profesión del cliente,Llave Foranea Hacia tabla OCUPACIONES',
  `NombreCompleto` varchar(200) DEFAULT NULL COMMENT 'Este campo no se captura, se forma en base a los nombres y apellidos',
  `SucursalOrigen` int(11) DEFAULT NULL COMMENT 'No de Sucursal en la que se da de Alta el Usuario, Llave Foranea Hacia Tabla SUCURSALES',
  `PaisResidencia` int(11) DEFAULT NULL COMMENT 'Pais de Residencia, Llave Foranea Hacia tabla PAISES',
  `TipoDireccionID` int(11) DEFAULT NULL COMMENT 'ID de el tipo de Dirección del Usuario de Servicios,Llave Foranea de TIPOSDIRECCION.',
  `EstadoID` int(11) DEFAULT NULL COMMENT 'Hace referencia al ID del Estado del Usuario de Servicios',
  `MunicipioID` int(11) DEFAULT NULL COMMENT 'Hace referencia al ID del muncipio del Usuario de Servicios',
  `LocalidadID` int(11) DEFAULT NULL COMMENT 'Numero de Localidad del Usuario de Servicios, llave foranea de LOCALIDADREPUB',
  `ColoniaID` int(11) DEFAULT NULL COMMENT 'Numero de Colonia del Usuario de Servicios, llave foranea de COLONIASREPUB',
  `Calle` varchar(50) DEFAULT NULL COMMENT 'Nombre de la calle del domicilio',
  `NumExterior` varchar(10) DEFAULT NULL COMMENT 'Numero Exterior del domicilio',
  `NumInterior` varchar(10) DEFAULT NULL COMMENT 'Numero Interior del domicilio',
  `CP` char(5) DEFAULT NULL COMMENT 'Codigo Postal del domicilio',
  `NumIdenti` varchar(30) DEFAULT NULL COMMENT 'Numero de identificacion del documento de identifiación del Usuario de Servicios',
  `FecExIden` date DEFAULT NULL COMMENT 'Fecha de Expedición de la Identificación',
  `FecVenIden` date DEFAULT NULL COMMENT 'Fecha de Vencimiento de la Identificación',
  `DocEstanciaLegal` varchar(3) DEFAULT NULL COMMENT 'Documento de Estancial Legal',
  `DocExisLegal` varchar(30) DEFAULT NULL COMMENT 'Documento de Existencia Legal',
  `FechaVenEst` date DEFAULT NULL COMMENT 'Fecha de Vencimiento de la Estancia',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(45) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria',
  PRIMARY KEY (`UsuarioServicioID`,`NumTransaccionAct`),
  KEY `fk_HISUSUARIOSERVICIO_1_idx` (`PaisNacimiento`),
  KEY `fk_HISUSUARIOSERVICIO_2_idx` (`EstadoNacimiento`),
  KEY `fk_HISUSUARIOSERVICIO_6_idx` (`SucursalOrigen`),
  KEY `fk_HISUSUARIOSERVICIO_7_idx` (`PaisResidencia`),
  KEY `fk_HISUSUARIOSERVICIO_8_idx` (`EstadoID`),
  KEY `fk_HISUSUARIOSERVICIO_9_idx` (`MunicipioID`),
  KEY `fk_HISUSUARIOSERVICIO_10_idx` (`LocalidadID`),
  KEY `fk_HISUSUARIOSERVICIO_11_idx` (`ColoniaID`),
  KEY `fk_HISUSUARIOSERVICIO_3` (`TipoDireccionID`),
  CONSTRAINT `fk_HISUSUARIOSERVICIO_1` FOREIGN KEY (`PaisNacimiento`) REFERENCES `PAISES` (`PaisID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_HISUSUARIOSERVICIO_10` FOREIGN KEY (`LocalidadID`) REFERENCES `LOCALIDADREPUB` (`LocalidadID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_HISUSUARIOSERVICIO_11` FOREIGN KEY (`ColoniaID`) REFERENCES `COLONIASREPUB` (`ColoniaID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_HISUSUARIOSERVICIO_2` FOREIGN KEY (`EstadoNacimiento`) REFERENCES `ESTADOSREPUB` (`EstadoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_HISUSUARIOSERVICIO_3` FOREIGN KEY (`TipoDireccionID`) REFERENCES `TIPOSDIRECCION` (`TipoDireccionID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_HISUSUARIOSERVICIO_6` FOREIGN KEY (`SucursalOrigen`) REFERENCES `SUCURSALES` (`SucursalID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_HISUSUARIOSERVICIO_7` FOREIGN KEY (`PaisResidencia`) REFERENCES `PAISES` (`PaisID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_HISUSUARIOSERVICIO_8` FOREIGN KEY (`EstadoID`) REFERENCES `ESTADOSREPUB` (`EstadoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_HISUSUARIOSERVICIO_9` FOREIGN KEY (`MunicipioID`) REFERENCES `MUNICIPIOSREPUB` (`MunicipioID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla Historica de los Modificaciones de los Registros de la tabla de USUARIOSERVICIO'$$