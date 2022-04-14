-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWFONDEOMOVS
DELIMITER ;
DROP TABLE IF EXISTS `CRWFONDEOMOVS`;
DELIMITER $$

CREATE TABLE `CRWFONDEOMOVS` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `SolFondeoID` bigint(20) DEFAULT NULL COMMENT 'Numero o ID de Fondeo, consecutivo',
  `AmortizacionID` int(4) DEFAULT NULL COMMENT 'ID de la Amortizacion',
  `Transaccion` bigint(20) DEFAULT NULL COMMENT 'Numero de Tranasaccion',
  `FechaOperacion` date DEFAULT NULL COMMENT 'Fecha Real de la Operacion',
  `FechaAplicacion` date DEFAULT NULL COMMENT 'Fecha de Aplicacion',
  `TipoMovCRWID` int(4) DEFAULT NULL COMMENT 'Tipo de Movimiento del Fondeo',
  `NatMovimiento` char(1) DEFAULT NULL COMMENT 'Naturaleza del Movimiento\nC .- Cargo\nA .- Abono',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Moneda del Movimiento',
  `Cantidad` decimal(14,4) DEFAULT NULL COMMENT 'Monto o \nCantidad \n del Movimiento',
  `Descripcion` varchar(100) DEFAULT NULL COMMENT 'Descripcion\noProceso',
  `Referencia` varchar(50) DEFAULT NULL COMMENT 'Referencia del Movimiento',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `FechaActual` datetime NOT NULL COMMENT 'Campo de Auditoría.',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  KEY `INDEX_CRWFONDEOMOVS_1` (`SolFondeoID`,`FechaOperacion`),
  KEY `INDEX_CRWFONDEOMOVS_2` (`SolFondeoID`,`Descripcion`,`NatMovimiento`) USING BTREE,
  KEY `INDEX_CRWFONDEOMOVS_3` (`SolFondeoID`,`NatMovimiento`,`TipoMovCRWID`) USING BTREE,
  KEY `INDEX_CRWFONDEOMOVS_4` (`SolFondeoID`,`AmortizacionID`) USING BTREE,
  KEY `INDEX_CRWFONDEOMOVS_5` (`FechaOperacion`,`NatMovimiento`,`Descripcion`) USING BTREE,
  KEY `INDEX_CRWFONDEOMOVS_6` (`Referencia`) USING BTREE,
  KEY `INDEX_CRWFONDEOMOVS_7` (`NumTransaccion`) USING BTREE,
  KEY `INDEX_CRWFONDEOMOVS_8` (`FechaAplicacion`) USING BTREE,
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Detalle de Movimientos de Fondeo Crowdfunding.'
PARTITION BY RANGE (TO_DAYS(FechaAplicacion))
(PARTITION part0 VALUES LESS THAN (737393) ENGINE = InnoDB,
 PARTITION part1 VALUES LESS THAN (737424) ENGINE = InnoDB,
 PARTITION part2 VALUES LESS THAN (737455) ENGINE = InnoDB,
 PARTITION part3 VALUES LESS THAN (737483) ENGINE = InnoDB,
 PARTITION part4 VALUES LESS THAN (737514) ENGINE = InnoDB,
 PARTITION part5 VALUES LESS THAN (737544) ENGINE = InnoDB,
 PARTITION part6 VALUES LESS THAN (737575) ENGINE = InnoDB,
 PARTITION part7 VALUES LESS THAN (737605) ENGINE = InnoDB,
 PARTITION part8 VALUES LESS THAN (737636) ENGINE = InnoDB,
 PARTITION part9 VALUES LESS THAN (737667) ENGINE = InnoDB,
 PARTITION part10 VALUES LESS THAN (737697) ENGINE = InnoDB,
 PARTITION part11 VALUES LESS THAN (737728) ENGINE = InnoDB,
 PARTITION part12 VALUES LESS THAN (737758) ENGINE = InnoDB,
 PARTITION part13 VALUES LESS THAN (737789) ENGINE = InnoDB,
 PARTITION maximovalor VALUES LESS THAN MAXVALUE ENGINE = InnoDB) $$
