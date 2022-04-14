-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARENVIOCORREOPARAM
DELIMITER ;
DROP TABLE IF EXISTS `TARENVIOCORREOPARAM`;DELIMITER $$

CREATE TABLE `TARENVIOCORREOPARAM` (
  `RemitenteID` int(11) NOT NULL COMMENT 'ID de la empresa',
  `Descripcion` varchar(80) NOT NULL COMMENT 'Nombre con el que se identifica el remitente',
  `ServidorSMTP` varchar(80) NOT NULL COMMENT 'Direccion del servidor SMTP',
  `PuertoServerSMTP` varchar(6) NOT NULL COMMENT 'Puerto del servidor SMTP',
  `TipoSeguridad` char(2) NOT NULL COMMENT 'Tipo de seguridad(N-Ninguna,S-SSL,T-STARTTLS )',
  `CorreoSalida` varchar(80) NOT NULL COMMENT 'Direccion correo donde saldran los correos',
  `AliasRemitente` varchar(30) NOT NULL COMMENT 'Alias del correo remitente',
  `ConAutentificacion` char(1) NOT NULL COMMENT '(S-N) indica si el correo de salida requiere autentificacion',
  `Contrasenia` varchar(20) NOT NULL COMMENT 'Contraseña del correo de salida',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus del remitente (A-B)',
  `Comentario` varchar(200) NOT NULL COMMENT 'Comentarios',
  `TamanioMax` int(11) NOT NULL COMMENT 'Tamanio maximo permitido de los archivos adjuntos',
  `Tipo` char(2) NOT NULL COMMENT 'Tipo de representacion para el campo tamanioMax MB-Megabytes y KB-Kilobytes',
  `EmpresaID` int(11) NOT NULL COMMENT 'Empresa ID',
  `Usuario` int(11) NOT NULL COMMENT 'Usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Fecha Actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Direccion IP',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Programa de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Sucursal ID',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Numero de Transaccion',
  PRIMARY KEY (`RemitenteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para envio de correos'$$