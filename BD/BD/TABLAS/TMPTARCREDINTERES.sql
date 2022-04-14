-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPTARCREDINTERES
DELIMITER ;
DROP TABLE IF EXISTS `TMPTARCREDINTERES`;DELIMITER $$

CREATE TABLE `TMPTARCREDINTERES` (
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Numero de Transaccion',
  `Consecutivo` int(11) NOT NULL COMMENT 'Consecutivo incremental de linea',
  `LineaTarCredID` int(11) DEFAULT NULL COMMENT 'Identificador de Linea de Credito',
  `FechaCorte` date DEFAULT NULL COMMENT 'Fecha de Corte de la Linea',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(20) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  PRIMARY KEY (`NumTransaccion`,`Consecutivo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: Guarda el registro de las lineas de credito que generan interes'$$