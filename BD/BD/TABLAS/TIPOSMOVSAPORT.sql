-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSMOVSAPORT
DELIMITER ;
DROP TABLE IF EXISTS `TIPOSMOVSAPORT`;DELIMITER $$

CREATE TABLE `TIPOSMOVSAPORT` (
  `TipoMovAportID` char(4) NOT NULL COMMENT 'ID del Tipo de \nMovimiento de Aportación.',
  `Descripcion` varchar(45) NOT NULL COMMENT 'Descripcion del\nTipo de Movimiento de Aportación.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`TipoMovAportID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cat: Tipos de Movimientos del Modulo de Aportaciones.'$$