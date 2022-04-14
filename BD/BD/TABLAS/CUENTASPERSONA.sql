-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASPERSONA
DELIMITER ;
DROP TABLE IF EXISTS `CUENTASPERSONA`;
DELIMITER $$

CREATE TABLE `CUENTASPERSONA` (
  `CuentaAhoID` bigint(12) NOT NULL DEFAULT '0',
  `PersonaID` int(12) NOT NULL COMMENT 'LLave Primaria para Identificar las personas\n',
  `EsApoderado` char(1) DEFAULT NULL COMMENT 'indica si la persona es o no Apoderado	S=Si N=No',
  `EsTitular` char(1) DEFAULT NULL COMMENT 'indica si la persona es o no Titular S=Si N=No',
  `EsCotitular` char(1) DEFAULT NULL COMMENT 'indica si la persona es o no  Cotitular	S=Si N=No',
  `EsBeneficiario` char(1) DEFAULT NULL COMMENT 'indica si la persona es o no Beneficiario S=Si N=No',
  `EsProvRecurso` char(1) DEFAULT NULL COMMENT 'indica si la persona es o no Proveedor de recursos S=Si N=No',
  `EsPropReal` char(1) DEFAULT NULL COMMENT 'indica si la persona es o no Propietario real S=Si N=No	',
  `EsFirmante` char(1) DEFAULT NULL COMMENT 'indica si la persona es o no Firmante S=Si N=No',
  `EsAccionista` char(1) DEFAULT NULL COMMENT 'Indica si la persona es Accionista de la empresa, solo se encuentra disponible cuando el cliente sea persona Moral.',
  `Titulo` varchar(10) DEFAULT NULL COMMENT 'Titulo del Cliente\nTitulo del Cliente, Ej. Sr., Sra, Srita, Lic, Dr. Ing, Prof.,CP, etc',
  `PrimerNombre` varchar(50) DEFAULT NULL COMMENT 'Primer Nombre de la persona relacionada',
  `SegundoNombre` varchar(50) DEFAULT NULL COMMENT 'Segundo Nombre de la persona frimante\n',
  `TercerNombre` varchar(50) DEFAULT NULL COMMENT 'Tercer Nombre Del Cliente\n',
  `ApellidoPaterno` varchar(50) DEFAULT NULL COMMENT 'Apellido Paterno del Cliente\n',
  `ApellidoMaterno` varchar(50) DEFAULT NULL COMMENT 'Apellido Materno del Cliente\n',
  `NombreCompleto` varchar(200) DEFAULT NULL COMMENT 'Este campo no se captura, se forma en base a los nombres y apellidos\n',
  `FechaNac` date DEFAULT NULL COMMENT 'Fecha Nacimiento del Cliente o Rep Legal\n',
  `PaisNacimiento` int(5) DEFAULT NULL,
  `EdoNacimiento` int(11) DEFAULT '0' COMMENT 'Estado de nacimiento de la cuenta por persona FK a ESTADOSREPUB',
  `EstadoCivil` char(2) DEFAULT NULL COMMENT 'Clave Estado Civil:\n''S'' = Soltero\n''C''  = Casado\n''V'' = Viudo\n''D'' = Divorciado\n''S''  = Separado\n''U'' = Union Libre',
  `Sexo` char(1) DEFAULT NULL COMMENT 'Codigo de sexo del cliente\nClave Sexo:\n''M'' = Masculino\n''F''  = Femenino',
  `Nacionalidad` char(1) DEFAULT NULL COMMENT 'Nacionalidad del cliente\n''N'' = Nacional\n''E'' = Extranjero\n',
  `CURP` char(18) DEFAULT NULL COMMENT 'Clave Unica de Registro Poblacional\n',
  `RFC` char(13) DEFAULT NULL COMMENT 'Registro Federal de Contribuyentes del Cliente\n',
  `OcupacionID` int(5) DEFAULT NULL,
  `FEA` varchar(250) DEFAULT NULL COMMENT 'Firma Electrónica Avanzada, en caso de contar con ella.',
  `PaisFEA` int(11) DEFAULT NULL,
  `PaisRFC` int(11) DEFAULT NULL COMMENT 'Pais de Registro Fiscal',
  `PuestoA` varchar(100) DEFAULT NULL COMMENT 'Puesto del apoderado',
  `SectorGeneral` int(3) DEFAULT NULL COMMENT 'Sector General del Cliente,Llave Foranea Hacia tabla SECTORES\n',
  `ActividadBancoMX` varchar(15) DEFAULT NULL COMMENT 'Actividad Principal del Cte, segun Banco de Mexico,Llave Foranea Hacia tabla ACTIVIDADESBMX\n',
  `ActividadINEGI` int(5) DEFAULT NULL COMMENT 'Actividad Principal del Cte, segun INEGI,Llave Foranea Hacia tabla ACTIVIDADESINEGI\n',
  `SectorEconomico` int(3) DEFAULT NULL COMMENT 'Sector Economico Segun INEGI,Llave Foranea Hacia tabla SECTORESECONOM\n',
  `TipoIdentiID` int(11) DEFAULT NULL COMMENT 'Tipo de identificacion que usa el firmante.',
  `OtraIdentifi` varchar(20) DEFAULT NULL COMMENT 'Otra Identificacion',
  `NumIdentific` varchar(20) DEFAULT NULL COMMENT 'Numero de Identificacion',
  `FecExIden` date DEFAULT NULL COMMENT 'Fecha de expedicion de la identificacion',
  `FecVenIden` date DEFAULT NULL COMMENT 'fecha de vencimiento de la identificacion',
  `Domicilio` varchar(200) DEFAULT NULL COMMENT 'Domicilio\n',
  `TelefonoCasa` varchar(20) DEFAULT NULL COMMENT 'Telefono de casa\n',
  `TelefonoCelular` varchar(20) DEFAULT NULL COMMENT 'Telefono de celular\n',
  `Correo` varchar(50) DEFAULT NULL COMMENT 'Fax o Faxes del Cliente\n',
  `PaisResidencia` int(5) DEFAULT NULL COMMENT 'Pais de Residencian, Llave Foranea Hacia tabla PAISES',
  `DocEstanciaLegal` varchar(3) DEFAULT NULL COMMENT 'documento de estancial Legal\n',
  `DocExisLegal` varchar(30) DEFAULT NULL COMMENT 'Documento de existencia legal\n',
  `FechaVenEst` date DEFAULT NULL COMMENT 'fecha de vencimiento de la estancia',
  `NumEscPub` varchar(50) DEFAULT NULL COMMENT 'NumEscPub\n',
  `FechaEscPub` date DEFAULT NULL COMMENT 'fecha de la escritura publica',
  `EstadoID` int(11) DEFAULT NULL COMMENT 'estado donde se encuentra la notaria',
  `MunicipioID` int(11) DEFAULT NULL COMMENT 'municipio donde se encuentra la notaria',
  `NotariaID` int(11) DEFAULT NULL COMMENT 'identificador de la notaria',
  `TitularNotaria` varchar(100) DEFAULT NULL COMMENT 'titular de la notaria',
  `RazonSocial` varchar(150) DEFAULT NULL COMMENT 'Razon Social\n',
  `Fax` varchar(30) DEFAULT NULL COMMENT 'Fax o Faxes del Cliente\n',
  `ParentescoID` int(11) DEFAULT NULL COMMENT 'Parentesco',
  `Porcentaje` decimal(12,2) DEFAULT NULL,
  `ClienteID` int(11) DEFAULT NULL,
  `ExtTelefonoPart` varchar(6) DEFAULT NULL COMMENT 'Contiene el número de extensión del teléfono',
  `EstatusRelacion` char(1) DEFAULT NULL COMMENT 'Estatus de la persona relacionada a la cuenta "V" Vigente , "C" Cancelado',
  `IngresoRealoRecur` decimal(14,2) DEFAULT NULL COMMENT 'Ingresos Propietario Real o Proveedor de Recursos',
  `PorcentajeAcciones` decimal(12,4) DEFAULT NULL COMMENT 'Porcentaje que el accionista tiene en la empresa',
  `SoloNombres` varchar(500) DEFAULT '' COMMENT 'Primer Nombre, Segundo Nombre y Tercer Nombre.',
  `SoloApellidos` varchar(500) DEFAULT '' COMMENT 'Apellido Paterno y Apellido Materno.',
  `RazonSocialPLD` varchar(200) DEFAULT '' COMMENT 'Razón Social limpio de caracteres especiales.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Llave Foranea Hacia Paquete Empresa\n',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`CuentaAhoID`,`PersonaID`),
  KEY `fk_CUENTASPERSONA_2` (`SectorGeneral`),
  KEY `fk_CUENTASPERSONA_3` (`ActividadBancoMX`),
  KEY `fk_CUENTASPERSONA_4` (`ActividadINEGI`),
  KEY `fk_CUENTASPERSONA_5` (`SectorEconomico`),
  KEY `fk_CUENTASPERSONA_6` (`TipoIdentiID`),
  KEY `fk_CUENTASPERSONA_7` (`PaisResidencia`),
  KEY `fk_CUENTASPERSONA_1` (`CuentaAhoID`),
  CONSTRAINT `fk_CUENTASPERSONA_1` FOREIGN KEY (`CuentaAhoID`) REFERENCES `CUENTASAHO` (`CuentaAhoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CUENTASPERSONA_5` FOREIGN KEY (`SectorEconomico`) REFERENCES `SECTORESECONOM` (`SectorEcoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CUENTASPERSONA_7` FOREIGN KEY (`PaisResidencia`) REFERENCES `PAISES` (`PaisID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$