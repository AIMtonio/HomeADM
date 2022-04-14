-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISCLIDATSOCIOE
DELIMITER ;
DROP TABLE IF EXISTS `HISCLIDATSOCIOE`;DELIMITER $$

CREATE TABLE `HISCLIDATSOCIOE` (
  `HisSocioEID` int(11) NOT NULL COMMENT 'Llave Principal para Los Datos SocioEconomicos de Un Cliente-Prospecto',
  `LinNegID` int(11) DEFAULT NULL COMMENT 'Llave Foranea Al Catalogo de Lineas de Negocio (Si lleva integridad Referencial)',
  `SocioEID` int(11) DEFAULT NULL COMMENT 'Id que tenia el Dato Socioeconomico cuando era vigente',
  `ProspectoID` int(11) DEFAULT NULL COMMENT 'Llave Foranea a la tabla de PROSPECTOS (no lleva integridad referecnial)',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Lave foranea a tabla de Clientes (NO lleva integridad referencial)',
  `SolicitudCreditoID` int(11) DEFAULT NULL COMMENT 'Lave foranea a tabla de Solicitud de Credito (NO lleva integridad referencial)',
  `CatSocioEID` int(11) DEFAULT NULL COMMENT 'Lave foranea a tabla de Catalogo de Datos SocioEconomicos',
  `Monto` decimal(14,2) DEFAULT NULL COMMENT 'Monto capturado en pantalla',
  `FechaRegistro` date DEFAULT NULL COMMENT 'Indica la Fecha en que se Capturo el Dato SocioEconomico del Cte',
  `FechaFinal` date DEFAULT NULL COMMENT 'Indica la Fecha en que se paso a historico',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`HisSocioEID`),
  KEY `fk_HISCLIDATSOCIOE_1_idx` (`LinNegID`),
  CONSTRAINT `fk_HISCLIDATSOCIOE_1` FOREIGN KEY (`LinNegID`) REFERENCES `CATLINEANEGOCIO` (`LinNegID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Historico de los Datos SocioEconomicos del Cliente-Prospecto'$$