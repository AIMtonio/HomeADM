-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CHECLIST
DELIMITER ;
DROP TABLE IF EXISTS `CHECLIST`;DELIMITER $$

CREATE TABLE `CHECLIST` (
  `CheckListCteID` int(11) NOT NULL,
  `GrupoDocumentoID` int(11) DEFAULT NULL,
  `TipoDocumentoID` int(11) DEFAULT NULL,
  `Instrumento` bigint(20) DEFAULT NULL,
  `TipoInstrumentoID` int(11) DEFAULT NULL COMMENT 'Indica el tipo de Instrumento',
  `Comentario` varchar(200) DEFAULT NULL,
  `Aceptado` char(1) DEFAULT NULL COMMENT 'Indica si el documento ha sido aceptado o no S=si N= no',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`CheckListCteID`),
  KEY `fk_CHECLISTCTE_1_idx` (`GrupoDocumentoID`),
  KEY `fk_CHECLISTCTE_2_idx` (`TipoDocumentoID`),
  KEY `fk_CHECLISTCTE_3_idx` (`Instrumento`),
  KEY `fk_CHECLIST_1_idx` (`TipoInstrumentoID`),
  CONSTRAINT `fk_CHECLISTCTES_1` FOREIGN KEY (`TipoDocumentoID`) REFERENCES `TIPOSDOCUMENTOS` (`TipoDocumentoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CHECLISTCTE_1` FOREIGN KEY (`GrupoDocumentoID`) REFERENCES `GRUPODOCUMENTOS` (`GrupoDocumentoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CHECLIST_1` FOREIGN KEY (`TipoInstrumentoID`) REFERENCES `TIPOINSTRUMENTOS` (`TipoInstrumentoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para guardar check list de Registro de Cliente'$$