-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPTESCONMOVS
DELIMITER ;
DROP TABLE IF EXISTS `TMPTESCONMOVS`;DELIMITER $$

CREATE TABLE `TMPTESCONMOVS` (
  `FolioCargaID` int(11) NOT NULL,
  `NumeroMov` int(11) NOT NULL,
  `FechaOperacion` date DEFAULT NULL COMMENT 'Fecha del Movimiento',
  `DescripcionMovExt` varchar(150) DEFAULT NULL COMMENT 'Decripcion del Movimiento',
  `ReferenciaMovExt` varchar(150) DEFAULT NULL COMMENT 'Referencia del Movimiento',
  `TipoMovExt` char(4) DEFAULT NULL COMMENT 'Id de Los Tipos de Movimientos de la Cuenta',
  `MontoMovExt` decimal(12,2) DEFAULT NULL COMMENT 'Monto del Movimiento',
  `NatuMovimientoExt` char(1) DEFAULT NULL COMMENT 'Naturaleza del Movimiento \n C=Cargo, \nA=Abono',
  `EstConcilia` char(1) DEFAULT NULL COMMENT 'Indica si ya se tomo en cuenta para mostrarse en pantalla '
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla de paso para conciliacion de movimientos'$$