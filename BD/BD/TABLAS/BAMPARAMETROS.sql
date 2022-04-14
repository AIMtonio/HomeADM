-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BAMPARAMETROS
DELIMITER ;
DROP TABLE IF EXISTS `BAMPARAMETROS`;DELIMITER $$

CREATE TABLE `BAMPARAMETROS` (
  `EmpresaID` int(20) NOT NULL COMMENT 'Empresa default',
  `MensajeCodigoActSMS` varchar(200) DEFAULT NULL COMMENT 'Texto de mensaje SMS de activacion',
  `PasswordCorreoBancaMovil` varchar(45) DEFAULT NULL COMMENT 'Pass del  Correo para Notificaciones BMovil',
  `PuertoCorreoBancaMovil` varchar(45) DEFAULT NULL COMMENT 'Puerto de Correo para Notificaciones BMovil',
  `RutaArchivos` varchar(45) DEFAULT NULL COMMENT 'Ruta de Archivos de la Banca Movil',
  `RutaCorreosBancaMovil` varchar(45) DEFAULT NULL COMMENT 'KTR para envio de correo de la Banca Movil',
  `ServidorCorreoBancaMovil` varchar(45) DEFAULT NULL COMMENT 'Servidor de Correo para Notificaciones BMovil',
  `SubjectAltaBancaMovil` varchar(200) DEFAULT NULL COMMENT 'Notificacion de Alta al Servicio de Bmovil',
  `SubjectCambiosBancaMovil` varchar(200) DEFAULT NULL COMMENT 'Notificacion de Cambios en las Opciones de seguridad de la Banca Movil',
  `SubjectPagosBancaMovil` varchar(200) DEFAULT NULL COMMENT 'Comprobante de Pago en la  BMovil',
  `SubjectSessionBancaMovil` varchar(200) DEFAULT NULL COMMENT 'Asunto para el Inicio de Session en la BMovil',
  `SubjectTransferBancaMovil` varchar(200) DEFAULT NULL COMMENT 'Comprobante Transferencia en la  BMovil',
  `TiempoValidezSMS` varchar(45) DEFAULT NULL COMMENT 'Tiempo que es valido un OTP SMS',
  `UsuarioCorreoBancaMovil` varchar(45) DEFAULT NULL COMMENT 'Usuario o Remitente Notificacion Bmovil',
  `RemitenteCorreo` varchar(45) DEFAULT NULL,
  `TipoPagoCapital` varchar(45) DEFAULT NULL,
  `PermiteGrupal` char(1) DEFAULT NULL,
  `NombreInstitucion` varchar(20) DEFAULT NULL COMMENT ' Nombre de la Institucion que se mostrara en la Banca Movil\n',
  PRIMARY KEY (`EmpresaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla donde se almacenan los datos de los Parametros de la Banca Movil.'$$