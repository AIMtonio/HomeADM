-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAPARAMS
DELIMITER ;
DROP TABLE IF EXISTS `EDOCTAPARAMS`;
DELIMITER $$


CREATE TABLE `EDOCTAPARAMS` (
  `MontoMin` decimal(16,2) NOT NULL,
  `RutaExpPDF` varchar(250) NOT NULL COMMENT 'Ruta para la ubicacion de donde se guardara los archivos PDF, a su vez tambien para los archivos sh.',
  `RutaReporte` varchar(250) NOT NULL,
  `MesProceso` int(11) NOT NULL,
  `InstitucionID` int(11) NOT NULL,
  `CiudadUEAUID` int(11) DEFAULT NULL,
  `CiudadUEAU` varchar(45) NOT NULL,
  `TelefonoUEAU` varchar(45) NOT NULL,
  `OtrasCiuUEAU` varchar(45) NOT NULL,
  `HorarioUEAU` varchar(45) NOT NULL,
  `DireccionUEAU` varchar(250) NOT NULL,
  `CorreoUEAU` varchar(45) NOT NULL,
  `RutaCBB` varchar(60) DEFAULT NULL,
  `RutaCFDI` varchar(60) DEFAULT NULL,
  `RutaLogo` varchar(90) DEFAULT NULL,
  `TipoCuentaID` varchar(45) DEFAULT NULL COMMENT 'Tipos de cuenta',
  `ExtTelefonoPart` varchar(6) DEFAULT NULL COMMENT 'Contiene el número de extensión de teléfono particular',
  `ExtTelefono` varchar(6) DEFAULT NULL COMMENT 'Contiene el número de extensión de teléfono de otra ciudad',
  `EnvioAutomatico` char(1) NOT NULL,
  `CorreoRemitente` varchar(50) NOT NULL,
  `ServidorSMTP` varchar(50) NOT NULL,
  `PuertoSMTP` int(11) NOT NULL,
  `UsuarioRemitente` varchar(50) NOT NULL,
  `ContraseniaRemitente` varchar(50) NOT NULL,
  `Asunto` varchar(100) NOT NULL,
  `CuerpoTexto` text NOT NULL,
  `RequiereAut` char(1) NOT NULL,
  `TipoAut` varchar(10) NOT NULL,
  `TokenSW` text NOT NULL COMMENT 'token para la autenticacion con los servicios de smarterweb',
  `URLWSSmarterWeb` varchar(100) NOT NULL COMMENT 'ruta de servicios de smarterweb',
  `RutaSupTasaLogo` varchar(50) NOT NULL COMMENT 'ruta del logotipo de super tasa',
  `RutaPDI` VARCHAR(100) NOT NULL COMMENT 'Ruta del aplicativo Data-Integration necesario para el proceso de EdoCta.',
  `PrefijoEmpresa` VARCHAR(100) NOT NULL COMMENT 'Valor de Prefijo de la empresa llamado Desplegado de la tabla compania en la BD principal.',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`MesProceso`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Parametros para Estados de Cuenta'$$