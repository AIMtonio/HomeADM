-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPPLDCNBVOPINU
DELIMITER ;
DROP TABLE IF EXISTS `TMPPLDCNBVOPINU`;DELIMITER $$

CREATE TABLE `TMPPLDCNBVOPINU` (
  `TipoReporte` int(11) NOT NULL COMMENT 'Tipo de Reporte ',
  `PeriodoReporte` char(10) NOT NULL COMMENT 'Periodo el cual cubre el Reporte\n',
  `Folio` int(11) NOT NULL COMMENT 'Folio o Consecutivo de Registros de Reporte',
  `ClaveOrgSupervisor` char(6) DEFAULT NULL COMMENT 'Clave del Organo Supervisor\n',
  `ClaveEntCasFim` char(6) DEFAULT NULL COMMENT 'Clave del Sujeto Obligado\n',
  `LocalidadSuc` varchar(10) DEFAULT NULL COMMENT 'Localidad de la Sucursal donde se llevo a cabo la operacion\n',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Sucursal Donde se llevo a cabo la Operacion\n',
  `TipoOperacionID` varchar(3) DEFAULT NULL COMMENT 'Tipo de Operacion\n',
  `InstrumentMonID` varchar(3) DEFAULT NULL COMMENT 'Clave del Instrumento Monetario\n',
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `Monto` double DEFAULT NULL COMMENT 'Monto Total de la Operacion\n',
  `ClaveMoneda` varchar(3) DEFAULT NULL COMMENT 'Clave o identificador de la moneda\n',
  `FechaOpe` varchar(8) DEFAULT NULL COMMENT 'Fecha de la Operacion\n',
  `FechaDeteccion` varchar(8) DEFAULT NULL COMMENT 'Fecha de Deteccion de la operacion\n',
  `Nacionalidad` char(1) DEFAULT NULL COMMENT 'Nacionalidad del sujeto\n',
  `TipoPersona` char(1) DEFAULT NULL COMMENT 'Tipo de Persona sujeto\n',
  `RazonSocial` varchar(60) DEFAULT NULL COMMENT 'Razon Social\n',
  `Nombre` varchar(60) DEFAULT NULL COMMENT 'Nombre del Sujeto Implicado\n',
  `ApellidoPat` varchar(60) DEFAULT NULL COMMENT 'Apellido Paterno del Sujeto involucrado\n',
  `ApellidoMat` varchar(60) DEFAULT NULL COMMENT 'Apellido Materno del Sujeto Involucrado\n',
  `RFC` varchar(13) DEFAULT NULL COMMENT 'RFC del Sujeto involucrado\n',
  `CURP` varchar(18) DEFAULT NULL COMMENT 'CURP del sujeto involucrado\n',
  `FechaNac` varchar(8) DEFAULT NULL COMMENT 'Fecha de Nacimiento del Sujeto Involucrado\n',
  `Domicilio` varchar(100) DEFAULT NULL COMMENT 'Domicilio del Sujeto Involucrado\n',
  `Colonia` varchar(45) DEFAULT NULL COMMENT 'Colonia del Sujeto Involucrado\n',
  `Localidad` varchar(10) DEFAULT NULL COMMENT 'Localidad del sujeto involucrado\n',
  `Telefono` varchar(40) DEFAULT NULL COMMENT 'Telefono del Sujeto involucrado\n',
  `ActEconomica` varchar(7) DEFAULT NULL COMMENT 'Actividad Economica del sujeto involucrado\n',
  `NomApoderado` varchar(60) DEFAULT NULL COMMENT 'Nombre del Apoderado\n',
  `ApPatApoderado` varchar(60) DEFAULT NULL COMMENT 'Apellido Paterno del Apoderado',
  `ApMatApoderado` varchar(60) DEFAULT NULL COMMENT 'Apellido Materno del Apoderado\n',
  `RFCApoderado` varchar(13) DEFAULT NULL COMMENT 'RFC del Apoderado\n',
  `CURPApoderado` varchar(18) DEFAULT NULL COMMENT 'Curp del apoderado\n',
  `CtaRelacionadoID` varchar(2) DEFAULT NULL COMMENT 'Id o Identificador de la cuenta de personas relacionadas\n',
  `CuenAhoRelacionado` varchar(16) DEFAULT NULL COMMENT 'Cuenta de Ahorro de la Persona Relacionada\n',
  `ClaveSujeto` varchar(6) DEFAULT NULL COMMENT 'Clave del Sujeto Titular\n\n',
  `NomTitular` varchar(60) DEFAULT NULL COMMENT 'nombre del Titular\n',
  `ApPatTitular` varchar(60) DEFAULT NULL COMMENT 'Apellido Paterno del Titular\n',
  `ApMatTitular` varchar(60) DEFAULT NULL COMMENT 'Apellido Materno del titular\n',
  `DesOperacion` varchar(300) DEFAULT NULL COMMENT 'Descripcion de la Operacion\n',
  `Razones` varchar(300) DEFAULT NULL COMMENT 'Razones de la Operacion',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoReporte`,`PeriodoReporte`,`Folio`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tlaba para Reportar Operaciones PLD ante la CNBV'$$