-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSENVIOMENSAJE
DELIMITER ;
DROP TABLE IF EXISTS `SMSENVIOMENSAJE`;DELIMITER $$

CREATE TABLE `SMSENVIOMENSAJE` (
  `EnvioID` int(11) NOT NULL COMMENT 'ID de Envio ',
  `Estatus` char(2) DEFAULT NULL COMMENT 'Estatus\\\\nN: No enviado\\\\nE: Enviado\\\\nC: Cancelado',
  `Remitente` varchar(45) DEFAULT NULL COMMENT 'Remitente',
  `Receptor` varchar(45) DEFAULT NULL COMMENT 'Receptor',
  `FechaRealEnvio` datetime DEFAULT NULL COMMENT 'Fecha Real de Envio',
  `Mensaje` varchar(160) DEFAULT NULL COMMENT 'Mensaje',
  `ColMensaje` varchar(45) DEFAULT NULL,
  `FechaProgEnvio` datetime DEFAULT NULL COMMENT 'Fecha programada de envio',
  `CodExitoErr` varchar(10) DEFAULT NULL COMMENT 'Codigo de Exito o Error\\nE: Exito\\nF: Fallido\\nD: Desconocido',
  `CampaniaID` int(11) DEFAULT NULL COMMENT 'Campania a la que pertenece el sms',
  `CodigoRespuesta` varchar(10) DEFAULT NULL COMMENT 'Codigo de Respuesta del mensaje (obligatorio si la campaña es interactiva)',
  `FechaRespuesta` datetime DEFAULT NULL COMMENT 'Fecha de Respuesta por parte del cliente, en caso de ser campaña interactiva',
  `DatosCliente` varchar(100) DEFAULT NULL,
  `SistemaID` varchar(100) DEFAULT NULL,
  `PIDTarea` varchar(50) NOT NULL COMMENT 'Identificador del hilo de ejecucion de la tarea',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Tabla de envios de SMS',
  PRIMARY KEY (`EnvioID`),
  KEY `fk_SMSENVIOMENSAJE_CAMPANIA_idx` (`CampaniaID`),
  CONSTRAINT `fk_SMSENVIOMENSAJE_CAMPANIA` FOREIGN KEY (`CampaniaID`) REFERENCES `SMSCAMPANIAS` (`CampaniaID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de envios de SMS'$$