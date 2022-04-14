-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORACLIENTES
DELIMITER ;
DROP TABLE IF EXISTS `BITACORACLIENTES`;DELIMITER $$

CREATE TABLE `BITACORACLIENTES` (
  `ClienteID` int(11) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `SucursalOrigen` int(5) DEFAULT NULL,
  `TipoPersona` char(1) DEFAULT NULL,
  `Titulo` varchar(10) DEFAULT NULL,
  `PrimerNombre` varchar(50) DEFAULT NULL,
  `SegundoNombre` varchar(50) DEFAULT NULL,
  `TercerNombre` varchar(50) DEFAULT NULL,
  `ApellidoPaterno` varchar(50) DEFAULT NULL,
  `ApellidoMaterno` varchar(50) DEFAULT NULL,
  `FechaNacimiento` date DEFAULT NULL,
  `CURP` char(17) DEFAULT NULL,
  `Nacion` char(1) DEFAULT NULL,
  `PaisResidencia` int(5) DEFAULT NULL,
  `GrupoEmpresarial` int(11) DEFAULT NULL,
  `RazonSocial` varchar(150) DEFAULT NULL,
  `TipoSociedadID` int(11) DEFAULT NULL,
  `Fax` varchar(20) DEFAULT NULL,
  `Correo` varchar(50) DEFAULT NULL,
  `RFC` char(13) DEFAULT NULL,
  `RFCpm` char(13) DEFAULT NULL,
  `SectorGeneral` int(3) DEFAULT NULL,
  `ActividadBancoMX` varchar(15) DEFAULT NULL,
  `ActividadINEGI` int(11) DEFAULT NULL,
  `SectorEconomico` int(11) DEFAULT NULL,
  `Sexo` char(1) DEFAULT NULL,
  `EstadoCivil` char(2) DEFAULT NULL,
  `LugarNacimiento` varchar(100) DEFAULT NULL,
  `EstadoID` int(11) DEFAULT NULL,
  `OcupacionID` int(5) DEFAULT NULL,
  `LugardeTrabajo` varchar(100) DEFAULT NULL,
  `Puesto` varchar(100) DEFAULT NULL,
  `TelTrabajo` varchar(20) DEFAULT NULL,
  `AntiguedadTra` decimal(12,2) DEFAULT NULL,
  `TelefonoCelular` varchar(20) DEFAULT NULL,
  `Telefono` varchar(20) DEFAULT NULL,
  `Clasificacion` char(1) DEFAULT NULL,
  `MotivoApertura` char(1) DEFAULT NULL,
  `PagaISR` char(1) DEFAULT NULL,
  `PagaIVA` char(1) DEFAULT NULL,
  `PagaIDE` char(1) DEFAULT NULL,
  `NivelRiesgo` char(1) DEFAULT NULL,
  `PromotorInicial` int(6) DEFAULT NULL,
  `PromotorActual` int(6) DEFAULT NULL,
  `FechaAlta` date DEFAULT NULL,
  `Estatus` char(1) DEFAULT NULL,
  `NombreCompleto` varchar(100) DEFAULT NULL,
  `NombreConyuge` varchar(150) DEFAULT NULL,
  `RFC_Conyuge` varchar(13) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  `NombreSP` varchar(45) DEFAULT NULL,
  `NumError` int(3) DEFAULT NULL,
  `MensajeError` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$