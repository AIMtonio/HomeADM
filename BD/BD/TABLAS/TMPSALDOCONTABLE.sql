-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPSALDOCONTABLE
DELIMITER ;
DROP TABLE IF EXISTS `TMPSALDOCONTABLE`;
DELIMITER $$

CREATE TABLE `TMPSALDOCONTABLE` (
  `NumeroTransaccion` bigint(20) NOT NULL COMMENT 'Numero de Transaccion',
  `CuentaContable` varchar(30) NOT NULL COMMENT 'Cuenta Contable',
  `SaldoInicialDeu` decimal(18,4) DEFAULT NULL COMMENT 'Saldo Inicial Deudor',
  `SaldoInicialAcr` decimal(18,4) DEFAULT NULL COMMENT 'Saldo Inicial Acreedor',
  PRIMARY KEY (`NumeroTransaccion`,`CuentaContable`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Temporal para Reporte de Balanza Contable'$$