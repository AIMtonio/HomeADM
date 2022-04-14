-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOARCHIVOS
DELIMITER ;
DROP TABLE IF EXISTS `CREDITOARCHIVOS`;DELIMITER $$

CREATE TABLE `CREDITOARCHIVOS` (
  `DigCreaID` int(11) NOT NULL COMMENT 'Llave principal para registro de documentos digitalizados por credito(consecutivo)',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Llave foranea para la tabla de creditos',
  `TipoDocumentoID` int(11) NOT NULL COMMENT 'Llave foranea para la tabla de tipo de documentos\nque indica el documento en particular al que hace \nreferencia la digitalizacion.',
  `Comentario` varchar(200) DEFAULT NULL COMMENT 'comentario opcional en la digitalizacion',
  `Recurso` varchar(200) NOT NULL COMMENT 'ecurso o Nombre de la Página.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de auditoria',
  PRIMARY KEY (`DigCreaID`),
  KEY `fk_CREDTIOARCHIVOS_2` (`TipoDocumentoID`),
  KEY `fk_CREDITOARCHIVOS_1_idx` (`CreditoID`),
  CONSTRAINT `fk_CREDITOARCHIVOS_1` FOREIGN KEY (`CreditoID`) REFERENCES `CREDITOS` (`CreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CREDTIOARCHIVOS_2` FOREIGN KEY (`TipoDocumentoID`) REFERENCES `TIPOSDOCUMENTOS` (`TipoDocumentoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Registro de Documentos Digitalizados por Crédito'$$