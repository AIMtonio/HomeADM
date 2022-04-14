-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSRECEPMENSAJE
DELIMITER ;
DROP TABLE IF EXISTS `SMSRECEPMENSAJE`;DELIMITER $$

CREATE TABLE `SMSRECEPMENSAJE` (
  `RecepMensajeID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador de los mensajes recibidos.',
  `Estatus` char(1) DEFAULT NULL COMMENT 'R= RECIBIDO, P=PROCESADO, C=CANCELADO',
  `Remitente` varchar(45) DEFAULT NULL COMMENT 'Remitente del mensaje recibido.',
  `FechaRealEnvio` varchar(45) DEFAULT NULL COMMENT 'Fecha real en que se procesa este mensaje.',
  `Mensaje` varchar(160) DEFAULT NULL COMMENT 'Mensaje que se recibio.',
  `CampaniaID` int(11) DEFAULT NULL COMMENT 'El numero de campania a la pertenece el mensaje.',
  `FechaRecepcion` datetime DEFAULT NULL COMMENT 'Fecha en la que se recibio el mensaje.',
  PRIMARY KEY (`RecepMensajeID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$