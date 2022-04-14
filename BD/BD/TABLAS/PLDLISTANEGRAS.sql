-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDLISTANEGRAS
DELIMITER ;
DROP TABLE IF EXISTS `PLDLISTANEGRAS`;
DELIMITER $$

CREATE TABLE `PLDLISTANEGRAS` (
  `ListaNegraID` bigint(12) NOT NULL COMMENT 'Id Tabla PLDListaNegras',
  `IDQEQ` varchar(20) DEFAULT '' COMMENT 'ID del catalogo de Quien es Quien',
  `PrimerNombre` varchar(100) DEFAULT NULL COMMENT 'Primer Nombre',
  `SegundoNombre` varchar(100) DEFAULT NULL COMMENT 'Segundo Nombre',
  `TercerNombre` varchar(100) DEFAULT NULL COMMENT 'Tercer Nombre',
  `ApellidoPaterno` varchar(100) DEFAULT NULL COMMENT 'Apellido Paterno',
  `ApellidoMaterno` varchar(100) DEFAULT NULL COMMENT 'Apellido Materno',
  `RFC` char(15) DEFAULT NULL COMMENT 'RFC de la Persona Involucrada',
  `FechaNacimiento` varchar(10) DEFAULT NULL COMMENT 'Fecha de Nacimiento\nLa fecha puede presentarse en formato AAAA-MM-DD, AAAAMMDD, ____MMDD, AAAA____.',
  `NombresConocidos` varchar(500) DEFAULT NULL COMMENT 'Alias del cliente',
  `CURP` char(18) DEFAULT '' COMMENT 'Clave CURP',
  `PaisID` int(11) DEFAULT NULL,
  `EstadoID` int(11) DEFAULT NULL,
  `EstatusQeQ` varchar(50) DEFAULT '' COMMENT 'Estatus del catalogo de Quien es Quien',
  `SexoQeQ` char(1) DEFAULT '' COMMENT 'Genero del catalogo de Quien es Quien\nF.- Femenino\nM.- Masculino',
  `NombreCompleto` varchar(300) DEFAULT NULL COMMENT 'Nombre completo de la persona',
  `TipoLista` varchar(45) DEFAULT NULL COMMENT 'Tipo de lista, este viene del catalogo que se sube',
  `FechaAlta` date DEFAULT NULL COMMENT 'Fecha de Alta no puede cambiar ',
  `FechaReactivacion` date DEFAULT NULL COMMENT 'Fecha de Reactivación (Se debe actualizar siempre que se reactive a la persona).',
  `FechaInactivacion` date DEFAULT NULL COMMENT 'Fecha de Inactivación (Se debe actualizar siempre que se inactive a la persona)',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus A: Activo I:Inactivo',
  `SoloNombres` varchar(500) DEFAULT NULL COMMENT 'Primer Nombre, Segundo Nombre y Tercer Nombre',
  `SoloApellidos` varchar(500) DEFAULT NULL COMMENT 'Apellido Paterno y Apellido Materno',
  `NumeroOficio` varchar(50) DEFAULT '0' COMMENT 'Numero de Oficio. Este campo no es obligatorio y por default es 0.',
  `TipoPersona` char(1) DEFAULT NULL COMMENT 'Tipo de Persona\nF.- Fisica\nM.- Moral',
  `RazonSocial` varchar(150) DEFAULT NULL COMMENT 'Nombre de la persona moral.',
  `RFCm` varchar(15) DEFAULT NULL COMMENT 'RFC de la persona Moral.',
  `RazonSocialPLD` varchar(150) DEFAULT '' COMMENT 'Nombre de la persona moral limpio de caracteres especiales\nusado para la detección de personas morales.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`ListaNegraID`),
  KEY `PLDLISTANEGRAS_IDX_1` (`SoloNombres`,`SoloApellidos`,`RFC`,`FechaNacimiento`,`PaisID`,`EstadoID`,`TipoPersona`,`Estatus`),
  KEY `PLDLISTANEGRAS_IDX_2` (`SoloApellidos`,`RFC`,`FechaNacimiento`,`PaisID`,`EstadoID`,`TipoPersona`,`Estatus`),
  KEY `PLDLISTANEGRAS_IDX_3` (`SoloNombres`,`RFC`,`FechaNacimiento`,`PaisID`,`EstadoID`,`TipoPersona`,`Estatus`),
  KEY `PLDLISTANEGRAS_IDX_4` (`RazonSocialPLD`,`TipoPersona`,`Estatus`),
  KEY `PLDLISTANEGRAS_IDX_5` (`RFCm`,`TipoPersona`,`Estatus`),
  KEY `PLDLISTANEGRAS_IDX_6` (`ProgramaID`,`TipoLista`),
  KEY `PLDLISTANEGRAS_IDX_7` (`TipoPersona`,`Estatus`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para Listas Negras. Puede contener registros de Quien es Quien.'$$