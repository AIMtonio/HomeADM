-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISPARAINSTRUMM
DELIMITER ;
DROP TABLE IF EXISTS `HISPARAINSTRUMM`;DELIMITER $$

CREATE TABLE `HISPARAINSTRUMM` (
  `ConsecutivoID` int(11) NOT NULL COMMENT 'Consecutivo',
  `InstrumentMonID` int(11) DEFAULT NULL,
  `TipoInstruMonID` int(11) DEFAULT NULL COMMENT 'tipo de instrumento',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha Inicio ',
  `FechaFin` date DEFAULT NULL COMMENT 'Fecha fin de la vigencia',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de auditoria',
  `ProgramaID` varchar(45) DEFAULT NULL COMMENT 'Campo de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de auditoria',
  PRIMARY KEY (`ConsecutivoID`),
  KEY `fk_HISPARAINSTRUMMON_1` (`InstrumentMonID`),
  KEY `fk_HISPARAINSTRUMMON_2` (`TipoInstruMonID`),
  CONSTRAINT `fk_HISPARAINSTRUMMON_1` FOREIGN KEY (`InstrumentMonID`) REFERENCES `INSTRUMENTOSMON` (`InstrumentMonID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_HISPARAINSTRUMMON_2` FOREIGN KEY (`TipoInstruMonID`) REFERENCES `TIPOINSTRUMMONE` (`TipoInstruMonID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Historico de parametros de instrumentos monetarios'$$