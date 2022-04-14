-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICIDOCENT
DELIMITER ;
DROP TABLE IF EXISTS `SOLICIDOCENT`;DELIMITER $$

CREATE TABLE `SOLICIDOCENT` (
  `SolicitudCreditoID` bigint(20) NOT NULL COMMENT 'Llave Foranea para Solicitudes de Credito',
  `ProducCreditoID` int(11) NOT NULL COMMENT 'Llave Foranea para Catalogo de Productos de Credito',
  `ClasificaTipDocID` int(11) NOT NULL COMMENT 'Llave Foranea para catalogo de Clasificacion de Documentos',
  `DocRecibido` char(1) NOT NULL COMMENT 'Indica si el documento ya fue recibido por la Institucion',
  `TipoDocumentoID` int(11) NOT NULL COMMENT 'Llave Foranea para Catalogo de Documentos',
  `Comentarios` varchar(100) NOT NULL COMMENT 'Compo Obligatorio de Texto libre para los comentarios de quien realiza el checklist',
  `EmpresaID` int(11) NOT NULL COMMENT 'Campo de auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Campo de auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Campo de auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Campo de auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Campo de auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Campo de auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Campo de auditoria',
  PRIMARY KEY (`SolicitudCreditoID`,`ProducCreditoID`,`ClasificaTipDocID`),
  KEY `fk_SOLICIDOCENT_1` (`SolicitudCreditoID`),
  KEY `fk_SOLICIDOCENT_2` (`ProducCreditoID`),
  KEY `fk_SOLICIDOCENT_3` (`ClasificaTipDocID`),
  KEY `fk_SOLICIDOCENT_4` (`TipoDocumentoID`),
  CONSTRAINT `fk_SOLICIDOCENT_1` FOREIGN KEY (`SolicitudCreditoID`) REFERENCES `SOLICITUDCREDITO` (`SolicitudCreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_SOLICIDOCENT_2` FOREIGN KEY (`ProducCreditoID`) REFERENCES `PRODUCTOSCREDITO` (`ProducCreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_SOLICIDOCENT_3` FOREIGN KEY (`ClasificaTipDocID`) REFERENCES `CLASIFICATIPDOC` (`ClasificaTipDocID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_SOLICIDOCENT_4` FOREIGN KEY (`TipoDocumentoID`) REFERENCES `TIPOSDOCUMENTOS` (`TipoDocumentoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Documentos por Solicitud Requeridos-Entregados'$$