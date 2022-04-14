-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATFIRAPROGESP
DELIMITER ;
DROP TABLE IF EXISTS `CATFIRAPROGESP`;DELIMITER $$

CREATE TABLE `CATFIRAPROGESP` (
  `ClaveProgramaID` int(11) NOT NULL COMMENT 'Clave del Programa ID Interno',
  `CveSubProgramaID` varchar(10) NOT NULL COMMENT 'Clave del Programa FIRA\n',
  `SubPrograma` varchar(100) NOT NULL COMMENT 'Descripción del Programa FIRA',
  `FrenteTecnologico` char(1) NOT NULL COMMENT 'Es frente tecnologico\nS:Si\nN:No',
  `Vigente` char(1) DEFAULT NULL COMMENT 'Vigencia del Sub Programa\nS: Si\nN:No',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  PRIMARY KEY (`CveSubProgramaID`),
  UNIQUE KEY `CveSubPrograma_UNIQUE` (`CveSubProgramaID`),
  KEY `fk_CATFIRAPROGESP_1_idx` (`ClaveProgramaID`),
  CONSTRAINT `FK_CATFIRAPROGESP_1` FOREIGN KEY (`ClaveProgramaID`) REFERENCES `CATFIRAPROGRAMA` (`ClaveProgramaID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Programas Especiales Fira'$$