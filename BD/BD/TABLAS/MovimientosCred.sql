-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MovimientosCred
DELIMITER ;
DROP TABLE IF EXISTS `MovimientosCred`;DELIMITER $$

CREATE TABLE `MovimientosCred` (
  `Folio` int(11) NOT NULL,
  `Fecha` datetime NOT NULL,
  `Credito` int(11) NOT NULL,
  `Amortizacion` int(11) NOT NULL,
  `TipoMovimiento` int(11) NOT NULL,
  `SignoContable` varchar(1) NOT NULL,
  `Monto` decimal(14,2) NOT NULL,
  `Referencia` varchar(50) NOT NULL,
  `Origen` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Movimientos de Credito'$$