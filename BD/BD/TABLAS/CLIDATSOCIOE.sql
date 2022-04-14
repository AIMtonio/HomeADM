-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIDATSOCIOE
DELIMITER ;
DROP TABLE IF EXISTS `CLIDATSOCIOE`;DELIMITER $$

CREATE TABLE `CLIDATSOCIOE` (
  `SocioEID` int(11) NOT NULL COMMENT 'Llave Principal para Los Datos SocioEconomicos de Un Cliente-Prospecto',
  `LinNegID` int(11) DEFAULT NULL COMMENT 'Llave Foranea Al Catalogo de Lineas de Negocio (Si lleva integridad Referencial)',
  `ProspectoID` int(11) DEFAULT NULL COMMENT 'Llave Foranea a la tabla de PROSPECTOS (no lleva integridad referencial)',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Lave foranea a tabla de Clientes (NO lleva integridad referencial)',
  `SolicitudCreditoID` int(11) DEFAULT NULL COMMENT 'Lave foranea a tabla de Solicitud de Credito (NO lleva integridad referencial)',
  `CatSocioEID` int(11) DEFAULT NULL COMMENT 'Lave foranea a tabla de Catalogo de Datos SocioEconomicos',
  `Monto` decimal(14,2) DEFAULT NULL COMMENT 'Monto capturado en pantalla',
  `FechaRegistro` date DEFAULT NULL COMMENT 'Indica la Fecha en que se Capturo el Dato SocioEconomico del Cte',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`SocioEID`),
  KEY `fk_CLIDATSOCIOE_1_idx` (`CatSocioEID`),
  KEY `fk_CLIDATSOCIOE_2_idx` (`LinNegID`),
  CONSTRAINT `fk_CLIDATSOCIOE_1` FOREIGN KEY (`CatSocioEID`) REFERENCES `CATDATSOCIOE` (`CatSocioEID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CLIDATSOCIOE_2` FOREIGN KEY (`LinNegID`) REFERENCES `CATLINEANEGOCIO` (`LinNegID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Datos Socioeconomicaos de un Cliente-Prospecto'$$