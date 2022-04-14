-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ENVIOCORREO
DELIMITER ;
DROP TABLE IF EXISTS `ENVIOCORREO`;
DELIMITER $$


CREATE TABLE `ENVIOCORREO` (
  `CorreoID` int(11) NOT NULL,
  `Remitente` varchar(50) DEFAULT NULL COMMENT 'Correo del Remitente',
  `DestinatarioPLD` varchar(50) DEFAULT NULL COMMENT 'correo del Destinatario',
  `Asunto` varchar(150) DEFAULT NULL,
  `Origen` char(1) DEFAULT NULL COMMENT 'Origen: P.- PLD, B .- Banca Movil, G .- Guarda Valores ',
  `Mensaje` text COMMENT 'Cuerpo del mensaje de correo a enviar.',
  `Fecha` datetime DEFAULT NULL COMMENT 'Fecha de Registro',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus \\nE: Enviado\\nN: No enviado',
  `ServidorCorreo` varchar(30) DEFAULT NULL COMMENT 'Servidor de Correo',
  `Puerto` varchar(10) DEFAULT NULL COMMENT 'Puerto',
  `UsuarioCorreo` varchar(50) DEFAULT NULL,
  `Contrasenia` varchar(20) DEFAULT NULL COMMENT 'Contraseña del Remitente',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`CorreoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$