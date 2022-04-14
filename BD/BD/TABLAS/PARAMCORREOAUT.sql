-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMCORREOAUT
DELIMITER ;
DROP TABLE IF EXISTS `PARAMCORREOAUT`;DELIMITER $$

CREATE TABLE `PARAMCORREOAUT` (
  `CorreoAutoID` int(11) NOT NULL DEFAULT '0' COMMENT 'Consecutivo de la tabla',
  `Remitente` varchar(60) DEFAULT NULL COMMENT 'Correo Remitente',
  `Destinatario` varchar(60) DEFAULT NULL COMMENT 'Correo Destino',
  `CorreoAdcional` varchar(60) DEFAULT NULL COMMENT 'Correo Adicional',
  `Asunto` varchar(150) DEFAULT NULL COMMENT 'Asunto sobre el correo',
  `Mensaje` varchar(500) DEFAULT NULL COMMENT 'Mensaje del correo',
  `MensajeAdic` varchar(500) DEFAULT NULL COMMENT 'Mensaje Adicional',
  `Servidor` varchar(30) DEFAULT NULL COMMENT 'Servidor de salida que ocupa el correo',
  `Puerto` int(10) DEFAULT NULL COMMENT 'puerto que ocupa para enviar los correos',
  `UsuarioCorreo` varchar(60) DEFAULT NULL COMMENT 'usuario del correo remitente',
  `contrasenia` varchar(30) DEFAULT NULL COMMENT 'contraseña del correo remitente',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'EmpresaID Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Usuario de Sesion Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Fecha Actual campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'DireccionIP de donde se realiza la transaccion Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Programa que reliza la transaccion Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Sucursal que realiza la transaccion Campo de Auditoria',
  `NumTransaccion` int(15) DEFAULT NULL COMMENT 'Numero de Transaccion Campo de Auditoria',
  PRIMARY KEY (`CorreoAutoID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1$$