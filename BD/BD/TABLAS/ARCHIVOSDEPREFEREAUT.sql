-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARCHIVOSDEPREFEREAUT
DELIMITER ;
DROP TABLE IF EXISTS `ARCHIVOSDEPREFEREAUT`;DELIMITER $$

CREATE TABLE `ARCHIVOSDEPREFEREAUT` (
  `ConsecutivoID` int(11) NOT NULL COMMENT 'Valor consecutivo autoincrementado para los registros de la tabla',
  `NombreArchivo` varchar(80) DEFAULT NULL COMMENT 'Nombre del archivo que se esta leyendo del deposito referenciado',
  `RutaArchivo` varchar(300) DEFAULT NULL COMMENT 'Ruta completa de donde se toma el deposito referenciado',
  `FechaCarga` datetime DEFAULT NULL COMMENT 'Fecha en que se realizo la carga del archivo',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus del Archivo N= Nuevo sin leer, T= Terminado leido',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`ConsecutivoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TAB: Tabla que contiene los nombres y rutas de archivos a de depositos referenciados'$$