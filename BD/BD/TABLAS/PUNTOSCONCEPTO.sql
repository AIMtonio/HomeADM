-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PUNTOSCONCEPTO
DELIMITER ;
DROP TABLE IF EXISTS `PUNTOSCONCEPTO`;DELIMITER $$

CREATE TABLE `PUNTOSCONCEPTO` (
  `PuntosConcepID` int(11) NOT NULL DEFAULT '0' COMMENT 'Consecutivo de la tabla',
  `ConceptoCalifID` int(11) NOT NULL DEFAULT '0' COMMENT 'Concepto al cual se le asiganaran los rangos',
  `RangoInferior` float(12,2) DEFAULT NULL COMMENT 'Valor del rango inferior',
  `RangoSuperior` float(12,2) DEFAULT NULL COMMENT 'Valor del rango superior',
  `Puntos` float(12,2) DEFAULT NULL COMMENT 'Puntaje total que vale el concepto',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'ID de la empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(20) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` int(15) DEFAULT NULL,
  PRIMARY KEY (`PuntosConcepID`,`ConceptoCalifID`),
  KEY `FK_ConceptoCalifID_1` (`ConceptoCalifID`),
  CONSTRAINT `FK_ConceptoCalifID_1` FOREIGN KEY (`ConceptoCalifID`) REFERENCES `CONCEPTOSCALIF` (`ConceptoCalifID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena los rangos de puntaje que se daran a cada concepto '$$