-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCONCILIAMOVS
DELIMITER ;
DROP TABLE IF EXISTS `TMPCONCILIAMOVS`;DELIMITER $$

CREATE TABLE `TMPCONCILIAMOVS` (
  `FolioMovimiento` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  `FechaMov` date DEFAULT NULL COMMENT 'Fecha del Movimiento',
  `DescripcionMov` varchar(150) DEFAULT NULL COMMENT 'Decripcion del Movimiento',
  `ReferenciaMov` varchar(150) DEFAULT NULL COMMENT 'Referencia del Movimiento',
  `TipoMov` char(4) DEFAULT NULL COMMENT 'Id de Los Tipos de Movimientos de la Cuenta',
  `MontoMov` decimal(12,2) DEFAULT NULL COMMENT 'Monto del Movimiento',
  `NatMovimiento` char(1) DEFAULT NULL COMMENT 'Naturaleza del Movimiento \n C=Cargo, \nA=Abono',
  `Conciliado` char(1) DEFAULT NULL COMMENT 'Naturaleza conciliado',
  `FolioCargaID` int(11) DEFAULT NULL,
  `NumeroMov` int(11) DEFAULT NULL,
  `FechaOperacion` date DEFAULT NULL COMMENT 'Fecha del Movimiento',
  `DescripcionMovExt` varchar(150) DEFAULT NULL COMMENT 'Decripcion del Movimiento',
  `ReferenciaMovExt` varchar(150) DEFAULT NULL COMMENT 'Referencia del Movimiento',
  `TipoMovExt` char(4) DEFAULT NULL COMMENT 'Id de Los Tipos de Movimientos de la Cuenta',
  `MontoMovExt` decimal(12,2) DEFAULT NULL COMMENT 'Monto del Movimiento',
  `NatuMovimientoExt` char(1) DEFAULT NULL COMMENT 'Naturaleza del Movimiento \n C=Cargo, \nA=Abono'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla de paso para conciliacion de movimientos'$$