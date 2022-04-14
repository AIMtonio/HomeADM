-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AVALES
DELIMITER ;
DROP TABLE IF EXISTS `AVALES`;
DELIMITER $$

CREATE TABLE `AVALES` (
  `AvalID` bigint(20) NOT NULL COMMENT 'ID o Numero del Aval',
  `TipoPersona` char(1) DEFAULT NULL COMMENT 'Tipo de Personalidad del Cliente\nM.- Persona Moral\nA.- Persona Fisica Con Actividad Empresarial\nF.- Persona Fisica Sin Actividad Empresarial',
  `RazonSocial` varchar(50) DEFAULT NULL COMMENT 'Razon Social',
  `PrimerNombre` varchar(50) DEFAULT NULL COMMENT 'Primer Nombre',
  `SegundoNombre` varchar(50) DEFAULT NULL COMMENT 'Segundo Nombre',
  `TercerNombre` varchar(50) DEFAULT NULL COMMENT 'Tercer Nombre',
  `ApellidoPaterno` varchar(50) DEFAULT NULL COMMENT 'Apellido Paterno',
  `ApellidoMaterno` varchar(50) DEFAULT NULL COMMENT 'Apellido Materno',
  `FechaNac` date DEFAULT NULL COMMENT 'Fecha de Nacimiento del Aval',
  `RFC` char(13) DEFAULT NULL COMMENT 'RFC',
  `RFCpm` varchar(12) DEFAULT NULL COMMENT 'RFC de la Persona Moral',
  `Telefono` char(13) DEFAULT NULL COMMENT 'Telefono',
  `TelefonoCel` varchar(13) DEFAULT NULL COMMENT 'Telefono Celular del Aval',
  `NombreCompleto` varchar(200) DEFAULT NULL COMMENT 'Nombre Completo',
  `Calle` varchar(50) DEFAULT NULL COMMENT 'Calle',
  `NumExterior` char(10) DEFAULT NULL COMMENT 'Numero de Casa',
  `NumInterior` char(10) DEFAULT NULL COMMENT 'Numero de Casa Interior',
  `Manzana` varchar(20) DEFAULT NULL COMMENT 'Manzana del Domicilio',
  `Lote` varchar(20) DEFAULT NULL COMMENT 'Lote del Domicilio',
  `Colonia` varchar(200) DEFAULT NULL COMMENT 'Colonia',
  `MunicipioID` int(11) DEFAULT NULL COMMENT 'Numero del Municipio',
  `EstadoID` int(11) DEFAULT NULL COMMENT 'Numero del Estado del Domicilio',
  `CP` varchar(5) DEFAULT NULL COMMENT 'Codigo Postal',
  `Latitud` varchar(45) DEFAULT NULL COMMENT 'Latitud de \nubicacion',
  `Longitud` varchar(45) DEFAULT NULL COMMENT 'Altitud de ubicación',
  `LocalidadID` int(11) DEFAULT NULL COMMENT 'hace referencia con la tabla LOCALIDADREPUB',
  `ColoniaID` int(11) DEFAULT NULL COMMENT 'Hace referencia con la tabla COLONIASREPUB',
  `Sexo` char(1) DEFAULT NULL,
  `EstadoCivil` char(2) DEFAULT NULL,
  `DireccionCompleta` varchar(500) DEFAULT NULL,
  `ExtTelefonoPart` varchar(6) DEFAULT NULL COMMENT 'Contiene el número de extesión de teléfono',
  `Nacion` char(1) DEFAULT NULL COMMENT 'Nacionalidad del aval\n''N'' = Nacional\n''E'' = Extranjero',
  `LugarNacimiento` int(11) DEFAULT NULL COMMENT 'Pais de Nacimiento, llave foranea a PAISES',
  `OcupacionID` int(11) NOT NULL COMMENT 'Identificador de la ocupacion del aval',
  `Puesto` varchar(100) NOT NULL COMMENT 'Puesto de trabajo del aval',
  `DomicilioTrabajo` varchar(500) NOT NULL COMMENT 'Domicilio de trabajo del aval',
  `TelefonoTrabajo` varchar(13) NOT NULL COMMENT 'Telefono de trabajo del aval',
  `ExtTelTrabajo` varchar(4) NOT NULL COMMENT 'Extension del telefono de trabajo del aval',
  `NumIdentific` varchar(18) DEFAULT NULL COMMENT 'Es el numero de identificacion del Aval',
  `FecExIden` date DEFAULT NULL COMMENT 'Fecha de Expedicion de la Identificacion del Aval',
  `FecVenIden` date DEFAULT NULL COMMENT 'Fecha de Vencimiento de la Identificacion del Aval',
  `SoloNombres` varchar(500) DEFAULT '' COMMENT 'Primer Nombre, Segundo Nombre y Tercer Nombre.',
  `SoloApellidos` varchar(500) DEFAULT '' COMMENT 'Apellido Paterno y Apellido Materno.',
  `RazonSocialPLD` varchar(200) DEFAULT '' COMMENT 'Razón Social limpio de caracteres especiales.';
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Usuario que dio de alta o modifico',
  `FechaActual` date DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` int(11) DEFAULT NULL,
  PRIMARY KEY (`AvalID`),
  KEY `fk_AVALES_Municipios` (`MunicipioID`,`EstadoID`),
  KEY `fk_AVALES_Estados` (`EstadoID`),
  CONSTRAINT `fk_AVALES_Estados` FOREIGN KEY (`EstadoID`) REFERENCES `ESTADOSREPUB` (`EstadoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_AVALES_Municipios` FOREIGN KEY (`MunicipioID`, `EstadoID`) REFERENCES `MUNICIPIOSREPUB` (`MunicipioID`, `EstadoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$