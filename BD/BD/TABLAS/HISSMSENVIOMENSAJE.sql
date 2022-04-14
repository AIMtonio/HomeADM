-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISSMSENVIOMENSAJE
DELIMITER ;
DROP TABLE IF EXISTS `HISSMSENVIOMENSAJE`;DELIMITER $$

CREATE TABLE `HISSMSENVIOMENSAJE` (
  `EnvioID` int(11) NOT NULL COMMENT 'ID de Envio ',
  `Estatus` char(2) DEFAULT NULL COMMENT 'Estatus\\\\nN: No enviado\\\\nE: Enviado\\\\nC: Cancelado',
  `Remitente` varchar(45) DEFAULT NULL COMMENT 'Remitente',
  `Receptor` varchar(45) DEFAULT NULL COMMENT 'Receptor',
  `FechaRealEnvio` datetime DEFAULT NULL COMMENT 'Fecha Real de Envio',
  `Mensaje` varchar(160) DEFAULT NULL COMMENT 'Mensaje',
  `ColMensaje` varchar(45) DEFAULT NULL COMMENT 'Mensaje',
  `FechaProgEnvio` datetime DEFAULT NULL COMMENT 'Fecha programada de envio',
  `CodExitoErr` varchar(10) DEFAULT NULL COMMENT 'Codigo de Exito o Error\\nE: Exito\\nF: Fallido\\nD: Desconocido',
  `CampaniaID` int(11) DEFAULT NULL COMMENT 'Campania a la que pertenece el sms',
  `CodigoRespuesta` varchar(10) DEFAULT NULL COMMENT 'Codigo de Respuesta del mensaje (obligatorio si la campaña es interactiva)',
  `FechaRespuesta` datetime DEFAULT NULL COMMENT 'Fecha de Respuesta por parte del cliente, en caso de ser campaña interactiva',
  `DatosCliente` varchar(100) DEFAULT NULL COMMENT 'Datos de cliente',
  `SistemaID` varchar(100) DEFAULT NULL COMMENT 'Identificador de sistema',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de auditoria',
  PRIMARY KEY (`EnvioID`),
  KEY `INDEX_HISSMSENVIOMENSAJE_1` (`CampaniaID`),
  KEY `INDEX_HISSMSENVIOMENSAJE_2` (`Estatus`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='His: Historico de envios de SMS'$$