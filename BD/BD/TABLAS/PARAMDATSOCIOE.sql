-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMDATSOCIOE
DELIMITER ;
DROP TABLE IF EXISTS `PARAMDATSOCIOE`;DELIMITER $$

CREATE TABLE `PARAMDATSOCIOE` (
  `ParSocioEID` int(11) NOT NULL COMMENT 'Llave Principal para Parametros de Datos SocioEconomicos(Consecutivo)',
  `TipoPersona` char(1) DEFAULT NULL COMMENT 'Tipo de Personalidad del Cliente \\nM.- Persona Moral \\nA.- Persona Fisica Con Actividad Empresarial \\nF.- Persona Fisica Sin Actividad Empresarial',
  `LinNegID` int(11) DEFAULT NULL COMMENT 'Llave Foranea Al Catalogo de Lineas de Negocio (Si lleva integridad Referencial)',
  `CatSocioEID` int(11) DEFAULT NULL COMMENT 'Llave Foranea a la tabla del Catalogo de los datos SocioEconomicos',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ParSocioEID`),
  KEY `fk_PARAMDATSOCIOE_1_idx` (`CatSocioEID`),
  KEY `fk_PARAMDATSOCIOE_2_idx` (`LinNegID`),
  CONSTRAINT `fk_PARAMDATSOCIOE_1` FOREIGN KEY (`CatSocioEID`) REFERENCES `CATDATSOCIOE` (`CatSocioEID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_PARAMDATSOCIOE_2` FOREIGN KEY (`LinNegID`) REFERENCES `CATLINEANEGOCIO` (`LinNegID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Parametrizacion de Datos Socioeconomicos Solicitados por Tip'$$