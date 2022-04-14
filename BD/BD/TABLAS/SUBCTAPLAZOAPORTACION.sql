-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAPLAZOAPORTACION
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTAPLAZOAPORTACION`;DELIMITER $$

CREATE TABLE `SUBCTAPLAZOAPORTACION` (
  `ConceptoAportID` int(5) NOT NULL DEFAULT '0' COMMENT 'PK de la tabla, Y FK que corresponde con la tabla de CONCEPTOSAPORTACION',
  `TipoAportacionID` int(11) NOT NULL COMMENT 'PK de la tabla, Y FK que corresponde con la tabla de TIPOSAPORTACIONES',
  `PlazoInferior` int(11) NOT NULL COMMENT 'Plazo Inferior',
  `PlazoSuperior` int(11) NOT NULL COMMENT 'Plazo Superior',
  `SubCuenta` char(2) DEFAULT NULL COMMENT 'Numeros que corresponden a la Subcuenta',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`ConceptoAportID`,`TipoAportacionID`,`PlazoInferior`,`PlazoSuperior`),
  KEY `fk_SUBCTAPLAZOAPORTACION_1` (`ConceptoAportID`),
  KEY `fk_SUBCTAPLAZOAPORTACION_2` (`TipoAportacionID`),
  CONSTRAINT `fk_SUBCTAPLAZOAPORTACION_2` FOREIGN KEY (`TipoAportacionID`) REFERENCES `TIPOSAPORTACIONES` (`TipoAportacionID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Subcuenta de Plazos para el Modulo de APORTACIONES'$$