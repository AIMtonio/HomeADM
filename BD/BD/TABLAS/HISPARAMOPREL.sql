-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISPARAMOPREL
DELIMITER ;
DROP TABLE IF EXISTS `HISPARAMOPREL`;DELIMITER $$

CREATE TABLE `HISPARAMOPREL` (
  `ConsecutivoID` int(11) NOT NULL,
  `MonedaLimOPR` int(11) DEFAULT NULL COMMENT 'Moneda limite de operaciones relevantes',
  `LimiteInferior` decimal(12,2) DEFAULT NULL COMMENT 'Limite inferior',
  `FechaInicioVig` date DEFAULT NULL COMMENT 'fecha de inicio de vigencia',
  `FechaFinVig` date DEFAULT NULL COMMENT 'fecha de fin de vigencia',
  `LimMensualMicro` decimal(12,2) DEFAULT NULL,
  `MonedaLimMicro` int(11) DEFAULT NULL COMMENT 'Moneda limite de operaciones de microcredito',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'empresa',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campos de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campos de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campos de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campos de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campos de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campos de auditoria',
  PRIMARY KEY (`ConsecutivoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Historico parametros de operaciones reelevantes'$$