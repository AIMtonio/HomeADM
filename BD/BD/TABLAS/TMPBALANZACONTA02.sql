-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPBALANZACONTA02
DELIMITER ;
DROP TABLE IF EXISTS `TMPBALANZACONTA02`;DELIMITER $$

CREATE TABLE `TMPBALANZACONTA02` (
  `NumeroTransaccion` bigint(20) NOT NULL COMMENT 'Numero de \nTransaccion',
  `CuentaContable` varchar(25) NOT NULL COMMENT 'Cuenta\nContable',
  `Grupo` char(1) DEFAULT NULL COMMENT 'Si es \nEncabezado\nDetalle',
  `SaldoInicialDeu` decimal(14,2) DEFAULT NULL COMMENT 'Saldo Inicial Deudor\\nDel Periodo',
  `SaldoInicialAcre` decimal(14,2) DEFAULT NULL COMMENT 'Saldo Inicial Acreedor\\nDel Periodo',
  `Cargos` decimal(14,2) DEFAULT NULL COMMENT 'Cargos',
  `Abonos` decimal(14,2) DEFAULT NULL COMMENT 'Abonos',
  `SaldoDeudor` decimal(14,2) DEFAULT NULL COMMENT 'Saldo \nDeudor',
  `SaldoAcreedor` decimal(14,2) DEFAULT NULL COMMENT 'Saldo\nAcreedor',
  `DescripcionCuenta` varchar(150) DEFAULT NULL COMMENT 'Descripcion\nde la \nCuenta',
  `CuentaMayor` varchar(25) DEFAULT NULL COMMENT 'Cuenta se Mayor',
  `SumaSalIni` decimal(14,2) DEFAULT NULL,
  `SumaSalIniAcre` decimal(14,2) DEFAULT NULL,
  `SumaCargos` decimal(14,2) DEFAULT NULL,
  `SumaAbonos` decimal(14,2) DEFAULT NULL,
  `SumaSalDeu` decimal(14,2) DEFAULT NULL,
  `SumaSalAcr` decimal(14,2) DEFAULT NULL,
  KEY `NumeroTrans` (`NumeroTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla Temporal Para el Reporte de Balanza Contable'$$