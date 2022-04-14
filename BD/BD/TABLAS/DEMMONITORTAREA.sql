-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DEMMONITORTAREA
DELIMITER ;
DROP TABLE IF EXISTS `DEMMONITORTAREA`;DELIMITER $$

CREATE TABLE `DEMMONITORTAREA` (
  `PIDTarea` varchar(50) NOT NULL COMMENT 'Identificador del hilo de ejecucion de la tarea',
  `TareaID` int(11) NOT NULL COMMENT 'Identificador de la tarea',
  `FechaHoraIni` datetime NOT NULL COMMENT 'Fecha y hora en la que se inicio la tarea',
  `EmpresaID` int(11) NOT NULL COMMENT 'Empresa ID',
  `Usuario` int(11) NOT NULL COMMENT 'Usuario ID',
  `FechaActual` datetime NOT NULL COMMENT 'Fecha Actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Direccion IP',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Programa de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Sucursal ID',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Numero de Transaccion',
  PRIMARY KEY (`PIDTarea`),
  KEY `INDEX_DEMMONITORTAREA_1` (`PIDTarea`),
  KEY `INDEX_DEMMONITORTAREA_2` (`TareaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para almacenar las tareas que actualmente se encuentran en ejecucion.'$$