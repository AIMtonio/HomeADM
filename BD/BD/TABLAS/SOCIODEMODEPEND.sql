-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOCIODEMODEPEND
DELIMITER ;
DROP TABLE IF EXISTS `SOCIODEMODEPEND`;DELIMITER $$

CREATE TABLE `SOCIODEMODEPEND` (
  `DependienteID` int(11) NOT NULL,
  `ProspectoID` int(11) NOT NULL COMMENT 'Llave Foranea a PROSPECTOS (sin Integridad Relacional)',
  `ClienteID` int(11) NOT NULL COMMENT 'Llave Foranea a CLIENTES (Sin Integridad relacional)',
  `FechaRegistro` date NOT NULL COMMENT 'Fecha en que se registraron los dependientes economicos',
  `TipoRelacionID` int(11) NOT NULL COMMENT 'Llave foranea al catalogo de Tipos de Relacion  TIPORELACIONES',
  `PrimerNombre` varchar(25) NOT NULL COMMENT 'Primer nombre del Dependiente Economico',
  `SegundoNombre` varchar(25) NOT NULL COMMENT 'Segundo nombre del Dependiente Economico',
  `TercerNombre` varchar(25) NOT NULL COMMENT 'Tercer Nombre del Dependiente Economico',
  `ApellidoPaterno` varchar(30) NOT NULL COMMENT 'Apellido Paterno del Dependiente Economico',
  `ApellidoMaterno` varchar(30) NOT NULL COMMENT 'Apellido Materno del Dependiente Economico',
  `Edad` int(11) NOT NULL COMMENT 'Edad del Dependiente Economico',
  `OcupacionID` int(11) NOT NULL COMMENT 'Identificador de la ocupacion',
  `EmpresaID` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`DependienteID`),
  KEY `fk_SOCIODEMODEPEND_1_idx` (`TipoRelacionID`),
  KEY `idx_SOCIODEMODEPEND_1` (`ClienteID`),
  KEY `idx_SOCIODEMODEPEND_2` (`PrimerNombre`,`SegundoNombre`,`TercerNombre`,`ApellidoPaterno`,`ApellidoMaterno`),
  CONSTRAINT `fk_SOCIODEMODEPEND_1` FOREIGN KEY (`TipoRelacionID`) REFERENCES `TIPORELACIONES` (`TipoRelacionID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Dependientes Economicos de Prospecto-Cliente en datos Sociod'$$