-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_ARCHIVOTRANSTEMP
DELIMITER ;
DROP TABLE IF EXISTS `TC_ARCHIVOTRANSTEMP`;DELIMITER $$

CREATE TABLE `TC_ARCHIVOTRANSTEMP` (
  `Transaccion` bigint(20) DEFAULT NULL COMMENT 'Numero de transaccion para la carga de archivos',
  `NumLinea` int(11) DEFAULT NULL COMMENT 'Numero de Linea',
  `Contenido` varchar(500) DEFAULT NULL COMMENT 'Contenido de cada linea del archivo',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: Tabla de Paso de los registros de archivos de transaccion'$$