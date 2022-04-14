-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLASIFICAGRPDOC
DELIMITER ;
DROP TABLE IF EXISTS `CLASIFICAGRPDOC`;DELIMITER $$

CREATE TABLE `CLASIFICAGRPDOC` (
  `GrupoDocID` int(11) NOT NULL,
  `ClasificaTipDocID` int(11) NOT NULL,
  `TipoDocumentoID` int(11) NOT NULL,
  `EmpresaID` int(11) NOT NULL,
  `Usuario` int(11) NOT NULL,
  `FechaActual` datetime NOT NULL,
  `DireccionIP` varchar(15) NOT NULL,
  `ProgramaID` varchar(50) NOT NULL,
  `Sucursal` int(11) NOT NULL,
  `NumTransaccion` bigint(20) NOT NULL,
  PRIMARY KEY (`GrupoDocID`),
  KEY `fk_CLASIFICATIPDOC_1` (`ClasificaTipDocID`),
  KEY `fk_TIPOSDOCUMENTOS_1` (`TipoDocumentoID`),
  CONSTRAINT `fk_CLASIFICATIPDOC_1` FOREIGN KEY (`ClasificaTipDocID`) REFERENCES `CLASIFICATIPDOC` (`ClasificaTipDocID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_TIPOSDOCUMENTOS_1` FOREIGN KEY (`TipoDocumentoID`) REFERENCES `TIPOSDOCUMENTOS` (`TipoDocumentoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Agrupacion de Documentos por ClasificaciÃ³n'$$