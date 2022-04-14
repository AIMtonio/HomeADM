-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICIDOCREQ
DELIMITER ;
DROP TABLE IF EXISTS `SOLICIDOCREQ`;DELIMITER $$

CREATE TABLE `SOLICIDOCREQ` (
  `SolDocReqID` int(11) NOT NULL COMMENT 'Llave Primaria ',
  `ProducCreditoID` int(11) NOT NULL COMMENT 'Llave Foranea para Catalogo de Productos de Credito',
  `ClasificaTipDocID` int(11) NOT NULL COMMENT 'Llave Foranea para catalogo de Clasificacion de Documentos',
  `EmpresaID` int(11) NOT NULL COMMENT 'Campo de auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Campo de auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Campo de auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Campo de auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Campo de auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Campo de auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Campo de auditoria',
  PRIMARY KEY (`SolDocReqID`),
  KEY `fk_SOLICIDOCREQ_1` (`ProducCreditoID`),
  KEY `fk_SOLICIDOCREQ_2` (`ClasificaTipDocID`),
  CONSTRAINT `fk_SOLICIDOCREQ_1` FOREIGN KEY (`ProducCreditoID`) REFERENCES `PRODUCTOSCREDITO` (`ProducCreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_SOLICIDOCREQ_2` FOREIGN KEY (`ClasificaTipDocID`) REFERENCES `CLASIFICATIPDOC` (`ClasificaTipDocID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Parametros de Documentos Requeridos en la Solicitud de Credi'$$