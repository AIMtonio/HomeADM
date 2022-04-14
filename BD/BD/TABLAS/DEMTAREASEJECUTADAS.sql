-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DEMTAREASEJECUTADAS
DELIMITER ;
DROP TABLE IF EXISTS `DEMTAREASEJECUTADAS`;DELIMITER $$

CREATE TABLE `DEMTAREASEJECUTADAS` (
  `TareaID` int(11) NOT NULL COMMENT 'Identificador de la tarea',
  `CodigoResuesta` varchar(10) NOT NULL COMMENT 'Codigo de respuesta que se obtuvo al ejecutar la tarea',
  `MensajeRespuesta` varchar(500) NOT NULL COMMENT 'Mensaje de respuesta que se obtuvo al ejecutar la tarea',
  `PidTarea` varchar(50) NOT NULL COMMENT 'PID de la tarea que se le asigno a la hora de ser ejecutada',
  `FechaInicio` datetime NOT NULL COMMENT 'Fecha y hora en la que se registro el inicio de la tarea, puede diferir unos segundos, segun lo programado',
  `FechaFin` datetime NOT NULL COMMENT 'Fecha en la que se registra la finalizacion de la tarea',
  `EmpresaID` int(11) NOT NULL COMMENT 'Empresa ID',
  `Usuario` int(11) NOT NULL COMMENT 'Usuario ID',
  `FechaActual` datetime NOT NULL COMMENT 'Fecha Actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Direccion IP',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Programa de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Sucursal ID',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Numero de Transaccion',
  PRIMARY KEY (`PidTarea`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para almacenar una bitacora de las tareas que han sido ejecutadas por el scheduler (demonio)'$$