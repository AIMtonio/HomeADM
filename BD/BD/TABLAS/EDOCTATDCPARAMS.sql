-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTATDCPARAMS
DELIMITER ;
DROP TABLE IF EXISTS `EDOCTATDCPARAMS`;
DELIMITER $$

CREATE TABLE `EDOCTATDCPARAMS` (
  `MontoMIn` DECIMAL(16,2) NOT NULL COMMENT 'Monto minimo',
  `RutaExpPDF` VARCHAR(250) NOT NULL COMMENT 'Ruta de exportacion del PDF',
  `RutaReporte` VARCHAR(250) NOT NULL COMMENT 'Ruta del reporte',
  `MesProceso` INT(11) NOT NULL COMMENT 'Mes de proceso',
  `InstitucionID` INT(11) NOT NULL COMMENT 'Identificador de la institucion',
  `CiudadUEAUID` INT(11) DEFAULT NULL COMMENT 'Identificador de la ciudad',
  `CiudadUEAU` VARCHAR(45) NOT NULL COMMENT 'Nombre de la ciudad',
  `TelefonoUEAU` VARCHAR(45) NOT NULL COMMENT 'Numero de telefono',
  `OtrasCiuUEAU` VARCHAR(45) NOT NULL COMMENT 'Numero de OtrasCiuUEAU',
  `HorarioUEAU` VARCHAR(45) NOT NULL COMMENT 'Descripcion de horario',
  `DireccionUEAU` VARCHAR(250) NOT NULL COMMENT 'Direccion de UEAU',
  `CorreoUEAU` VARCHAR(45) NOT NULL COMMENT 'Correo electronico UEAU',
  `RutaCBB` VARCHAR(60) DEFAULT NULL COMMENT 'Ruta del CCB',
  `RutaCFDI` VARCHAR(60) DEFAULT NULL COMMENT 'Ruta del CFDI',
  `RutaLogo` VARCHAR(90) DEFAULT NULL COMMENT 'Ruta del logotipo',
  `TipoCuentaID` VARCHAR(45) DEFAULT NULL COMMENT 'Identificador del tipo de cuenta',
  `ExtTelefonoPart` VARCHAR(6) DEFAULT NULL COMMENT 'Extencion de el telefono',
  `ExtTelefono` VARCHAR(6) DEFAULT NULL COMMENT 'Extencion telefonica',
  `EnvioAutomatico` CHAR(1) NOT NULL COMMENT 'Envio automatico que recibe un parametro S o N',
  `CorreoRemitente` VARCHAR(50) NOT NULL COMMENT 'Direccion de correo electronico del remitente',
  `ServidorSMTP` VARCHAR(50) NOT NULL COMMENT 'Direccion del servidor SMTP',
  `PuertoSMTP` INT(11) NOT NULL COMMENT 'Numero del puerto SMTP',
  `UsuarioRemitente` VARCHAR(50) NOT NULL COMMENT 'Usuario del remitente',
  `ContraseniaRemitente` VARCHAR(50) NOT NULL COMMENT 'Contraseña del remitente',
  `Asunto` VARCHAR(100) NOT NULL COMMENT 'Asunto',
  `CuerpoTexto` TEXT NOT NULL COMMENT 'Cuerpo del texto',
  `RequiereAut` CHAR(1) NOT NULL COMMENT 'RequiereAut qeu recibe un parametro S o N',
  `TipoAut` VARCHAR(10) NOT NULL COMMENT 'TipoAut',
  `EmpresaID` INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` DATETIME DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` VARCHAR(15) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` VARCHAR(50) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` BIGINT(20) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`MesProceso`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para almacenar los datos de EDOCTATDCPARAMS'$$
