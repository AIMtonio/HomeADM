-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITODOCENT
DELIMITER ;
DROP TABLE IF EXISTS `CREDITODOCENT`;DELIMITER $$

CREATE TABLE `CREDITODOCENT` (
  `CreditoID` bigint(12) NOT NULL COMMENT 'Llave Foranea para Numero de Credito',
  `ProducCreditoID` int(11) NOT NULL COMMENT 'Llave Foranea para Catalogo de Productos de Credito',
  `ClasificaTipDocID` int(11) NOT NULL COMMENT 'Llave Foranea para catalogo de Clasificacion de Documentos',
  `DocAceptado` char(1) NOT NULL COMMENT 'Indica si el documento ya tiene el checklist por Mesa de Control',
  `TipoDocumentoID` int(11) NOT NULL COMMENT 'Llave Foranea para Catalogo de Documentos',
  `Comentarios` varchar(100) NOT NULL COMMENT 'Compo Obligatorio de Texto libre para los comentarios de quien realiza el checklist',
  `EmpresaID` int(11) NOT NULL COMMENT 'Campo de auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Campo de auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Campo de auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Campo de auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Campo de auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Campo de auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Campo de auditoria',
  PRIMARY KEY (`CreditoID`,`ProducCreditoID`,`ClasificaTipDocID`,`TipoDocumentoID`),
  KEY `fk_CREDITODOCENT_1` (`CreditoID`),
  KEY `fk_CREDITODOCENT_2` (`ProducCreditoID`),
  KEY `fk_CREDITODOCENT_3` (`ClasificaTipDocID`),
  KEY `fk_CREDITODOCENT_4` (`TipoDocumentoID`),
  CONSTRAINT `fk_CREDITODOCENT_1` FOREIGN KEY (`CreditoID`) REFERENCES `CREDITOS` (`CreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CREDITODOCENT_2` FOREIGN KEY (`ProducCreditoID`) REFERENCES `PRODUCTOSCREDITO` (`ProducCreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CREDITODOCENT_3` FOREIGN KEY (`ClasificaTipDocID`) REFERENCES `CLASIFICATIPDOC` (`ClasificaTipDocID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CREDITODOCENT_4` FOREIGN KEY (`TipoDocumentoID`) REFERENCES `TIPOSDOCUMENTOS` (`TipoDocumentoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Documentos por Cedito Requeridos-Entregados'$$