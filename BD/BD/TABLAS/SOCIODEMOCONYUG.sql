-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOCIODEMOCONYUG
DELIMITER ;
DROP TABLE IF EXISTS `SOCIODEMOCONYUG`;DELIMITER $$

CREATE TABLE `SOCIODEMOCONYUG` (
  `ProspectoID` int(11) DEFAULT NULL COMMENT 'Llave Foranea a PROSPECTOS (sin Integridad Relacional)',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Llave Foranea a CLIENTES (Sin Integridad relacional)',
  `FechaRegistro` date DEFAULT NULL COMMENT 'Fecha en la que se capturo los datos del conyuge',
  `ClienteConyID` int(11) DEFAULT NULL,
  `PrimerNombre` varchar(25) DEFAULT NULL COMMENT 'Primer Nombre del Conyuge',
  `SegundoNombre` varchar(25) DEFAULT NULL COMMENT 'segundo Nombre del Conyuge',
  `TercerNombre` varchar(25) DEFAULT NULL COMMENT 'tercer Nombre del Conyuge',
  `ApellidoPaterno` varchar(30) DEFAULT NULL COMMENT 'Apellido Paterno del conyuge',
  `ApellidoMaterno` varchar(30) DEFAULT NULL COMMENT 'Apellido Materno del conyuge',
  `Nacionalidad` char(1) DEFAULT NULL COMMENT 'Nacionalidad del conyuge\\n\\''N\\'' = Nacional\\n\\''E\\'' = Extranjero',
  `PaisNacimiento` int(11) DEFAULT NULL COMMENT 'Pais de Nacimiento del Conyuge',
  `EstadoNacimiento` int(11) DEFAULT NULL COMMENT 'Entidad Federativa en la que Nacio el conyuge',
  `FechaNacimiento` date DEFAULT NULL COMMENT 'Fecha de Nacimiento del Conyuge',
  `RFC` varchar(13) DEFAULT NULL COMMENT 'RFC del conyuge',
  `TipoIdentiID` int(11) DEFAULT NULL COMMENT 'Tipo de Identificacion del Conyugue',
  `FolioIdentificacion` varchar(25) DEFAULT NULL COMMENT 'Folio de la Identificacion',
  `FechaExpedicion` date DEFAULT NULL COMMENT 'Fecha de Expedicion de la Identificacion',
  `FechaVencimiento` date DEFAULT NULL COMMENT 'Fecha de Vencimiento de la Identificacion',
  `TelCelular` varchar(16) DEFAULT NULL COMMENT 'Telefono Celular',
  `OcupacionID` int(11) DEFAULT NULL COMMENT 'Id de la ocupacion del conyuge',
  `EmpresaLabora` varchar(100) DEFAULT NULL COMMENT 'Nombre de la Empresa donde labora el conyuge',
  `EntidadFedTrabajo` int(11) DEFAULT NULL COMMENT 'Entidad Federativa donde se encuentra el trabajo del conyuge',
  `MunicipioTrabajo` int(11) DEFAULT NULL COMMENT 'Municipio donde se encuentra el trabajo del conyuge',
  `LocalidadTrabajo` int(11) DEFAULT NULL COMMENT 'Identificador de la localidad donde se encuentra el trabajo del conyuge',
  `ColoniaTrabajo` int(11) DEFAULT NULL COMMENT 'Identificador de la colonia donde se encuentra el trabajo del conyuge',
  `Colonia` varchar(100) DEFAULT NULL COMMENT 'Descripcion de la colonia donde se encuentra el trabajo del conyuge',
  `Calle` varchar(100) DEFAULT NULL COMMENT 'Nombre de la calle donde se encuentra el trabajo del conyuge',
  `NumeroExterior` char(10) DEFAULT NULL COMMENT 'Numero Exterior de la Direccion del trabajo del conyuge',
  `NumeroInterior` varchar(20) DEFAULT NULL COMMENT 'Numero Interior de la Direccion del trabajo del Conyuge',
  `CodigoPostal` varchar(5) DEFAULT NULL,
  `NumeroPiso` varchar(20) DEFAULT NULL COMMENT 'Nuemro de Piso de la direccion del trabajo del Conyuge',
  `AntiguedadAnios` char(10) DEFAULT NULL COMMENT 'Antiguedad en Años del conyuge en el empleo Actual',
  `AntiguedadMeses` char(10) DEFAULT NULL COMMENT 'Antiguedad en Meses del Conyuge en el Empleo Actual',
  `TelefonoTrabajo` varchar(16) DEFAULT NULL COMMENT 'Telefono del Trabajo del Conyuge',
  `ExtencionTrabajo` varchar(6) DEFAULT NULL COMMENT 'Extencion del trabajo del conyuge',
  `FechaIniTrabajo` date DEFAULT '1900-01-01' COMMENT 'Fecha de inicio en el trabajo actual',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de auditoria',
  KEY `fk_SOCIODEMOCONYUG_1_idx` (`PaisNacimiento`),
  KEY `fk_SOCIODEMOCONYUG_2_idx` (`EstadoNacimiento`),
  KEY `fk_SOCIODEMOCONYUG_3_idx` (`TipoIdentiID`),
  KEY `fk_SOCIODEMOCONYUG_4_idx` (`OcupacionID`),
  KEY `fk_SOCIODEMOCONYUG_6_idx` (`MunicipioTrabajo`),
  KEY `idx_SOCIODEMOCONYUG_7` (`ClienteID`),
  KEY `idx_SOCIODEMOCONYUG_8` (`RFC`),
  KEY `idx_SOCIODEMOCONYUG_9` (`PrimerNombre`,`SegundoNombre`,`TercerNombre`,`ApellidoPaterno`,`ApellidoMaterno`),
  CONSTRAINT `fk_SOCIODEMOCONYUG_1` FOREIGN KEY (`PaisNacimiento`) REFERENCES `PAISES` (`PaisID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_SOCIODEMOCONYUG_2` FOREIGN KEY (`EstadoNacimiento`) REFERENCES `ESTADOSREPUB` (`EstadoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_SOCIODEMOCONYUG_3` FOREIGN KEY (`TipoIdentiID`) REFERENCES `TIPOSIDENTI` (`TipoIdentiID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Registro de los datos del conyuge'$$