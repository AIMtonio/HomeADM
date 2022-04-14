-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATREPORTESFIRA
DELIMITER ;
DROP TABLE IF EXISTS `CATREPORTESFIRA`;DELIMITER $$

CREATE TABLE `CATREPORTESFIRA` (
  `TipoReporteID` int(11) NOT NULL COMMENT 'ID del Reporte.',
  `Nombre` varchar(200) NOT NULL COMMENT 'Nombre del Tipo de Reporte.',
  `NombreReporte` varchar(200) NOT NULL COMMENT 'Nombre del Archivo CSV a Generar.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  PRIMARY KEY (`TipoReporteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de los Reportes para el Monitoreo de la Cartera Agro (Fira).'$$