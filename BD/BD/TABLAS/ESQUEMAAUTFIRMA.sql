-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMAAUTFIRMA
DELIMITER ;
DROP TABLE IF EXISTS `ESQUEMAAUTFIRMA`;
DELIMITER $$


CREATE TABLE `ESQUEMAAUTFIRMA` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `SolicitudCreditoID` bigint(20) NOT NULL COMMENT 'Llave Foranea hacia la Solicitud de Credito',
  `EsquemaID` int(11) NOT NULL COMMENT 'Llave Foranea hacia el Catalogo de Esquema de Autorizacion (Sin integridad referencial)',
  `NumFirma` int(11) NOT NULL COMMENT 'Numero de Firma que Otorgo el Organo de Desicion\n1 = Firma 1\n2 = Firma 2\n3 = Firma 3\n4 = Firma 4\n5 = Firma 5',
  `OrganoID` int(11) NOT NULL COMMENT 'Llave Foranea hacia el Catalogo de Organos de Desicion (Sin integridad referencial)',
  `UsuarioFirma` int(11) NOT NULL COMMENT 'Llave Foranea hacia el Usuario que realizo la Firma',
  `FechaFirma` date NOT NULL COMMENT 'Fecha en que se registro la Firma',
  `EmpresaID` int(11) NOT NULL COMMENT 'Campo de auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Campo de auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Campo de auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Campo de auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Campo de auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Campo de auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Campo de auditoria',
  KEY `fk_ESQUEMAAUTFIRMA_1` (`SolicitudCreditoID`),
  KEY `fk_ESQUEMAAUTFIRMA_2` (`UsuarioFirma`),
  CONSTRAINT `fk_ESQUEMAAUTFIRMA_1` FOREIGN KEY (`SolicitudCreditoID`) REFERENCES `SOLICITUDCREDITO` (`SolicitudCreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_ESQUEMAAUTFIRMA_2` FOREIGN KEY (`UsuarioFirma`) REFERENCES `USUARIOS` (`UsuarioID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Firmas Otorgadas para la autorizacion de Solicitud'$$
