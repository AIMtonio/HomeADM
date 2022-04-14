-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPREPFIRARIESGOCRED
DELIMITER ;
DROP TABLE IF EXISTS `TMPREPFIRARIESGOCRED`;DELIMITER $$

CREATE TABLE `TMPREPFIRARIESGOCRED` (
  `TransaccionID` varchar(45) NOT NULL COMMENT 'Numero de Transaccion',
  `Numero` int(11) NOT NULL COMMENT 'Numero de cap',
  `OperFonFira` decimal(18,2) DEFAULT '0.00' COMMENT 'OPERACIONES FONDEO FIRA',
  `OperOtrasFuen` decimal(18,2) DEFAULT '0.00' COMMENT 'OPERACIONES OTRAS FUENTES DE FONDEO',
  `OperNoLegibles` decimal(18,2) DEFAULT '0.00' COMMENT 'OPERACIONES NO ELEGIBLES FIRA',
  `EmpresaID` int(11) DEFAULT '1' COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT '1' COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT '127.0.0.1' COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT 'WORKBENCH' COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT '1' COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT '1' COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`Numero`,`TransaccionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Temporal para el reporte de riesgo de creditos'$$