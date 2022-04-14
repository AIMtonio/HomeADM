-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GARANTES
DELIMITER ;
DROP TABLE IF EXISTS `GARANTES`;


  `GaranteID` int(11) NOT NULL COMMENT 'LLave Primaria para Identificar los Garantes\n',
  `TipoPersona` char(1) DEFAULT NULL COMMENT 'Tipo de Persona del Garante M.- Persona Moral A.- Persona Fisica Con Actividad Empresarial F.- Persona Fisica Sin Actividad Empresarial\n',
  `Titulo` varchar(10) DEFAULT NULL COMMENT 'Titulo del Garante, Ej. Sr., Sra, Srita, Lic, Dr. Ing, Prof.,CP, etc',
  `PrimerNombre` varchar(50) DEFAULT NULL COMMENT 'Primer Nombre del Garante',
  `SegundoNombre` varchar(50) DEFAULT NULL COMMENT 'Segundo Nombre del Garante',
  `TercerNombre` varchar(50) DEFAULT NULL COMMENT 'Tercer Nombre Del Garante',
  `ApellidoPaterno` varchar(50) DEFAULT NULL COMMENT 'Apellido Paterno del Garante',
  `ApellidoMaterno` varchar(50) DEFAULT NULL COMMENT 'Apellido Materno del Garante',
  `FechaNacimiento` date DEFAULT NULL COMMENT 'Fecha Nacimiento del Garante o Rep Legal',
  `Nacion` char(1) DEFAULT NULL COMMENT 'Nacionalidad del Garante\n''N'' = Nacional\n''E'' = Extranjero\n',
  `LugarNacimiento` int(11) DEFAULT NULL COMMENT 'Pais de Nacimiento, llave foranea a PAISES',
  `EstadoID` int(11) DEFAULT NULL COMMENT 'Identificador de Estado que se encuentra en la tabla ESTADOSREPUB',
  `PaisResidencia` int(5) DEFAULT NULL COMMENT 'Pais de Residencia, Llave Foranea a PAISES',
  `Sexo` char(1) DEFAULT NULL COMMENT 'Codigo de sexo del Garante\nClave Sexo:\n''M'' = Masculino\n''F''  = Femenino',
  `CURP` char(18) DEFAULT NULL COMMENT 'Clave Unica de Registro de la Poblacion\n',
  `RegistroHacienda` char(1) DEFAULT NULL COMMENT 'Indica si el Garante esta Registrado ante Hacienda',
  `RFC` char(13) DEFAULT NULL COMMENT 'Registro Federal de Contribuyentes del Garante\n',
  `FechaConstitucion` date DEFAULT '1900-01-01' COMMENT 'Fecha de Constitucion ante el Registro Federal de Contribuyentes.',
  `EstadoCivil` char(2) DEFAULT NULL COMMENT 'Clave Estado Civil:\\n\\''S\\'' = Soltero\\n\\''CS\\''  = Casado Bienes Separados\\n\\''CM\\''  = Casado Bienes Mancomunados\\n\\''CC\\''  = Casado Bienes Mancomunados Con Capitulacion\\n\\''V\\'' = Viudo\\n\\''D\\'' = Divorciado\\n\\''SE\\''  = Separado\\n\\''U\\'' = Union Libre',
  `TelefonoCelular` varchar(20) DEFAULT NULL COMMENT 'Telefono Celular del Garante\n',
  `Telefono` varchar(20) DEFAULT NULL COMMENT 'Telefonos del Garante\n',
  `ExtTelefonoPart` varchar(7) DEFAULT NULL COMMENT 'No. de Extension del Telefono de Trabajo',
  `Correo` varchar(50) DEFAULT NULL COMMENT 'Correo Electronico del Garante\n',
  `Fax` varchar(30) DEFAULT NULL COMMENT 'Fax o Faxes del Garante\n',
  `Observaciones` varchar(800) DEFAULT NULL COMMENT 'Observaciones sobre el Garante. Opcional',
  `RazonSocial` varchar(150) DEFAULT NULL COMMENT 'Razon Social\n',
  `RFCpm` char(13) DEFAULT NULL COMMENT 'RFC de persona moral',
  `RFCOficial` char(13) DEFAULT NULL COMMENT 'RFC del Garante ya sea RFC que es asignado como persona fisica o el RFC como persona moral',
  `PaisConstitucionID` int(11) DEFAULT NULL COMMENT 'Pais de Constitucion de la empresa',
  `CorreoAlterPM` varchar(50) DEFAULT NULL COMMENT 'Correo Alternativo Persona Moral',
  `TipoSociedadID` int(11) DEFAULT NULL COMMENT 'Tipo de Sociedad, tiene llave foranea a la tabla  TIPOSOCIEDAD si existe pero no es necesaria',
  `GrupoEmpresarial` int(11) DEFAULT NULL COMMENT 'Llave Foranea Hacia tabla GRUPOSEMP si existe pero no es necesaria.\n',
  `FEA` varchar(250) DEFAULT NULL COMMENT 'Firma Electrónica Avanzada, en caso de contar con ella.',
  `PaisFEA` int(11) DEFAULT NULL COMMENT 'Pais de origen de la Firma Electronica.',
  `NombreCompleto` varchar(200) DEFAULT NULL COMMENT 'Este campo no se captura, se forma en base a los nombres y apellidos\n',
  `TipoIdentiID` int(11) NOT NULL COMMENT 'Tipo de Identificacion del Garante',
  `NumIdentific` varchar(30) DEFAULT NULL COMMENT 'Numero de Identificacion del Garante',
  `FecExIden` date DEFAULT '1900-01-01' COMMENT 'Fecha de Expedicion de la Identificacion del Garante',
  `FecVenIden` date DEFAULT '1900-01-01' COMMENT 'Fecha de Vencimiento de la Identificacion del Garante',
  `EstadoIDDir` int(11) DEFAULT NULL COMMENT 'Hace referencia al ID del Estado del Garante',
  `MunicipioID` int(11) DEFAULT NULL COMMENT 'Hace referencia al ID del Muncipio del Garante ',
  `LocalidadID` int(11) DEFAULT NULL COMMENT 'Numero de Localidad Correspondiente al Municipio del Garante',
  `ColoniaID` int(11) DEFAULT NULL COMMENT 'Nombre de la colonia del Garante',
  `Calle` varchar(50) DEFAULT NULL COMMENT 'Nombre de la calle del Garante',
  `NumeroCasa` char(10) DEFAULT NULL COMMENT 'Numero de casa del Garante',
  `NumInterior` char(10) DEFAULT NULL COMMENT 'Numero interior de la casa del Garante',
  `CP` char(5) DEFAULT NULL COMMENT 'Codigo Postal de la Direccion del Garante',
  `Lote` char(50) DEFAULT NULL COMMENT 'Lote de la Direccion del Garante',
  `Manzana` char(50) DEFAULT NULL COMMENT 'Manzana de la Direccion del Garante',
  `DireccionCompleta` varchar(500) DEFAULT NULL COMMENT 'Direccion Completa del Garante.',
  `Esc_Tipo` char(1) DEFAULT NULL COMMENT 'Tipo de Acta\nC. Constitutiva\nP. De Poderes   ',
  `EscrituraPublic` varchar(50) DEFAULT NULL COMMENT 'Numero de la Escritura Publica',
  `LibroEscritura` varchar(50) DEFAULT NULL COMMENT 'Libro en que se encuentra la Escritura Publica',
  `VolumenEsc` varchar(20) DEFAULT NULL COMMENT 'Volumen de la Escritura Publica',
  `FechaEsc` date DEFAULT NULL COMMENT 'Fecha de Escritura Pública',
  `EstadoIDEsc` int(11) DEFAULT NULL COMMENT 'Estado de la Escritura Publica',
  `MunicipioEsc` int(11) DEFAULT NULL COMMENT 'Municipio de la Escritura Publica',
  `Notaria` int(11) DEFAULT NULL COMMENT 'Numero de la Notaria ',
  `NomApoderado` varchar(150) DEFAULT NULL COMMENT 'Nombre del Apoderado',
  `RFC_Apoderado` varchar(13) DEFAULT NULL COMMENT 'RFC del Apoderado',
  `RegistroPub` varchar(10) DEFAULT NULL COMMENT 'Numero de Registro Publico',
  `FolioRegPub` varchar(10) DEFAULT NULL COMMENT 'Folio de Registro Publico',
  `VolumenRegPub` varchar(20) DEFAULT NULL COMMENT 'Volumen de Registro Publico',
  `LibroRegPub` varchar(10) DEFAULT NULL COMMENT 'Libro de Registro Publico',
  `AuxiliarRegPub` varchar(20) DEFAULT NULL COMMENT 'Auxiliar de Registro Publico',
  `FechaRegPub` date DEFAULT NULL COMMENT 'Fecha de Registro Publico',
  `EstadoIDReg` int(11) DEFAULT NULL COMMENT 'Estado de Registro Publico',
  `MunicipioRegPub` int(11) DEFAULT NULL COMMENT 'Municipio de Registro Publico',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`GaranteID`),
  KEY `INDEX_GARANTES_1` (`PaisResidencia`),
  KEY `INDEX_GARANTES_2` (`EstadoID`),
  KEY `INDEX_GARANTES_3` (`RFCOficial`),
  KEY `INDEX_GARANTES_4` (`TelefonoCelular`),
  KEY `INDEX_GARANTES_5` (`LugarNacimiento`),
  KEY `INDEX_GARANTES_6` (`Correo`),
  KEY `INDEX_GARANTES_7` (`PaisConstitucionID`),
  KEY `INDEX_GARANTES_9` (`EstadoID`),
  CONSTRAINT `FK_GARANTES_1` FOREIGN KEY (`LugarNacimiento`) REFERENCES `PAISES` (`PaisID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_GARANTES_2` FOREIGN KEY (`PaisConstitucionID`) REFERENCES `PAISES` (`PaisID`),
  CONSTRAINT `FK_GARANTES_3` FOREIGN KEY (`PaisResidencia`) REFERENCES `PAISES` (`PaisID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_GARANTES_4` FOREIGN KEY (`EstadoID`) REFERENCES `ESTADOSREPUB` (`EstadoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_GARANTES_6` FOREIGN KEY (`EstadoID`) REFERENCES `ESTADOSREPUB` (`EstadoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla que almancena los datos de todos los garantes.'$$