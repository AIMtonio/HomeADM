-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GARANTIASFIRA
DELIMITER ;
DROP TABLE IF EXISTS `GARANTIASFIRA`;DELIMITER $$

CREATE TABLE `GARANTIASFIRA` (
  `GarantiaFIRAID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Columna principal autoincremental de la tabla.',
  `TipoGarantiaID` int(11) NOT NULL COMMENT 'LLave foranea de la tabla CATTIPOGARANTIAFIRA, sirve para saber el tipo de garantia\n\n1: FEGA\n2: FONAGA',
  `ClasificacionID` int(4) NOT NULL COMMENT 'LLave foranea de la tabla CLASIFICCREDITO, sirve para ver la clasificaciòn de credito.\n125: Operaciones de habitaciòn o AVIO\n126: Operaciones refaccionarias\n',
  `Porcentaje` decimal(14,2) NOT NULL COMMENT 'Almacenara el porcentaje que se le aplicara a la clasificacion referente a una garantia.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`GarantiaFIRAID`),
  KEY `GARANTIAFIRA_ibfk_1` (`TipoGarantiaID`),
  KEY `GARANTIAFIRA_ibfk_2` (`ClasificacionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Esta tabla se usara, para calcular el porcentaje correspondiente a las garantias \nde FEGA, FONAGA para productos de creditos AVIO y REFACCIONARIOS. '$$