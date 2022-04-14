-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DEMLOGTAREA
DELIMITER ;
DROP TABLE IF EXISTS `DEMLOGTAREA`;DELIMITER $$

CREATE TABLE `DEMLOGTAREA` (
  `PIDTarea` varchar(50) NOT NULL COMMENT 'Identificador del hilo de ejecucion de la tarea',
  `TareaID` int(11) NOT NULL COMMENT 'Identificador de la tarea',
  `FechaHoraEjec` datetime NOT NULL COMMENT 'Fecha y hora del mensaje',
  `CodigoRespuesta` varchar(50) NOT NULL COMMENT 'Codigo de mensaje',
  `MensajeRespuesta` text NOT NULL COMMENT 'Mensaje de la tarea',
  `EmpresaID` int(11) NOT NULL COMMENT 'Empresa ID',
  `Usuario` int(11) NOT NULL COMMENT 'Usuario ID',
  `FechaActual` datetime NOT NULL COMMENT 'Fecha Actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Direccion IP',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Programa de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Sucursal ID',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Numero de Transaccion',
  KEY `INDEX_DEMLOGTAREA_1` (`PIDTarea`),
  KEY `INDEX_DEMLOGTAREA_2` (`TareaID`),
  CONSTRAINT `FK_DEMLOGTAREA_1` FOREIGN KEY (`TareaID`) REFERENCES `DEMTAREA` (`TareaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para almacenar el log de las tareas.'$$