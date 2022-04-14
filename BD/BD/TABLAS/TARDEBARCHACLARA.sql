-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBARCHACLARA
DELIMITER ;
DROP TABLE IF EXISTS `TARDEBARCHACLARA`;DELIMITER $$

CREATE TABLE `TARDEBARCHACLARA` (
  `FolioID` varchar(22) NOT NULL COMMENT 'Llave Principal para Registro de Documentos Digitalizdos por Aclaraciones (llave compuesta por\nPrimero 20 digitos el numero de Reporte(ReporteID)\nSiempre los Ultimos 2 digitos son un consecutivo)',
  `ReporteID` bigint(20) DEFAULT NULL COMMENT 'Id Reporte de Aclaracion FK TARDEBACLARACION',
  `TipoArchivo` varchar(200) DEFAULT NULL COMMENT 'Indica el contenido del Archivo adjunto',
  `Recurso` varchar(250) DEFAULT NULL COMMENT 'Ruta al Archivo Adjunto',
  `NombreArchivo` varchar(150) DEFAULT NULL COMMENT 'Nombre del Archivo Adjuntado',
  `Fecha` date DEFAULT NULL COMMENT 'Fecha de Cuando se Adjunto el Archivo',
  `Sucursal` int(11) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`FolioID`),
  KEY `fk_TARDEBARCHACLARA_1_idx` (`ReporteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Registro de los los Archivos Adjuntos a la Aclaraci'$$