-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LINFONCONDACT
DELIMITER ;
DROP TABLE IF EXISTS `LINFONCONDACT`;DELIMITER $$

CREATE TABLE `LINFONCONDACT` (
  `LineaFondeoID` int(11) NOT NULL COMMENT 'ID de la linea de Fondeo, Consecutivo de linea por Institucion de Fondeo (InstitutFondID)\n',
  `ActividadBMXID` varchar(15) NOT NULL COMMENT 'Identificador de tabla ACTIVIDADESBMX',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`LineaFondeoID`,`ActividadBMXID`),
  KEY `fk_LINFONCONDACT_1_idx` (`LineaFondeoID`),
  KEY `fk_LINFONCONDACT_2_idx` (`ActividadBMXID`),
  CONSTRAINT `fk_LINFONCONDACT_1` FOREIGN KEY (`LineaFondeoID`) REFERENCES `LINEAFONDEADOR` (`LineaFondeoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_LINFONCONDACT_2` FOREIGN KEY (`ActividadBMXID`) REFERENCES `ACTIVIDADESBMX` (`ActividadBMXID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Condiciones descto Lineas Fondeo para actividades'$$