-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPDEPOARRENDA
DELIMITER ;
DROP TABLE IF EXISTS `TMPDEPOARRENDA`;DELIMITER $$

CREATE TABLE `TMPDEPOARRENDA` (
  `DepRefereID` bigint(17) NOT NULL COMMENT 'ID de Carga de deposito referenciado',
  `FolioCargaID` bigint(17) NOT NULL COMMENT 'Folio unico de Carga de Archivo es un consecutivo',
  `MontoMov` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Monto del Movimiento',
  `ReferenciaMov` varchar(40) NOT NULL COMMENT 'Referencia del Movimiento Debe ser el CREDITO o CUENTA',
  `Estatus` char(2) NOT NULL DEFAULT 'N' COMMENT 'Estatus de aplicacion A = Aplicar N = no aplicar',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(20) NOT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de Auditoria'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de paso para validar deposito'$$