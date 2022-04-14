-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- tmp_email
DELIMITER ;
DROP TABLE IF EXISTS `tmp_email`;DELIMITER $$

CREATE TABLE `tmp_email` (
  `CorreoID` int(11) DEFAULT NULL,
  `Remitente` varchar(50) DEFAULT NULL,
  `DestinatarioPLD` varchar(50) DEFAULT NULL,
  `Mensaje` mediumtext,
  `Fecha` datetime DEFAULT NULL,
  `Estatus` char(1) DEFAULT NULL,
  `ServidorCorreo` varchar(30) DEFAULT NULL,
  `Puerto` varchar(10) DEFAULT NULL,
  `Contrasenia` varchar(20) DEFAULT NULL,
  `Asunto` varchar(150) DEFAULT NULL,
  `UsuarioCorreo` varchar(50) DEFAULT NULL,
  `DestinatarioError` varchar(50) DEFAULT NULL,
  `AsuntoError` varchar(150) DEFAULT NULL,
  `MensajeError` text
) ENGINE=MyISAM DEFAULT CHARSET=utf8$$