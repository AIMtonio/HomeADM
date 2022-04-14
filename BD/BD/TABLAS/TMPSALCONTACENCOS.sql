-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPSALCONTACENCOS
DELIMITER ;
DROP TABLE IF EXISTS `TMPSALCONTACENCOS`;DELIMITER $$

CREATE TABLE `TMPSALCONTACENCOS` (
  `NumeroTransaccion` bigint(20) NOT NULL COMMENT 'Numero de Transaccion',
  `CuentaContable` varchar(30) NOT NULL COMMENT 'Cuenta Contable',
  `CentroCosto` int(11) NOT NULL COMMENT 'Centro de Costos',
  `SaldoInicialDeu` decimal(16,4) DEFAULT NULL COMMENT 'Saldo Inicial Deudor',
  `SaldoInicialAcr` decimal(16,4) DEFAULT NULL COMMENT 'Saldo Inicial Acreedor',
  PRIMARY KEY (`NumeroTransaccion`,`CuentaContable`,`CentroCosto`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Temporal para Reporte de Balanza Contable'$$