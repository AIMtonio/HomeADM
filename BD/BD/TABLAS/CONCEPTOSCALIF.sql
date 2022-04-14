-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONCEPTOSCALIF
DELIMITER ;
DROP TABLE IF EXISTS `CONCEPTOSCALIF`;DELIMITER $$

CREATE TABLE `CONCEPTOSCALIF` (
  `ConceptoCalifID` int(11) NOT NULL DEFAULT '0' COMMENT 'Consecutivo de la tabla',
  `Concepto` char(5) DEFAULT NULL COMMENT 'Concepto a calificar',
  `Descripcion` varchar(100) DEFAULT NULL COMMENT 'Descripcion del concepto a calificar',
  `Puntos` float(12,2) DEFAULT NULL COMMENT 'Puntaje total que vale el concepto',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'ID de la empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` int(15) DEFAULT NULL,
  PRIMARY KEY (`ConceptoCalifID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena los diferentes conceptos que se tomaran en cuenta p'$$