-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPBALANZACONTAFIRA
DELIMITER ;
DROP TABLE IF EXISTS `TMPBALANZACONTAFIRA`;DELIMITER $$

CREATE TABLE `TMPBALANZACONTAFIRA` (
  `NumeroTransaccion` bigint(20) NOT NULL COMMENT 'Numero de \nTransaccion',
  `CuentaContable` varchar(25) NOT NULL COMMENT 'Cuenta\nContable',
  `ConsecutivoID` int(11) NOT NULL COMMENT 'Consecutivo ID',
  `Grupo` char(1) DEFAULT NULL COMMENT 'Si es \nEncabezado\nDetalle',
  `SaldoInicialDeu` decimal(16,4) DEFAULT NULL COMMENT 'Saldo Inicial Deudor\\nDel Periodo',
  `SaldoInicialAcre` decimal(16,4) DEFAULT NULL COMMENT 'Saldo Inicial Acreedor\\nDel Periodo',
  `Cargos` decimal(16,4) DEFAULT NULL COMMENT 'Cargos',
  `Abonos` decimal(16,4) DEFAULT NULL COMMENT 'Abonos',
  `SaldoDeudor` decimal(16,4) DEFAULT NULL COMMENT 'Saldo \nDeudor',
  `SaldoAcreedor` decimal(16,4) DEFAULT NULL COMMENT 'Saldo\nAcreedor',
  `DescripcionCuenta` varchar(150) DEFAULT NULL COMMENT 'Descripcion\nde la \nCuenta',
  `CuentaMayor` varchar(25) DEFAULT NULL COMMENT 'Cuenta se Mayor',
  `CentroCosto` varchar(25) DEFAULT NULL COMMENT 'Centro de Costos',
  KEY `TMPBALANZACONTAFIRA_IDX_1` (`NumeroTransaccion`),
  KEY `TMPBALANZACONTAFIRA_IDX_2` (`ConsecutivoID`),
  KEY `TMPBALANZACONTAFIRA_IDX_3` (`CuentaContable`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla Temporal Para los Estados Financieros FIRA.'$$