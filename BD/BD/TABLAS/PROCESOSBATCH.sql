-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROCESOSBATCH
DELIMITER ;
DROP TABLE IF EXISTS `PROCESOSBATCH`;DELIMITER $$

CREATE TABLE `PROCESOSBATCH` (
  `ProcesoBatchID` int(11) NOT NULL COMMENT 'Numero del\nProceso Batch',
  `Descripcion` varchar(100) NOT NULL COMMENT 'Descripcion del\nProceso',
  `SubProceso` varchar(100) DEFAULT NULL COMMENT 'Sub Proceso',
  `NombreRutina` varchar(45) NOT NULL COMMENT 'Nombre de la \nRutina de ejecucion\ndel Store \nProcedure',
  `Empresa` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ProcesoBatchID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de los Diferentes Conceptos de los Procesos Batch'$$