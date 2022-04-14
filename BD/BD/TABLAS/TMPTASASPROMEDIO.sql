-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPTASASPROMEDIO
DELIMITER ;
DROP TABLE IF EXISTS `TMPTASASPROMEDIO`;DELIMITER $$

CREATE TABLE `TMPTASASPROMEDIO` (
  `TasaBaseID` int(2) NOT NULL DEFAULT '0' COMMENT 'ID de la Tasa Base',
  `ValorProm` decimal(12,4) DEFAULT NULL COMMENT 'Valor de la Tasa Base',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(20) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`TasaBaseID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena el Valor de Promedio de las Tasas'$$