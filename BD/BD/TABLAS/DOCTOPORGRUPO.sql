-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DOCTOPORGRUPO
DELIMITER ;
DROP TABLE IF EXISTS `DOCTOPORGRUPO`;DELIMITER $$

CREATE TABLE `DOCTOPORGRUPO` (
  `DoctoPorGrupoID` int(11) NOT NULL COMMENT 'ID de la tabla',
  `GrupoDocumentoID` int(11) DEFAULT NULL COMMENT 'ID de la tabla GRUPODOCUMENTOS',
  `TipoDocumentoID` int(11) DEFAULT NULL COMMENT 'id de la tabla TIPOSDOCUMENTOS',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`DoctoPorGrupoID`),
  KEY `fk_CLASIFICAGRPDOC_1_idx` (`GrupoDocumentoID`),
  KEY `fk_CLASIFICAGRPDOC_2_idx` (`TipoDocumentoID`),
  CONSTRAINT `fk_CLASIFICAGRPDOC_1` FOREIGN KEY (`GrupoDocumentoID`) REFERENCES `GRUPODOCUMENTOS` (`GrupoDocumentoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CLASIFICAGRPDOC_2` FOREIGN KEY (`TipoDocumentoID`) REFERENCES `TIPOSDOCUMENTOS` (`TipoDocumentoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para la Clasificacion de Documentos '$$