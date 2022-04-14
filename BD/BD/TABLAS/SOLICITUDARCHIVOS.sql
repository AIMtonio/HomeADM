-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICITUDARCHIVOS
DELIMITER ;
DROP TABLE IF EXISTS `SOLICITUDARCHIVOS`;
DELIMITER $$


CREATE TABLE `SOLICITUDARCHIVOS` (
  `DigSolID` int(11) NOT NULL COMMENT 'Llave principal para registro de documentos digitalizados por solicitud de credito(consecutivo)',
  `SolicitudCreditoID` bigint(20) NOT NULL COMMENT 'Llave foranea para la tabla de SOLICITUDCREDITO',
  `TipoDocumentoID` int(11) NOT NULL COMMENT 'Llave foranea para la tabla de tipo de documentos\nque indica el documento en particular al que hace \nreferencia la digitalizacion.',
  `Comentario` varchar(200) DEFAULT NULL COMMENT 'comentario opcional en la digitalizacion',
  `Recurso` varchar(200) DEFAULT NULL COMMENT 'Recurso o Nombre de la Página.',
  `VoBoAnalista` char(1) DEFAULT NULL COMMENT 'Visto bueno del analistas /S si /N no',
  `ComentarioAnalista` varchar(200) DEFAULT NULL COMMENT 'Comentarios del analista',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de auditoria',
  PRIMARY KEY (`DigSolID`),
  KEY `fk_SOLICITUDARCHIVOS_1_idx` (`SolicitudCreditoID`),
  KEY `fk_SOLICITUDARCHIVOS_2_idx` (`TipoDocumentoID`),
  CONSTRAINT `fk_SOLICITUDARCHIVOS_1` FOREIGN KEY (`SolicitudCreditoID`) REFERENCES `SOLICITUDCREDITO` (`SolicitudCreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_SOLICITUDARCHIVOS_2` FOREIGN KEY (`TipoDocumentoID`) REFERENCES `CLASIFICATIPDOC` (`ClasificaTipDocID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Registro de Documentos Digitalizados por Solicitud de Crédito'$$