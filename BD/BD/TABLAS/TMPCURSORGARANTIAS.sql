-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCURSORGARANTIAS
DELIMITER ;
DROP TABLE IF EXISTS `TMPCURSORGARANTIAS`;

DELIMITER $$
CREATE TABLE `TMPCURSORGARANTIAS` (
  `Fecha` date DEFAULT NULL COMMENT 'Fecha de operación.',
  `CreditoID` bigint(12) DEFAULT NULL COMMENT 'Id del crédito.',
  `SolFondeoID` bigint(20) DEFAULT NULL COMMENT 'Id de la solicitud de fondeo.',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Id del Cliente.',
  `CuentaAhoID` bigint(12) DEFAULT NULL COMMENT 'Id de la cuenta de ahorro.',
  `AmortizacionID` int(11) DEFAULT NULL COMMENT 'Id de la Amortizacion.',
  `ProvisionAcum` decimal(14,4) DEFAULT NULL COMMENT 'Provisión acumulada.',
  `RetencionIntAcum` decimal(14,4) DEFAULT NULL COMMENT 'Retención de interés acumulada.',
  `NumRetirosMes` int(11) DEFAULT NULL COMMENT 'Plazo en meses.',
  `SucursalOrigen` int(11) DEFAULT NULL COMMENT 'Sucursal origen del Cliente.',
  `PagaISR` char(1) DEFAULT NULL COMMENT 'Indica si paga o no ISR.',
  `SaldoInteres` decimal(14,4) DEFAULT NULL COMMENT 'Saldo interés.',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Id de la Moneda.',
  `SaldoCapVigente` decimal(14,4) DEFAULT NULL COMMENT 'Capital vigente.',
  `SaldoCapExigible` decimal(14,4) DEFAULT NULL COMMENT 'Capital exigible.',
  `FechaVencimiento` date DEFAULT NULL COMMENT 'Fecha de vencimeinto.',
  `SalCapCred` decimal(14,4) DEFAULT NULL COMMENT 'Saldo capital credito.',
  `SalIntCred` decimal(14,4) DEFAULT NULL COMMENT 'Saldo Interes credito.',
  `SalAcumCapInv` decimal(14,4) DEFAULT NULL COMMENT 'Saldo acumulado Capital inversion.',
  `SalAcumIntInv` decimal(14,4) DEFAULT NULL COMMENT 'Saldo acumulado interés inversion.',
  `NumCuotasInv` int(11) DEFAULT NULL COMMENT 'Número de cuotas de la inversión.',
  `NumTransaccion` int(11) DEFAULT NULL COMMENT 'Número de transacción.',
  KEY `INDEX_TMPCURSORGARANTIAS_1` (`SolFondeoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Temporal para el pago de fondeo CRW.'$$