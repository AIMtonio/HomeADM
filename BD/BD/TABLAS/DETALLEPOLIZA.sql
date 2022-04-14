-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEPOLIZA
DELIMITER ;
DROP TABLE IF EXISTS `DETALLEPOLIZA`;
DELIMITER $$


CREATE TABLE `DETALLEPOLIZA` (
  `DetallePolizaID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa ID',
  `PolizaID` bigint(20) NOT NULL COMMENT 'Numero de la \nPoliza',
  `Fecha` date NOT NULL COMMENT 'Fecha de la \nPoliza',
  `CentroCostoID` int(11) NOT NULL COMMENT 'Centro de \nCostos',
  `CuentaCompleta` varchar(50) NOT NULL COMMENT 'Cuenta Contable\nCompleta',
  `Instrumento` varchar(20) NOT NULL COMMENT 'Instrumento\nque origino el\nmovimiento',
  `MonedaID` int(11) NOT NULL COMMENT 'Moneda',
  `Cargos` decimal(14,4) DEFAULT NULL,
  `Abonos` decimal(14,4) DEFAULT NULL,
  `Descripcion` varchar(150) NOT NULL COMMENT 'Descripcion del\nMovimiento',
  `Referencia` varchar(250) NOT NULL COMMENT 'Referencia',
  `ProcedimientoCont` varchar(30) DEFAULT NULL COMMENT 'Procedimiento\nContable que\nArma la Cuenta\nContable',
  `TipoInstrumentoID` int(11) DEFAULT NULL COMMENT 'ID del tipo de Instrumento que genera el movimiento.',
  `RFC` char(13) DEFAULT NULL COMMENT 'Registro Federal de Contribuyentes del Cliente',
  `TotalFactura` decimal(14,2) DEFAULT NULL COMMENT 'Monto Total Neto a Pagar de la Factura',
  `FolioUUID` varchar(100) DEFAULT NULL COMMENT 'Folio Fiscal o UUID del CFDI',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`DetallePolizaID`,`Fecha`),
  KEY `fk_MonedaPoliza` (`MonedaID`),
  KEY `fk_CentroCostoPoliza` (`CentroCostoID`),
  KEY `fk_CuentaContablePoliza` (`CuentaCompleta`),
  KEY `fk_PolizaPoliza` (`PolizaID`),
  KEY `IDXFechaAplicacion` (`Fecha`) USING BTREE,
  KEY `idx_Instrumento` (`Instrumento`),
  KEY `IDX_REPPOLIZACENCOS` (`CuentaCompleta`,`Fecha`,`CentroCostoID`),
  KEY `IDX_DETALLEPOLIZA_DetallePolizaID` (`DetallePolizaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Poliza Contable del Dia'
PARTITION BY RANGE ( YEAR(Fecha))
    SUBPARTITION BY HASH ( MONTH (Fecha))
    SUBPARTITIONS 12
    (PARTITION DETALLEPOLIZA_anio2018 VALUES LESS THAN (2019) ENGINE = InnoDB,
     PARTITION DETALLEPOLIZA_anio2019 VALUES LESS THAN (2020) ENGINE = InnoDB,
     PARTITION DETALLEPOLIZA_anio2020 VALUES LESS THAN (2021) ENGINE = InnoDB,
     PARTITION DETALLEPOLIZA_anio2021 VALUES LESS THAN (2022) ENGINE = InnoDB,
     PARTITION DETALLEPOLIZA_anio2022 VALUES LESS THAN (2023) ENGINE = InnoDB,
     PARTITION DETALLEPOLIZA_anio2023 VALUES LESS THAN (2024) ENGINE = InnoDB,
     PARTITION DETALLEPOLIZA_anio2024 VALUES LESS THAN (2025) ENGINE = InnoDB,
     PARTITION DETALLEPOLIZA_anio2025 VALUES LESS THAN (2026) ENGINE = InnoDB,
     PARTITION DETALLEPOLIZA_anio2026 VALUES LESS THAN (2027) ENGINE = InnoDB,
     PARTITION DETALLEPOLIZA_anio2027 VALUES LESS THAN (2028) ENGINE = InnoDB,
     PARTITION DETALLEPOLIZA_anio2029 VALUES LESS THAN (2029) ENGINE = InnoDB,
     PARTITION DETALLEPOLIZA_anio2030 VALUES LESS THAN (2030) ENGINE = InnoDB,
     PARTITION DETALLEPOLIZA_anio2031 VALUES LESS THAN (2031) ENGINE = InnoDB,
     PARTITION DETALLEPOLIZA_anio2032 VALUES LESS THAN (2032) ENGINE = InnoDB,
     PARTITION DETALLEPOLIZA_anio2033 VALUES LESS THAN (2033) ENGINE = InnoDB,
     PARTITION DETALLEPOLIZA_anio2034 VALUES LESS THAN (2034) ENGINE = InnoDB,
     PARTITION DETALLEPOLIZA_anio2035 VALUES LESS THAN (2035) ENGINE = InnoDB,
     PARTITION DETALLEPOLIZA_pmax VALUES LESS THAN MAXVALUE ENGINE = InnoDB)$$