-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSCONTMOVS
DELIMITER ;
DROP TABLE IF EXISTS `CREDITOSCONTMOVS`;
DELIMITER $$


CREATE TABLE `CREDITOSCONTMOVS` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `CreditoID` bigint(12) DEFAULT NULL COMMENT 'ID del Credito',
  `AmortiCreID` int(4) DEFAULT NULL COMMENT 'ID de la Amortizacion',
  `Transaccion` bigint(20) DEFAULT NULL COMMENT 'Numero de Tranasaccion',
  `FechaOperacion` date DEFAULT NULL COMMENT 'Fecha Real de la Operacion',
  `FechaAplicacion` date DEFAULT NULL COMMENT 'Fecha de Aplicacion',
  `TipoMovCreID` int(4) DEFAULT NULL COMMENT 'Tipo de Movimiento de Credito',
  `NatMovimiento` char(1) DEFAULT NULL COMMENT 'Naturaleza del Movimiento\nC .- Cargo\nA .- Abono',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Moneda del Movimiento',
  `Cantidad` decimal(14,4) DEFAULT NULL COMMENT 'Movimiento',
  `Descripcion` varchar(100) DEFAULT NULL COMMENT 'Movimiento',
  `Referencia` varchar(50) DEFAULT NULL COMMENT 'Referencia del Movimiento',
  `PolizaID` bigint(20) DEFAULT NULL COMMENT 'Numero de Poliza generado para el movimiento',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` int(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  KEY `IDXFechaAplicacion` (`FechaAplicacion`) USING BTREE,
  KEY `CredFechaAplica` (`CreditoID`,`FechaOperacion`),
  KEY `CREDITOSMOVS_1` (`FechaOperacion`,`TipoMovCreID`,`NatMovimiento`),
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Detalle de Movimientos o Transaciones de Creditos Contingentes'
/*!50100 PARTITION BY RANGE ( TO_DAYS(FechaAplicacion))
(PARTITION p0 VALUES LESS THAN (734868) ENGINE = InnoDB,
 PARTITION p1 VALUES LESS THAN (734959) ENGINE = InnoDB,
 PARTITION p2 VALUES LESS THAN (735050) ENGINE = InnoDB,
 PARTITION p3 VALUES LESS THAN (735142) ENGINE = InnoDB,
 PARTITION p4 VALUES LESS THAN MAXVALUE ENGINE = InnoDB) */$$
