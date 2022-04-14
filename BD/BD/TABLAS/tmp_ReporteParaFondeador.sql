-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- tmp_ReporteParaFondeador
DELIMITER ;
DROP TABLE IF EXISTS `tmp_ReporteParaFondeador`;


  `ClienteSAFI` int(11) NOT NULL COMMENT 'LLave Primaria para Identificar los Clientes\n',
  `TipoPersona` varchar(96) DEFAULT NULL,
  `Titulo` varchar(10) DEFAULT NULL,
  `Nombres` varchar(150) DEFAULT NULL,
  `ApellidoPaterno` varchar(50) DEFAULT NULL COMMENT 'Apellido Paterno del Cliente\n',
  `ApellidoMaterno` varchar(50) DEFAULT NULL COMMENT 'Apellido Materno del Cliente\n',
  `NombreCompleto` varchar(200) DEFAULT NULL COMMENT 'Este campo no se captura, se forma en base a los nombres y apellidos\n',
  `Sexo` varchar(9) CHARACTER SET utf8 DEFAULT NULL,
  `EstadoCivil` varchar(129) DEFAULT NULL,
  `RFC` varchar(13) NOT NULL DEFAULT '',
  `CURP` varchar(18) NOT NULL DEFAULT '',
  `TelefonoCasa` varchar(20) NOT NULL DEFAULT '',
  `TelefonoCelular` varchar(20) NOT NULL DEFAULT '',
  `Correo` varchar(50) NOT NULL DEFAULT '',
  `GradoEscolar` varchar(50) NOT NULL DEFAULT '',
  `TipoIdentificacion` varchar(45) NOT NULL DEFAULT '',
  `NumeroIdentificacion` varchar(30) NOT NULL DEFAULT '',
  `FechaNacimiento` date DEFAULT NULL COMMENT 'Fecha Nacimiento del Cliente o Rep Legal\n',
  `EntidadFederativaNacimiento` varchar(100) DEFAULT NULL COMMENT 'Nombre de la Empresa',
  `OcupacionID` int(5) DEFAULT NULL COMMENT 'Profesión del cliente,Llave Foranea Hacia tabla OCUPACIONES si existe pero no es necesario.\n',
  `DescripcionOcupacion` text COMMENT 'Descripcion de la Ocupacion',
  `LugarTrabajo` varchar(100) DEFAULT NULL COMMENT 'Lugar donde Trabaja\n',
  `AntiguedadEnTrabajo` varchar(21) CHARACTER SET utf8 DEFAULT NULL,
  `PuestoTrabajo` varchar(100) DEFAULT NULL COMMENT 'Puesto en el Trabajo\n',
  `ActividadFR` bigint(20) DEFAULT NULL COMMENT 'Actividad Principal del Cte, segun la ACTIVIDADESFR',
  `ActividadFRDescripcion` varchar(150) DEFAULT NULL COMMENT 'Descripción de la Actividad',
  `ActividadFOMURID` int(11) DEFAULT NULL COMMENT 'Id de la tabla Actividad FOMMUR',
  `ActividadFOMURDescripcion` varchar(200) CHARACTER SET utf8 DEFAULT NULL COMMENT 'Descripcion de la actividad FOMMUR',
  `TipoDireccionOficial` varchar(45) DEFAULT NULL COMMENT 'Descripcion del\nTipo de Indentificacion\n',
  `EstadoDirOficial` varchar(100) DEFAULT NULL COMMENT 'Nombre de la Empresa',
  `MunicipioDirOficial` varchar(150) DEFAULT NULL COMMENT 'Nombre del Municipio',
  `LocalidadDirOficil` varchar(200) DEFAULT NULL COMMENT 'Nombre de la localidad',
  `AsentamientoColoniaDirOficial` varchar(200) DEFAULT NULL,
  `ColoniaDirOficial` varchar(200) DEFAULT NULL,
  `CalleDirOficial` varchar(50) DEFAULT NULL COMMENT 'Nombre de la calle',
  `NumeroInteriorDirOficial` char(10) DEFAULT NULL COMMENT 'Numero interior de la casa o edificio.',
  `NumeroExteriorDirOficial` char(10) DEFAULT NULL COMMENT 'Numero de casa, depto, oficina o negocio',
  `CodigoPostalDirOficial` char(5) DEFAULT NULL COMMENT 'Codigo Postal',
  `DireccionCompletaDirOficial` varchar(500) DEFAULT NULL COMMENT 'Este campo se arma con los campos calle, numero, colonia, y CP.',
  `EstadoDirNegocio` varchar(100) DEFAULT NULL COMMENT 'Nombre de la Empresa',
  `MunicipioDirNegocio` varchar(150) DEFAULT NULL COMMENT 'Nombre del Municipio',
  `LocalidadDirNegocio` varchar(200) DEFAULT NULL COMMENT 'Nombre de la localidad',
  `AsentamientoColoniaDirNegocio` varchar(200) DEFAULT NULL,
  `ColoniaDirNegocio` varchar(200) DEFAULT NULL,
  `CalleDirNegocio` varchar(50) DEFAULT NULL COMMENT 'Nombre de la calle',
  `NumeroInteriorDirNegocio` char(10) DEFAULT NULL COMMENT 'Numero interior de la casa o edificio.',
  `NumeroExteriorDirNegocio` char(10) DEFAULT NULL COMMENT 'Numero de casa, depto, oficina o negocio',
  `CodigoPostalDirNegocio` char(5) DEFAULT NULL COMMENT 'Codigo Postal',
  `DireccionCompletaDirNegocio` varchar(500) DEFAULT NULL COMMENT 'Este campo se arma con los campos calle, numero, colonia, y CP.',
  `NumeroEmpleados` varchar(10) NOT NULL DEFAULT '',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Sucursal donde se dio de alta el credito',
  `NombreSucurs` varchar(50) DEFAULT NULL COMMENT 'Nombre de la Sucursal',
  `NombrePromotor` varchar(100) NOT NULL COMMENT 'Nombre del Promotor',
  `CreditoID` int(11) NOT NULL COMMENT 'ID del Credito',
  `ProductoCreditoID` int(11) DEFAULT NULL COMMENT 'id de producto',
  `NombreProducto` varchar(100) DEFAULT NULL COMMENT 'Descripcion del\nTipo de Producto',
  `DiasAtraso` bigint(11) NOT NULL DEFAULT '0',
  `RangoDeDias` varchar(23) CHARACTER SET utf8 DEFAULT NULL,
  `DestinoCreditoID` int(11) NOT NULL,
  `DestinoCredito` varchar(300) NOT NULL,
  `DestinoFOMURID` varchar(20) DEFAULT NULL,
  `DestinoFOMUR` varchar(200) DEFAULT NULL,
  `DestinoFRID` varchar(20) DEFAULT NULL,
  `DestinoFR` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  `TipoDeCredito` varchar(33) DEFAULT NULL,
  `TasaAnual` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `TasaMensual` decimal(11,2) DEFAULT NULL,
  `FechaDesembolso` date DEFAULT NULL COMMENT 'Fecha de Inicio del Credito',
  `FechaVencimiento` date DEFAULT NULL COMMENT 'Fecha de Vencimiento\n',
  `NumeroCuotas` int(11) DEFAULT NULL COMMENT 'Numero de Amortizaciones o Cuotas (de Capital)\\n',
  `GrupoID` bigint(11) NOT NULL DEFAULT '0',
  `NombreGrupo` varchar(200) DEFAULT NULL,
  `Estatus` varchar(9) CHARACTER SET utf8 DEFAULT NULL,
  `Frecuencia` varchar(12) CHARACTER SET utf8 DEFAULT NULL,
  `ModalidadDePago` varchar(12) CHARACTER SET utf8 DEFAULT NULL,
  `GarantiaExhibida` decimal(13,2) NOT NULL DEFAULT '0.00',
  `GarantiaAdicional` decimal(13,2) NOT NULL DEFAULT '0.00',
  `MontoDesembolsado` decimal(14,2) DEFAULT NULL,
  `SALDO` decimal(39,2) DEFAULT NULL,
  `CapitalExigible` decimal(37,2) DEFAULT NULL,
  `InteresVigente` decimal(36,2) DEFAULT NULL,
  `InteresProvisionado` decimal(36,2) DEFAULT NULL,
  `InteresVencido` decimal(36,2) DEFAULT NULL,
  `InteresOrdinarios` decimal(36,2) DEFAULT NULL,
  `SaldoEnMora` decimal(36,2) DEFAULT NULL,
  `Comisiones` decimal(37,2) DEFAULT NULL,
  `CAPITAL` decimal(39,2) DEFAULT NULL,
  `ColumnasSaldoSAFI` varchar(42) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `SaldoCapVigente` decimal(36,2) DEFAULT NULL,
  `SaldoCapAtrasado` decimal(36,2) DEFAULT NULL,
  `SaldoCapVencido` decimal(36,2) DEFAULT NULL,
  `SaldoCapitalVencidoNoExigible` decimal(36,2) DEFAULT NULL,
  `SaldoInteresAtrasado` decimal(36,2) DEFAULT NULL,
  `SaldoInteresVencido` decimal(36,2) DEFAULT NULL,
  `SaldoInteresDevengado` decimal(36,2) DEFAULT NULL,
  `SaldoInteresDevengadoEnCuentasDeOrden` decimal(36,2) DEFAULT NULL,
  `SaldoMoratorios` decimal(36,2) DEFAULT NULL,
  `SaldoComFaltaPago` decimal(36,2) DEFAULT NULL,
  `SaldoOtrasComisiones` decimal(36,2) DEFAULT NULL,
  `Ingresos` decimal(9,2) NOT NULL DEFAULT '0.00',
  `Egresos` decimal(9,2) NOT NULL DEFAULT '0.00'
) ENGINE=MyISAM DEFAULT CHARSET=latin1$$