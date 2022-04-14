-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARCREDGIROS
DELIMITER ;
DROP TABLE IF EXISTS `TARCREDGIROS`;DELIMITER $$

CREATE TABLE `TARCREDGIROS` (
  `TarjetaCredID` char(16) NOT NULL COMMENT 'ID de la Tarjeta de Credito',
  `GiroID` char(4) NOT NULL DEFAULT '' COMMENT 'Codigo MerchanType Segun ISO8583 Aceptado para este tipo de Tarjeta Credito.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria',
  PRIMARY KEY (`TarjetaCredID`,`GiroID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TAB: Tabla de Giros Aceptados por Una Tarjeta de Credito En Particular'$$