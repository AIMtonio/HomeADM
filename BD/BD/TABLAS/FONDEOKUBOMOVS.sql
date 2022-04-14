-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FONDEOKUBOMOVS
DELIMITER ;
DROP TABLE IF EXISTS `FONDEOKUBOMOVS`;DELIMITER $$

CREATE TABLE `FONDEOKUBOMOVS` (
  `FondeoKuboID` bigint(11) DEFAULT NULL COMMENT 'ID del Fondeo\nKubo',
  `AmortizacionID` int(4) DEFAULT NULL COMMENT 'ID de la\nAmortizacion',
  `Transaccion` bigint(20) DEFAULT NULL COMMENT 'Numero de Tranasaccion',
  `FechaOperacion` date DEFAULT NULL COMMENT 'Fecha Real de la Operacion',
  `FechaAplicacion` date DEFAULT NULL COMMENT 'Fecha de Aplicacion',
  `TipoMovKuboID` int(4) DEFAULT NULL COMMENT 'Tipo de Movimiento \ndel Fondeo Kubo',
  `NatMovimiento` char(1) DEFAULT NULL COMMENT 'Naturaleza del Movimiento\nC .- Cargo\nA .- Abono',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Moneda del Movimiento',
  `Cantidad` decimal(14,4) DEFAULT NULL COMMENT 'Monto o \nCantidad \n del Movimiento',
  `Descripcion` varchar(100) DEFAULT NULL COMMENT 'Descripcion\noProceso',
  `Referencia` varchar(50) DEFAULT NULL COMMENT 'Referencia del Movimiento',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(20) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` int(15) DEFAULT NULL,
  KEY `IDXFechaAplicacion` (`FechaAplicacion`) USING BTREE,
  KEY `FondFechaAplica` (`FondeoKuboID`,`FechaOperacion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Detalle de Movimientos de Fondeo KUBO'
/*!50100 PARTITION BY RANGE ( TO_DAYS(FechaAplicacion))
(PARTITION p0 VALUES LESS THAN (734868) ENGINE = InnoDB,
 PARTITION p1 VALUES LESS THAN (734959) ENGINE = InnoDB,
 PARTITION p2 VALUES LESS THAN (735050) ENGINE = InnoDB,
 PARTITION p3 VALUES LESS THAN (735142) ENGINE = InnoDB,
 PARTITION p4 VALUES LESS THAN MAXVALUE ENGINE = InnoDB) */$$