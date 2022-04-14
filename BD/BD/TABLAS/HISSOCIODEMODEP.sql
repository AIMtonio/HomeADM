-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISSOCIODEMODEP
DELIMITER ;
DROP TABLE IF EXISTS `HISSOCIODEMODEP`;DELIMITER $$

CREATE TABLE `HISSOCIODEMODEP` (
  `ProspectoID` int(11) DEFAULT NULL COMMENT 'Llave Foranea a PROSPECTOS (sin Integridad Relacional)',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Llave Foranea a CLIENTES (Sin Integridad relacional)',
  `Consecutivo` int(11) DEFAULT NULL COMMENT 'Consecutivo por Cliente o Prospecto para identificar el  registro que se fue a historico',
  `FechaRegistro` date DEFAULT NULL COMMENT 'Fecha en que se registraron los dependientes economicos',
  `FechaHistorico` date DEFAULT NULL COMMENT 'Fecha del pase a Historico',
  `TipoRelacionID` int(11) DEFAULT NULL COMMENT 'Llave foranea al catalogo de Tipos de Relacion  TIPORELACIONES',
  `PrimerNombre` varchar(25) DEFAULT NULL COMMENT 'Primer nombre del Dependiente Economico',
  `SegundoNombre` varchar(25) DEFAULT NULL COMMENT 'Segundo nombre del Dependiente Economico',
  `TercerNombre` varchar(25) DEFAULT NULL COMMENT 'Tercer Nombre del Dependiente Economico',
  `ApellidoPaterno` varchar(30) DEFAULT NULL COMMENT 'Apellido Paterno del Dependiente Economico',
  `ApellidoMaterno` varchar(30) DEFAULT NULL COMMENT 'Apellido Materno del Dependiente Economico',
  `Edad` int(11) NOT NULL COMMENT 'Edad del Dependiente Economico',
  `OcupacionID` int(11) NOT NULL COMMENT 'Identificador de la ocupacion',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  KEY `fk_HISSOCIODEMODEP_1_idx` (`TipoRelacionID`),
  CONSTRAINT `fk_HISSOCIODEMODEP_1` FOREIGN KEY (`TipoRelacionID`) REFERENCES `TIPORELACIONES` (`TipoRelacionID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Historico de Dependientes Economicos de Prospecto-Cliente en'$$