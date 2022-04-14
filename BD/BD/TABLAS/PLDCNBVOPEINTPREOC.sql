
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDCNBVOPEINTPREOC
DELIMITER ;
DROP TABLE IF EXISTS `PLDCNBVOPEINTPREOC`;

DELIMITER $$
CREATE TABLE `PLDCNBVOPEINTPREOC` (
  `RegistroID` bigint(20) UNSIGNED AUTO_INCREMENT COMMENT 'Llave primaria de reporte.',
  `TipoReporte` int(11) NOT NULL COMMENT 'Tipo de Reporte. ',
  `PeriodoReporte` char(10) NOT NULL COMMENT 'Periodo el cual cubre el Reporte.',
  `Folio` int(11) NOT NULL COMMENT 'Folio o Consecutivo de Registros de Reporte.',
  `ClaveOrgSupervisor` char(6) DEFAULT NULL COMMENT 'Clave del Organo Supervisor.',
  `ClaveEntCasFim` char(6) DEFAULT NULL COMMENT 'Clave del Sujeto Obligado.',
  `LocalidadSuc` varchar(10) DEFAULT NULL COMMENT 'Localidad de la Sucursal donde se llevo a cabo la operacion.',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Sucursal Donde se llevo a cabo la Operacion.',
  `TipoOperacionID` varchar(3) DEFAULT NULL COMMENT 'Tipo de Operacion.',
  `InstrumentMonID` varchar(3) DEFAULT NULL COMMENT 'Clave del Instrumento Monetario.',
  `CuentaAhoID` bigint(12) DEFAULT NULL COMMENT 'Número de cuenta de ahorro.',
  `Monto` decimal(12,2) DEFAULT NULL COMMENT 'Monto Total de la Operacion.',
  `ClaveMoneda` varchar(3) DEFAULT NULL COMMENT 'Clave o identificador de la moneda.',
  `FechaOpe` varchar(8) DEFAULT NULL COMMENT 'Fecha de la Operacion.',
  `FechaDeteccion` varchar(8) DEFAULT NULL COMMENT 'Fecha de Deteccion de la operacion.',
  `Nacionalidad` char(1) DEFAULT NULL COMMENT 'Nacionalidad del sujeto.',
  `TipoPersona` char(1) DEFAULT NULL COMMENT 'Tipo de Persona sujeto.',
  `RazonSocial` varchar(60) DEFAULT NULL COMMENT 'Razon Social.',
  `Nombre` varchar(60) DEFAULT NULL COMMENT 'Nombre del Sujeto Implicado.',
  `ApellidoPat` varchar(60) DEFAULT NULL COMMENT 'Apellido Paterno del Sujeto involucrado.',
  `ApellidoMat` varchar(60) DEFAULT NULL COMMENT 'Apellido Materno del Sujeto Involucrado.',
  `RFC` varchar(13) DEFAULT NULL COMMENT 'RFC del Sujeto involucrado.',
  `CURP` varchar(18) DEFAULT NULL COMMENT 'CURP del sujeto involucrado.',
  `FechaNac` varchar(8) DEFAULT NULL COMMENT 'Fecha de Nacimiento del Sujeto Involucrado.',
  `Domicilio` varchar(100) DEFAULT NULL COMMENT 'Domicilio del Sujeto Involucrado.',
  `Colonia` varchar(200) DEFAULT NULL COMMENT 'Colonia del Sujeto Involucrado.',
  `Localidad` varchar(10) DEFAULT NULL COMMENT 'Localidad del sujeto involucrado.',
  `Telefono` varchar(40) DEFAULT NULL COMMENT 'Telefono del Sujeto involucrado.',
  `ActEconomica` varchar(15) DEFAULT NULL COMMENT 'Actividad Economica del sujeto involucrado.',
  `NomApoderado` varchar(60) DEFAULT NULL COMMENT 'Nombre del Apoderado.',
  `ApPatApoderado` varchar(60) DEFAULT NULL COMMENT 'Apellido Paterno del Apoderado.',
  `ApMatApoderado` varchar(60) DEFAULT NULL COMMENT 'Apellido Materno del Apoderado.',
  `RFCApoderado` varchar(13) DEFAULT NULL COMMENT 'RFC del Apoderado.',
  `CURPApoderado` varchar(18) DEFAULT NULL COMMENT 'Curp del apoderado.',
  `CtaRelacionadoID` varchar(2) DEFAULT NULL COMMENT 'Id o Identificador de la cuenta de personas relacionadas.',
  `CuenAhoRelacionado` varchar(16) DEFAULT NULL COMMENT 'Cuenta de Ahorro de la Persona Relacionada.',
  `ClaveSujeto` varchar(6) DEFAULT NULL COMMENT 'Clave del Sujeto Titular.',
  `NomTitular` varchar(60) DEFAULT NULL COMMENT 'nombre del Titular.',
  `ApPatTitular` varchar(60) DEFAULT NULL COMMENT 'Apellido Paterno del Titular.',
  `ApMatTitular` varchar(60) DEFAULT NULL COMMENT 'Apellido Materno del titular.',
  `DesOperacion` varchar(300) DEFAULT NULL COMMENT 'Descripcion de la Operacion.',
  `Razones` varchar(300) DEFAULT NULL COMMENT 'Razones de la Operacion.',
  `Fecha` date NOT NULL COMMENT 'Fecha de registro de la operación (captura).',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria.',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria.',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria.',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria.',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria.',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria.',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria.',
  PRIMARY KEY (`RegistroID`),
  KEY `IDX_PLDCNBVOPEINTPREOC_001` (`Fecha`),
  KEY `IDX_PLDCNBVOPEINTPREOC_002` (`NumTransaccion`),
  KEY `IDX_PLDCNBVOPEINTPREOC_003` (`TipoReporte`,`PeriodoReporte`,`Folio`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Reporte de Operaciones PLD ante la CNBV para Operaciones Internas Preocupantes.'$$

