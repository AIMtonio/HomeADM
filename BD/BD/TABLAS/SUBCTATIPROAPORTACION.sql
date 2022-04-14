-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTATIPROAPORTACION
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTATIPROAPORTACION`;DELIMITER $$

CREATE TABLE `SUBCTATIPROAPORTACION` (
  `ConceptoAportID` int(5) NOT NULL COMMENT 'PK de la tabla, Y FK que corresponde con la tabla de CONCEPTOSAPORTACION',
  `TipoAportacionID` int(11) NOT NULL COMMENT 'ID del Tipo de Producto ',
  `SubCuenta` char(2) DEFAULT NULL COMMENT 'Numeros que corresponde a la subcuenta',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`ConceptoAportID`,`TipoAportacionID`),
  KEY `TipoAportacionID` (`TipoAportacionID`),
  KEY `fk_SUBCTATIPROAPORTACION_1` (`ConceptoAportID`),
  CONSTRAINT `fk_SUBCTATIPROAPORTACION_1` FOREIGN KEY (`ConceptoAportID`) REFERENCES `CONCEPTOSAPORTACION` (`ConceptoAportID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_SUBCTATIPROAPORTACION_2` FOREIGN KEY (`TipoAportacionID`) REFERENCES `TIPOSAPORTACIONES` (`TipoAportacionID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Subcuenta de Tipos de APORTACIONES para el Modulo de APORTACIONES'$$