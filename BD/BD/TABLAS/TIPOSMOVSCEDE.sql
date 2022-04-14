-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSMOVSCEDE
DELIMITER ;
DROP TABLE IF EXISTS `TIPOSMOVSCEDE`;DELIMITER $$

CREATE TABLE `TIPOSMOVSCEDE` (
  `TipoMovCedeID` char(4) NOT NULL COMMENT 'ID del Tipo de \nMovimiento de CEDE\n',
  `Descripcion` varchar(45) NOT NULL COMMENT 'Descripcion del\nTipo de Movimiento\nDe cEDE',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`TipoMovCedeID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Tipos de Movimientos del Modulo de  CEDES'$$