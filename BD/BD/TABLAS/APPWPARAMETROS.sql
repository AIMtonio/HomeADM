-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APPWPARAMETROS
DELIMITER ;
DROP TABLE IF EXISTS `APPWPARAMETROS`;
DELIMITER $$

CREATE TABLE `APPWPARAMETROS` (
  `EmpresaID` int(20) NOT NULL COMMENT 'Almacena el ID de la empresa. Llave primaria',
  `NombreCortoInstit` varchar(100) NOT NULL COMMENT 'Nombre corto de la institucion',
  `TextoCodigoActSMS` varchar(200) NOT NULL COMMENT 'Texto del mensaje SMS de activacion de app wallet',
  `IvaPorPagarSPEI` decimal(16,2) NOT NULL COMMENT 'Iva por pagar por realizar un envio de SPEI',
  `UsuarioEnvioSPEI` varchar(30) NOT NULL COMMENT 'Almacena el usuarioID que es necesario para los envios de SPEI para identificar quien realizo el envio, hace referencia al campo UsuarioID de la tabla de USUARIOS',
  `RutaArchivos` varchar(45) NOT NULL COMMENT 'Ruta de Archivos de la Bancas',
  `AsuntoNotiAltaTar` varchar(200) NOT NULL COMMENT 'Asunto de las notificaciones de nuevo usuario en la app wallet',
  `AsuntNotiCambioTar` varchar(200) NOT NULL COMMENT 'Asunto de las notificaciones de cambios en las opciones de seguridad en la app wallet',
  `AsuntoNotiPagosTar` varchar(200) NOT NULL COMMENT 'Asunto de las notificaciones de Pago en la app wallet',
  `AsuntNotiSesionTar` varchar(200) NOT NULL COMMENT 'Asunto de las notificaciones de inicio de session en la app wallet',
  `AsuntNotiTransfTar` varchar(200) NOT NULL COMMENT 'Asunto de las notificaciones de transferencia en la app wallet',
  `TiempoValidezSMS` varchar(45) NOT NULL COMMENT 'Tiempo que es valido un OTP SMS',
  `RemitenteTar` varchar(45) NOT NULL COMMENT 'Remitente de las notificaciones de app wallet, hace referencia al campo RemitenteID la tabla TARENVIOCORREOPARAM',
  `LonMinCaracPass` int(11) NOT NULL COMMENT 'Almacena la cantidad de caracteres minimos para la contrasenia',
  `URLFreja` varchar(150) NOT NULL COMMENT 'URL para conectar con el servidor de Freja.',
  `TituloTransaccion` varchar(150) NOT NULL COMMENT 'Titulo con el que se inicia la transaccion a traves de la libreria de Freja.',
  `PeriodoValidez` int(11) NOT NULL COMMENT 'Periodo de validez para iniciar la transaccion.',
  `TiempoMaxEspera` int(11) NOT NULL COMMENT 'Tiempo maximo de espera para que la transaccion sea aprobada.',
  `TiempoAprovision` int(11) NOT NULL COMMENT 'Tiempo de espera para completar el aprovisionamiento.',
  `NumIntentos` int(11) NOT NULL COMMENT 'Numero de intentos fallidos antes de bloquear usuario.',
  `TiempoInact` int(11) NOT NULL COMMENT 'Tiempo de inactividad por minutos para hacer logout.',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditora',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditora',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditora',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditora',
  PRIMARY KEY (`EmpresaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Par: Tabla donde se almacenan los datos de los Parametros de las Bancas.'$$