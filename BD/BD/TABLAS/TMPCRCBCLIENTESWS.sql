-- TMPCRCBCLIENTESWS
DELIMITER ;
DROP TABLE IF EXISTS TMPCRCBCLIENTESWS;

DELIMITER $$
CREATE TABLE `TMPCRCBCLIENTESWS` (
  `NumRegistro` bigint(20) unsigned NOT NULL COMMENT 'Identificador de la registro correspondiente al cliente que se intentara dar de alta',
  `FechaCarga` date DEFAULT NULL COMMENT 'Fecha de carga del registro de acuerdo a la tabla CS_CRCBCLIENTESWS',
  `FolioCarga` int(11) NOT NULL COMMENT 'Folio de carga del registro de acuerdo a la tabla CS_CRCBCLIENTESWS',
  `PrimerNombre` varchar(50) DEFAULT '' COMMENT 'Primer Nombre del Cliente',
  `SegundoNombre` varchar(50) DEFAULT '' COMMENT 'Segundo Nombre del Cliente',
  `TercerNombre` varchar(50) DEFAULT '' COMMENT 'Tercer Nombre del Cliente',
  `ApellidoPaterno` varchar(50) DEFAULT '' COMMENT 'Apellido Paterno del Cliente',
  `ApellidoMaterno` varchar(50) DEFAULT '' COMMENT 'Apellido Materno del Cliente',
  `FechaNacimiento` date DEFAULT '1900-01-01' COMMENT 'Fecha de Nacimiento del Cliente',
  `CURP` char(18) DEFAULT '' COMMENT 'CURP del Cliente',
  `EstadoNacimientoID` int(11) DEFAULT '0' COMMENT 'ID Estado de Nacimiento',
  `Sexo` char(1) DEFAULT '' COMMENT 'Sexo del Cliente',
  `Telefono` varchar(20) DEFAULT '' COMMENT 'Telefono Oficial del Cliente',
  `TelefonoCelular` varchar(20) DEFAULT '' COMMENT 'Telefono Celular del Cliente',
  `Correo` varchar(50) DEFAULT '' COMMENT 'Correo Electronico del Cliente',
  `RFC` char(13) DEFAULT '' COMMENT 'RFC del Cliente',
  `OcupacionID` int(11) DEFAULT '0' COMMENT 'Ocupaciones Valor Por Defecto 9999 (OTROS Trabajadores Con Ocupaciones Insuficientemente Especificadas)',
  `LugardeTrabajo` varchar(150) DEFAULT '' COMMENT 'Lugar de Trabajo del Cliente',
  `Puesto` varchar(150) DEFAULT '' COMMENT 'Puesto de Trabajo del Cliente',
  `TelTrabajo` varchar(20) DEFAULT '' COMMENT 'Telefono Trabajo del Cliente',
  `NoEmpleado` varchar(20) DEFAULT '' COMMENT 'Indica el Numero de Empleado de la Empresa de Nomina a la que esta ligado el Cliente',
  `AntiguedadTra` decimal(12,0) DEFAULT '0' COMMENT 'Antiguedad del Trabajo',
  `ExtTelefonoTrab` varchar(10) DEFAULT '' COMMENT 'Extension del Telefono Trabajo del Cliente',
  `TipoEmpleado` char(1) DEFAULT '' COMMENT 'Tipo de Empleado',
  `TipoPuesto` int(11) DEFAULT '0' COMMENT 'Tipo de Puesto',
  `SucursalOrigen` int(5) DEFAULT '0' COMMENT 'ID Sucursal del Cliente',
  `TipoPersona` char(1) DEFAULT '' COMMENT 'Tipo de Personalidad del Cliente M.- Persona Moral A.- Persona Fisica Con Actividad Empresarial F.- Persona Fisica Sin Actividad Empresarial',
  `Titulo` varchar(10) DEFAULT '' COMMENT 'Titulo del Cliente',
  `PaisResidencia` int(5) DEFAULT '0' COMMENT 'ID Pais de Residencia del Cliente',
  `SectorGeneral` int(3) DEFAULT '0' COMMENT 'ID Sector General',
  `ActividadBancoMX` varchar(15) DEFAULT '' COMMENT 'ID Actividad BMX hace referencia a la tabla ACTIVIDADESBMX',
  `EstadoCivil` char(2) DEFAULT '' COMMENT 'Estado Cividl del Cliente',
  `LugarNacimiento` int(11) DEFAULT '0' COMMENT 'Pais Lugar de Nacimiento',
  `PromotorInicial` int(6) DEFAULT '0' COMMENT 'ID Promotor Inicial',
  `PromotorActual` int(6) DEFAULT '0' COMMENT 'ID Promotor Actual',
  `ExtTelefonoPart` varchar(7) DEFAULT '' COMMENT 'Extension del Telefono Particular',
  `TipoDireccionID` int(11) DEFAULT '0' COMMENT 'Tipo de Direccion',
  `EstadoID` int(11) DEFAULT '0' COMMENT 'ID Estado del Cliente',
  `MunicipioID` int(11) DEFAULT '0' COMMENT 'ID Municipio del Cliente',
  `LocalidadID` int(11) DEFAULT '0' COMMENT 'ID Localidad del Cliente',
  `ColoniaID` int(11) DEFAULT '0' COMMENT 'ID Colonia del Cliente',
  `Calle` varchar(50) DEFAULT '' COMMENT 'Nombre de la Calle',
  `Numero` char(10) DEFAULT '' COMMENT 'Numero de la Vivienda del Cliente',
  `CP` char(5) DEFAULT '' COMMENT 'Codigo Postal Direccion del Cliente',
  `Oficial` char(1) DEFAULT '' COMMENT 'Valor de direccion Oficial S=SI N=No',
  `Fiscal` char(1) DEFAULT '' COMMENT 'Valor de direccion Fiscal S=SI N=No',
  `NumInterior` char(10) DEFAULT '' COMMENT 'Numero Interior de la Casa o Edificio',
  `Lote` char(50) DEFAULT '' COMMENT 'Numero de Lote la Vivienda del Cliente',
  `Manzana` char(50) DEFAULT '' COMMENT 'Numero de Manzana de la Vivienda del Cliente',
  `TipoIdentiID` int(11) DEFAULT '0' COMMENT 'Tipo de Identificacion del Cliente',
  `NumIdentific` varchar(30) DEFAULT '' COMMENT 'Numero de Identificacion del Documento del Cliente',
  `FecExIden` date DEFAULT '1900-01-01' COMMENT 'Fecha de Expedicion de la Identificacion',
  `FecVenIden` date DEFAULT '1900-01-01' COMMENT 'Fecha de vencimiento de la Identificacion',
  `IDClienteSIERRA` char(24) DEFAULT '' COMMENT 'Numero de Cliente SIERRA',
  `PaisNacionalidad` INT(11) NULL DEFAULT '0',
  `IngresosMensuales` DECIMAL(14,2) NULL,
  `TamanioAcreditado` INT(11) NULL,
  `NiveldeRiesgo` CHAR(1) NULL,
  `EmpresaID` int(11) NOT NULL COMMENT 'Campo de auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Campo de auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Campo de auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Campo de auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Campo de auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Campo de auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Campo de auditoria',
  PRIMARY KEY (`NumRegistro`,`FolioCarga`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla almacenar los registros de clientes con base en un folio de carga y un numero de registro. Esto servira para el alta masiva de clientes CRCB'$$