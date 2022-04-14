-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSSPEI
DELIMITER ;
DROP TABLE IF EXISTS `PARAMETROSSPEI`;
DELIMITER $$


CREATE TABLE `PARAMETROSSPEI` (
  `EmpresaID` int(11) NOT NULL COMMENT 'Numero o ID de la Empresa',
  `FolioEnvio` bigint(20) NOT NULL COMMENT 'Numero de folio de envio',
  `Clabe` varchar(18) NOT NULL COMMENT 'Numero de CLABE',
  `CtaSpei` varchar(20) NOT NULL COMMENT 'Numero de cuenta spei',
  `ParticipanteSpei` int(5) NOT NULL COMMENT 'Codigo de participacion en SPEI',
  `HorarioInicio` time NOT NULL COMMENT 'Horario de inicio de operacion SPEI',
  `HorarioFin` time NOT NULL COMMENT 'Horario de fin de operacion SPEI',
  `HorarioFinVen` time NOT NULL COMMENT 'Horario de fin para recepcion de ordenes con fecha del dia actual',
  `FechaApertura` datetime NOT NULL COMMENT 'Fecha apertura',
  `EstatusApertura` char(1) NOT NULL COMMENT 'Estatus de apertura',
  `ParticipaPagoMovil` char(1) NOT NULL COMMENT 'S)Si, N)No \nSi la institucion participa en la recepcion y envio de pagos por \nmedio de Dispositivos moviles, por lo cual su operacion de recepcion \nlas 24hrs ',
  `FrecuenciaEnvio` time NOT NULL COMMENT 'Frecuencia de envio automatica',
  `Topologia` char(1) NOT NULL COMMENT 'T) Topologia T, V) Topologia V',
  `Prioridad` int(1) NOT NULL COMMENT 'Prioridad',
  `MonMaxSpeiBcaMovil` decimal(18,2) DEFAULT NULL COMMENT 'Monto maximo permito de SPEI por Banca Movil',
  `MonMaxSpeiVen` decimal(18,2) NOT NULL COMMENT 'Monto maximo permito de SPEI en Ventanilla',
  `MonReqAutTeso` decimal(18,2) NOT NULL COMMENT 'Monto apartir del cual se requiere autorizacion de tesoreria',
  `SpeiVenAutTes` char(1) NOT NULL COMMENT 'Tesorería autorizaría el envio del SPEI \nS = Si Autoriza Tesoreria y el Spei se enviara como Pendiente de Autorizar <verificado>false</verificado>\nN = No Autoriza Tesoreria y el Spei se Registra como Autorizado  por Tesoreria <verificado>true</verificado>\nEL Spei quedara Enviado y no se Procesara por Spei hasta que se autorice.',
  `UltActCat` date NOT NULL COMMENT 'Bandera de última actualización de cátalogos SPEI.',
  `BloqueoRecepcion` char(1) DEFAULT NULL COMMENT 'Bloquea recepcion de SPEI , S-Si, N-No siempre y cuando un SPEI sea para una cuenta de ahorro',
  `MontoMinimoBloq` decimal(16,2) DEFAULT NULL COMMENT 'Monto minimo de Bloqueo por Recepcion de SPEI',
  `CtaContableTesoreria` char(25) DEFAULT NULL COMMENT 'Cuenta Contable para polizas de recepcion de SPEI',
  `KeyPassword` varchar(250) DEFAULT NULL,
  `SaldoMinimoCuentaSTP` DECIMAL(19,2) NOT NULL COMMENT 'Saldo minimo que deberá de tener la cuenta de STP del SAFI',
  `RutaKeystoreStp` VARCHAR(200) NOT NULL COMMENT 'Ruta local del archivo .jks',
  `AliasCertificadoStp` VARCHAR(50) NOT NULL COMMENT 'Nombre del Alias del Certificado almacenado en el archivo .jks',
  `PasswordKeystoreStp` VARCHAR(250) NOT NULL COMMENT 'Contraseña del archivo .jks',
  `EmpresaSTP` VARCHAR(15) NOT NULL COMMENT 'Nombre de la empresa que envia las operaciones y que esta configurada en STP',
  `TipoOperacion` CHAR(1) NOT NULL COMMENT 'Indica el tipo de Salida de la Transferencia. \nS = STP \nB = Banxico',
  `IntentosMaxEnvio` INT(11) NOT NULL COMMENT 'Intentos máximos para realizar el envio de la orden de pago a STP',
  `NotificacionesCorreo` CHAR(1) NOT NULL COMMENT 'Indica si se notificara por correo',
  `CorreoNotificacion` VARCHAR(500) NOT NULL COMMENT 'Indica el remitente en caso de generar un error',
  `RemitenteID` INT(11) NOT NULL COMMENT 'Remitentes de correo referente a la tabla TARENVIOCORREOPARAM',
  `URLWS` VARCHAR(200) NOT NULL COMMENT 'URL de WS DE STP',
  `UsuarioContraseniaWS` VARCHAR(500) NOT NULL COMMENT 'Usuario y Contraseña de WS DE STP',
  `Habilitado` CHAR(1) NOT NULL COMMENT 'Indica si el SPEI esta habilitado. S =  Si, N = No',
  `MonReqAutDesem` DECIMAL(16,2) NOT NULL COMMENT 'Monto a partir del cual un desembolso por SPEI requerira autorizacon',
  `ClienteBanxico` CHAR(3)      NULL      COMMENT 'Clave STP, Obligatorio cuando el tipo de oepracion sea igual a S',
  `PlazaBanxico`   CHAR(3)      NULL      COMMENT 'Plaza STP, Obligatorio cuando el tipo de oepracion sea igual a S',
  `ClienteSTP`     CHAR(4)      NULL      COMMENT 'Numero de Cliente ante STP, Obligatorio cuando el tipo de oepracion sea igual a S',
  `URLWSPM` VARCHAR(200) NOT NULL DEFAULT '' COMMENT 'URL del Web Service para el alta de Cuentas Clabe para Personas Morales.',
  `URLWSPF` VARCHAR(200) NOT NULL DEFAULT '' COMMENT 'URL del Web Service para el alta de Cuentas Clabe para Personas Fisicas.',
  `FolioRecepcionPen` BIGINT(20) NOT NULL DEFAULT 0 COMMENT 'Ultimo folio de recepcion pendiente.',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`EmpresaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Parametros de la operacion SPEI'$$