-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSMOVS
DELIMITER ;
DROP TABLE IF EXISTS `CREDITOSMOVS`;
DELIMITER $$


CREATE TABLE `CREDITOSMOVS` (
  `CreditosMovsID` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID de tabla',
  `CreditoID` bigint(12) DEFAULT NULL COMMENT 'ID del Credito',
  `AmortiCreID` int(4) DEFAULT NULL COMMENT 'ID de la Amortizacion',
  `Transaccion` bigint(20) DEFAULT NULL COMMENT 'Numero de Tranasaccion',
  `FechaOperacion` date DEFAULT NULL COMMENT 'Fecha Real de la Operacion',
  `FechaAplicacion` date NOT NULL COMMENT 'Fecha de Aplicacion',
  `TipoMovCreID` int(4) DEFAULT NULL COMMENT 'Tipo de Movimiento de Credito',
  `NatMovimiento` char(1) DEFAULT NULL COMMENT 'Naturaleza del Movimiento\nC .- Cargo\nA .- Abono',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Moneda del Movimiento',
  `Cantidad` decimal(14,4) DEFAULT NULL COMMENT 'Movimiento',
  `Descripcion` varchar(100) DEFAULT NULL COMMENT 'Movimiento',
  `Referencia` varchar(50) DEFAULT NULL COMMENT 'Referencia del Movimiento',
  `PolizaID` bigint(20) DEFAULT NULL COMMENT 'Numero de Poliza Generado para el movimiento',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` int(15) DEFAULT NULL,
  PRIMARY KEY (CreditosMovsID, FechaAplicacion),
  KEY `IDXFechaAplicacion` (`FechaAplicacion`) USING BTREE,
  KEY `CredFechaAplica` (`CreditoID`,`FechaOperacion`),
  KEY `CREDITOSMOVS_1` (`FechaOperacion`,`TipoMovCreID`,`NatMovimiento`),
  KEY `IDX_CREDITOSMOVS_1` (`CreditoID`),
  KEY IDX_CREDITOSMOVS_02 (CreditosMovsID)
  ) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Detalle de Movimientos o Transaciones de Creditos'
PARTITION BY RANGE ( YEAR(FechaAplicacion))
SUBPARTITION BY HASH ( MONTH (FechaAplicacion))
SUBPARTITIONS 12
(PARTITION CREDITOSMOVS_anio2018 VALUES LESS THAN (2019) ENGINE = InnoDB,
 PARTITION CREDITOSMOVS_anio2019 VALUES LESS THAN (2020) ENGINE = InnoDB,
 PARTITION CREDITOSMOVS_anio2020 VALUES LESS THAN (2021) ENGINE = InnoDB,
 PARTITION CREDITOSMOVS_anio2021 VALUES LESS THAN (2022) ENGINE = InnoDB,
 PARTITION CREDITOSMOVS_anio2022 VALUES LESS THAN (2023) ENGINE = InnoDB,
 PARTITION CREDITOSMOVS_anio2023 VALUES LESS THAN (2024) ENGINE = InnoDB,
 PARTITION CREDITOSMOVS_anio2024 VALUES LESS THAN (2025) ENGINE = InnoDB,
 PARTITION CREDITOSMOVS_anio2025 VALUES LESS THAN (2026) ENGINE = InnoDB,
 PARTITION CREDITOSMOVS_anio2026 VALUES LESS THAN (2027) ENGINE = InnoDB,
 PARTITION CREDITOSMOVS_anio2027 VALUES LESS THAN (2028) ENGINE = InnoDB,
 PARTITION CREDITOSMOVS_anio2029 VALUES LESS THAN (2029) ENGINE = InnoDB,
 PARTITION CREDITOSMOVS_anio2030 VALUES LESS THAN (2030) ENGINE = InnoDB,
 PARTITION CREDITOSMOVS_anio2031 VALUES LESS THAN (2031) ENGINE = InnoDB,
 PARTITION CREDITOSMOVS_anio2032 VALUES LESS THAN (2032) ENGINE = InnoDB,
 PARTITION CREDITOSMOVS_anio2033 VALUES LESS THAN (2033) ENGINE = InnoDB,
 PARTITION CREDITOSMOVS_anio2034 VALUES LESS THAN (2034) ENGINE = InnoDB,
 PARTITION CREDITOSMOVS_anio2035 VALUES LESS THAN (2035) ENGINE = InnoDB,
 PARTITION CREDITOSMOVS_pmax VALUES LESS THAN MAXVALUE ENGINE = InnoDB)$$