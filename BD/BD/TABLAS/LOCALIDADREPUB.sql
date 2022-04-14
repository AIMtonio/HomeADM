-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LOCALIDADREPUB
DELIMITER ;
DROP TABLE IF EXISTS `LOCALIDADREPUB`;

DELIMITER $$
CREATE TABLE `LOCALIDADREPUB` (
  `EstadoID` int(11) NOT NULL COMMENT 'ID Estado',
  `MunicipioID` int(11) NOT NULL COMMENT 'ID Municipio',
  `LocalidadID` int(11) NOT NULL COMMENT 'ID Localidad',
  `NombreLocalidad` varchar(200) DEFAULT NULL COMMENT 'Nombre de la localidad',
  `NombreLocalidad2` varchar(200) DEFAULT NULL,
  `NumHabitantes` int(11) DEFAULT NULL COMMENT 'Numero de Habitantes',
  `NumHabitantesHom` int(11) DEFAULT NULL,
  `NumHabitantesMuj` int(11) DEFAULT NULL,
  `EsMarginada` char(1) DEFAULT NULL COMMENT 'Indica si la Localidad es Marginada',
  `LocalidadCNBV` varchar(13) DEFAULT NULL,
  `ClaveRiesgo` char(1) DEFAULT NULL COMMENT 'Campo para matriz de riesgos PLD - valores A.- Alto , B.-Bajo',
  `ClaveRIPSF41` varchar(10) DEFAULT '' COMMENT 'Clave de Localidad de acuerdo al Catálogo RIPS F41.\nUtilizada en los Reportes de Operaciones Relevantes, Inusuales e Int. Preocupantes.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'campo de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'campo de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'campo de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'campo de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'campo de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'campo de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'campo de auditoria',
  PRIMARY KEY (`EstadoID`,`MunicipioID`,`LocalidadID`),
  KEY `MunicipioIDX` (`MunicipioID`),
  KEY `LocalidadIDX` (`LocalidadID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Localidades de la Republica'$$