-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORAREPARCHPERD
DELIMITER ;
DROP TABLE IF EXISTS `BITACORAREPARCHPERD`;DELIMITER $$

CREATE TABLE `BITACORAREPARCHPERD` (
  `TransaccionID` bigint(20) NOT NULL COMMENT 'Numero de Transaccion',
  `Fecha` date DEFAULT NULL COMMENT 'Fecha del Reporte',
  `RutaArchivoSubido` varchar(250) DEFAULT NULL COMMENT 'Ruta del Archivo subido',
  `RutaArchivoReporteG` varchar(250) DEFAULT NULL COMMENT 'Ruta de archivos de reporte Generado',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria',
  PRIMARY KEY (`TransaccionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Bitacora de Reporte de Archivos de Perdida FIRA'$$