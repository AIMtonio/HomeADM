-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LINFONCONDEDO
DELIMITER ;
DROP TABLE IF EXISTS `LINFONCONDEDO`;DELIMITER $$

CREATE TABLE `LINFONCONDEDO` (
  `LineaFondeoID` int(11) NOT NULL COMMENT 'ID de la linea de Fondeo, Consecutivo de linea por Institucion de Fondeo (InstitutFondID)\n',
  `EstadoID` int(11) NOT NULL COMMENT 'ID del estado de la republica si es 0 = ''TODOS''',
  `MunicipioID` int(11) NOT NULL COMMENT 'ID del municipio del estado si es 0 = ''TODOS''',
  `LocalidadID` int(11) NOT NULL COMMENT 'ID de la localidad del municipio si es 0 = ''TODOS''',
  `NumHabitantesInf` int(11) DEFAULT NULL,
  `NumHabitantesSup` int(11) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`LineaFondeoID`,`EstadoID`,`MunicipioID`,`LocalidadID`),
  KEY `fk_LINFONCONDEDO_1_idx` (`LineaFondeoID`),
  KEY `fk_LINFONCONDEDO_2_idx` (`EstadoID`),
  KEY `fk_LINFONCONDEDO_3_idx` (`MunicipioID`,`EstadoID`),
  KEY `fk_LINFONCONDEDO_4_idx` (`EstadoID`,`MunicipioID`,`LocalidadID`),
  CONSTRAINT `fk_LINFONCONDEDO_1` FOREIGN KEY (`LineaFondeoID`) REFERENCES `LINEAFONDEADOR` (`LineaFondeoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Condiciones descto Lineas Fondeo para estados'$$