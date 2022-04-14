-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSCUEPLANAHORRO
DELIMITER ;
DROP TABLE IF EXISTS `TIPOSCUEPLANAHORRO`;DELIMITER $$

CREATE TABLE `TIPOSCUEPLANAHORRO` (
  `PlanAhoID` int(11) NOT NULL COMMENT 'Identificador del Plan de Ahorro',
  `TipoCuentaID` int(11) NOT NULL COMMENT 'Identificador del Tipo de Cuenta de Ahorro',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`PlanAhoID`,`TipoCuentaID`),
  KEY `FK_TIPOSCUEPLANAHORRO_1` (`PlanAhoID`),
  KEY `FK_TIPOSCUEPLANAHORRO_2` (`TipoCuentaID`),
  CONSTRAINT `FK_TIPOSCUEPLANAHORRO_1` FOREIGN KEY (`PlanAhoID`) REFERENCES `TIPOSPLANAHORRO` (`PlanID`),
  CONSTRAINT `FK_TIPOSCUEPLANAHORRO_2` FOREIGN KEY (`TipoCuentaID`) REFERENCES `TIPOSCUENTAS` (`TipoCuentaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Almacena los Tipos de Cuentas de Ahorro por Plan de Ahorro'$$