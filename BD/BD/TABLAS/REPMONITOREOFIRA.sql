-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REPMONITOREOFIRA
DELIMITER ;
DROP TABLE IF EXISTS `REPMONITOREOFIRA`;DELIMITER $$

CREATE TABLE `REPMONITOREOFIRA` (
  `TipoReporteID` int(11) NOT NULL COMMENT 'Tipo de Reporte Financiero (Corresponde a la tabla CATREPORTESFIRA).',
  `FechaGeneracion` date NOT NULL COMMENT 'Fecha en la que se genera el reporte.',
  `ConsecutivoID` int(11) NOT NULL COMMENT 'Número consecutivo por tipo de reporte.',
  `CSVReporte` mediumtext COMMENT 'Registro por renglón del reporte CSV.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`TipoReporteID`,`FechaGeneracion`,`ConsecutivoID`),
  KEY `IDX_REPMONITOREOFIRA_1` (`FechaGeneracion`),
  KEY `IDX_REPMONITOREOFIRA_2` (`TipoReporteID`,`FechaGeneracion`),
  KEY `IDX_REPMONITOREOFIRA_3` (`TipoReporteID`,`FechaGeneracion`,`NumTransaccion`),
  CONSTRAINT `FK_REPMONITOREOFIRA_1` FOREIGN KEY (`TipoReporteID`) REFERENCES `CATREPORTESFIRA` (`TipoReporteID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para guardar los reportes financieros de monitoreo FIRA.'$$