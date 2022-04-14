-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOARCHIVOS
DELIMITER ;
DROP TABLE IF EXISTS `SEGTOARCHIVOS`;DELIMITER $$

CREATE TABLE `SEGTOARCHIVOS` (
  `SegtoPrograID` int(11) NOT NULL COMMENT 'Numero de Seguimiento de Campo',
  `NumSecuencia` int(11) NOT NULL COMMENT 'Numero de Consecutivo del Seguimiento',
  `FolioID` int(11) NOT NULL COMMENT 'Folio del Archivo adjunto',
  `Fecha` datetime DEFAULT NULL COMMENT 'Fecha en que se adjunto archivo\n',
  `RutaArchivo` varchar(60) DEFAULT NULL COMMENT 'Ruta donde se guarda el archivo\n',
  `NombreArchivo` varchar(100) DEFAULT NULL COMMENT 'Nombre del Archivo\n',
  `TipoDocumentoID` int(11) DEFAULT NULL COMMENT 'ID del Tipo Documento, FK TIPOSDOCUMENTOS\n',
  `Comentarios` varchar(100) DEFAULT NULL COMMENT 'Comentarios del Archivo adjunto',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(20) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`SegtoPrograID`,`NumSecuencia`,`FolioID`),
  KEY `fk_SEGTOARCHIVOS_1_idx` (`TipoDocumentoID`),
  CONSTRAINT `fk_SEGTOARCHIVOS_1` FOREIGN KEY (`TipoDocumentoID`) REFERENCES `TIPOSDOCUMENTOS` (`TipoDocumentoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para almacenar archivos adjuntos de seguimiento'$$