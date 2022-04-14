-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DEMTAREA
DELIMITER ;
DROP TABLE IF EXISTS `DEMTAREA`;
DELIMITER $$


CREATE TABLE `DEMTAREA` (
  `TareaID` int(11) NOT NULL COMMENT 'Identificador de la tarea',
  `NombreClase` varchar(150) NOT NULL COMMENT 'Nombre completo de la clase incluyendo paquetes',
  `NombreJar` varchar(100) NOT NULL COMMENT 'Nombre completo del archivo jar que contiene la tarea',
  `NombreTarea` VARCHAR(100) NOT NULL COMMENT 'Nombre de la tarea',
  `Descripcion` TEXT NOT NULL COMMENT 'Descripcion de la tarea',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus de la tarea (A = Activo, R = Recargar, B = Baja)',
  `EjecucionMultiple` char(1) NOT NULL COMMENT 'Permite la ejecucion de varias instancias al mismo tiempo (S = SI, N = NO)',
  `CronEjecucion` varchar(50) NOT NULL COMMENT 'Configuracion del Trigger de ejecucion de la Tarea',
  `EmpresaID` int(11) NOT NULL COMMENT 'Empresa ID',
  `Usuario` int(11) NOT NULL COMMENT 'Usuario ID',
  `FechaActual` datetime NOT NULL COMMENT 'Fecha Actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Direccion IP',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Programa de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Sucursal ID',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Numero de Transaccion',
  PRIMARY KEY (`TareaID`),
  KEY `INDEX_DEMTAREA_1` (`TareaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para almacenar las tareas que el demonio debera cargar para ejecuciones.'$$
