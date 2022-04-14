-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAINSTRUMMON
DELIMITER ;
DROP TABLE IF EXISTS `PARAINSTRUMMON`;DELIMITER $$

CREATE TABLE `PARAINSTRUMMON` (
  `InstrumentMonID` int(11) NOT NULL COMMENT 'Instrumento monetario',
  `TipoInstruMonID` int(11) DEFAULT NULL COMMENT 'tipo de instrumento',
  `FechaInicio` date DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(45) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  KEY `fk_PARAINSTRUMMON_1` (`InstrumentMonID`),
  KEY `fk_PARAINSTRUMMON_2` (`TipoInstruMonID`),
  CONSTRAINT `fk_PARAINSTRUMMON_1` FOREIGN KEY (`InstrumentMonID`) REFERENCES `INSTRUMENTOSMON` (`InstrumentMonID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_PARAINSTRUMMON_2` FOREIGN KEY (`TipoInstruMonID`) REFERENCES `TIPOINSTRUMMONE` (`TipoInstruMonID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de parametros de instrumentos monetarios'$$