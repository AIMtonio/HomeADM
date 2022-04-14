-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OBLIGADOSSOLIDARIOS
DELIMITER ;
DROP TABLE IF EXISTS `OBLIGADOSSOLIDARIOS`;
DELIMITER $$

CREATE TABLE `OBLIGADOSSOLIDARIOS` (
  `OblSolidID` int(11) NOT NULL COMMENT 'Identificador de obligados solidarios',
  `TipoPersona` char(1) NOT NULL COMMENT 'Tipo de persona ',
  `RazonSocial` varchar(50) NOT NULL COMMENT 'Razon social ',
  `PrimerNombre` varchar(50) NOT NULL COMMENT 'Primer nombre ',
  `SegundoNombre` varchar(50) NOT NULL COMMENT 'Segundo nombre ',
  `TercerNombre` varchar(50) NOT NULL COMMENT 'Tercer nombre ',
  `ApellidoPaterno` varchar(50) NOT NULL COMMENT 'Apellido paterno',
  `ApellidoMaterno` varchar(50) NOT NULL COMMENT 'Apellido materno ',
  `FechaNac` date NOT NULL COMMENT 'Fecha de nacimiento',
  `RFC` char(13) NOT NULL COMMENT 'RFC ',
  `RFCpm` varchar(12) NOT NULL COMMENT 'RFC de la Persona Moral',
  `Telefono` char(13) NOT NULL COMMENT 'Telefono ',
  `TelefonoCel` varchar(13) NOT NULL COMMENT 'Telefono celular ',
  `NombreCompleto` varchar(200) NOT NULL COMMENT 'nombre completo ',
  `Calle` varchar(50) NOT NULL COMMENT 'calle ',
  `NumExterior` char(10) NOT NULL COMMENT 'Numero exterior de la casa ',
  `NumInterior` char(10) NOT NULL COMMENT 'Numero interior de la casa',
  `Manzana` varchar(20) NOT NULL COMMENT 'Manzana del domicilio ',
  `Lote` varchar(20) NOT NULL COMMENT 'Lote del domicilio ',
  `Colonia` varchar(200) NOT NULL COMMENT 'Colonia ',
  `MunicipioID` int(11) NOT NULL COMMENT 'Identificador de municipio ',
  `EstadoID` int(11) NOT NULL COMMENT 'Identificador del estado ',
  `CP` varchar(5) NOT NULL COMMENT 'Codigo Postal',
  `Latitud` varchar(45) NOT NULL COMMENT 'Latitud de ubicacion',
  `Longitud` varchar(45) NOT NULL COMMENT 'Longitud de ubicacion ',
  `LocalidadID` int(11) NOT NULL COMMENT 'Identificador de localidad ',
  `ColoniaID` int(11) NOT NULL COMMENT 'Identificador de la colonia ',
  `Sexo` char(1) NOT NULL COMMENT 'Sexo ',
  `EstadoCivil` char(2) NOT NULL COMMENT 'Estado civil ',
  `DireccionCompleta` varchar(500) NOT NULL COMMENT 'Direccion completa ',
  `ExtTelefonoPart` varchar(6) NOT NULL COMMENT 'Contiene el número de extesión de teléfono',
  `Nacion` char(1) NOT NULL COMMENT 'Nacionalidad ',
  `LugarNacimiento` int(11) NOT NULL COMMENT 'Lugar de nacimiento',
  `OcupacionID` int(11) NOT NULL COMMENT 'Identificador de la ocupacion ',
  `Puesto` varchar(100) NOT NULL COMMENT 'Puesto',
  `DomicilioTrabajo` varchar(500) NOT NULL COMMENT 'Domicilio del trabajo',
  `TelefonoTrabajo` varchar(13) NOT NULL COMMENT 'Telefono del trabajo',
  `ExtTelTrabajo` varchar(4) NOT NULL COMMENT 'Telefono externo del trabajo',
  `SoloNombres` varchar(500) DEFAULT '' COMMENT 'Primer Nombre, Segundo Nombre y Tercer Nombre.',
  `SoloApellidos` varchar(500) DEFAULT '' COMMENT 'Apellido Paterno y Apellido Materno.',
  `RazonSocialPLD` varchar(200) DEFAULT '' COMMENT 'Razón Social limpio de caracteres especiales.',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` date NOT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`OblSolidID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para los obligados solidarios.'$$