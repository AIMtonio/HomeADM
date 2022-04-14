-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REPORTESXML
DELIMITER ;
DROP TABLE IF EXISTS `REPORTESXML`;
DELIMITER $$

CREATE TABLE `REPORTESXML` (
  `ReporteID` int(11) NOT NULL COMMENT 'ID del Reporte',
  `NombreReporte` varchar(45) NOT NULL COMMENT 'Nombre del Reporte',
  `DescripcionReporte` varchar(45) NOT NULL COMMENT 'Descripcion del reporte',
  `NombreArchivo` varchar(45) NOT NULL COMMENT 'Nombre del archivo',
  `Extension` varchar(10) DEFAULT '.xml' COMMENT 'Tipo de extensión del reporte generado.\n.xml (default).',
  `NombreSP` varchar(29) NOT NULL COMMENT 'Nombre del procedimiento que trae la informacion del reporte',
  `ElementoRoot` varchar(45) NOT NULL COMMENT 'Elemento raiz',
  `RutaRep` varchar(45) DEFAULT NULL COMMENT 'Ruta fisica en la que se ubicara el reporte.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`ReporteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla que almacena los reportes XML'$$