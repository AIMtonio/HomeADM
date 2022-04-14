-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCRWSALDOSINV
DELIMITER ;
DROP TABLE IF EXISTS `TMPCRWSALDOSINV`;

DELIMITER $$
CREATE TABLE `TMPCRWSALDOSINV` (
  `SolFondeoID` bigint(20) NOT NULL COMMENT 'numero de SolFondeoID',
  `FechaCorte` datetime DEFAULT NULL COMMENT 'Fecha',
  `ClienteID` int(12) DEFAULT NULL COMMENT 'Numero o ID\nDel Cliente\n',
  `CreditoID` bigint(12) DEFAULT NULL COMMENT 'Numero o ID\nDel Credito\nFondedo\n',
  `SalCapVigente` decimal(12,2) DEFAULT NULL COMMENT 'Saldo Capital Vigente.',
  `SalCapExigible` decimal(12,2) DEFAULT NULL COMMENT 'Saldo Capital exigible.',
  `SalCapCtaOrden` decimal(14,4) DEFAULT NULL COMMENT 'Capital que se encuentra en las cuentas de orden(capital que se uso para aplicar la garantia del credito)',
  `SaldoInteres` decimal(12,4) DEFAULT NULL COMMENT 'Saldo Interés.',
  `SalIntCtaOrden` decimal(14,4) DEFAULT NULL COMMENT 'interes que se encuentra en cuentas de Orden(interes que se uso para aplicar la garantia al credito)',
  `ProvisionAcum` decimal(12,4) DEFAULT NULL COMMENT 'Provisión Acumulada.',
  `MoratorioPagado` decimal(12,2) DEFAULT NULL COMMENT 'Moratorio Pagado.',
  `ComFalPagPagada` decimal(12,4) DEFAULT NULL COMMENT 'Comision falta de pago pagado.',
  `IntOrdRetenido` decimal(12,4) DEFAULT NULL COMMENT 'Interés ordinario.',
  `IntMorRetenido` decimal(12,4) DEFAULT NULL COMMENT 'Interés retenido.',
  `ComFalPagRetenido` decimal(12,4) DEFAULT NULL COMMENT 'Comision falta de pago retenido.',
  `GAT` decimal(12,4) DEFAULT NULL COMMENT 'Ganancia anual\ntotal\n',
  `NumAtras1A15` int(11) DEFAULT NULL COMMENT 'numero inv atrasado de \n1 a 15 dias',
  `SalAtras1A15` decimal(12,4) DEFAULT NULL COMMENT 'saldo inv atrasado de \n1 a 15 dias',
  `NumAtras16a30` int(11) DEFAULT NULL COMMENT 'numero inv atrasado de \n16 a 30 dias',
  `SaldoAtras16a30` decimal(12,4) DEFAULT NULL COMMENT 'saldo inv atrasado de \n16 a 30 dias',
  `NumAtras31a90` int(11) DEFAULT NULL COMMENT 'num inv atrasado de \n31 a 90 dias',
  `SalAtras31a90` decimal(12,4) DEFAULT NULL COMMENT 'saldo inv atrasado de \n31 a 90 dias',
  `NumVenc91a120` int(11) DEFAULT NULL COMMENT 'num inv vencido \nde 91 a 120 dias',
  `SalVenc91a120` decimal(12,4) DEFAULT NULL COMMENT 'saldo inv vencido de 91 a 120 dias',
  `NumVenc120a180` int(11) DEFAULT NULL COMMENT 'numero inv vencido  de 120 a 180 dias',
  `SalVenc120a180` decimal(12,4) DEFAULT NULL COMMENT 'saldo inv vencido  de 120 a 180 dias vencido  de 120 a 180 dias',
  `SalIntMoratorio` decimal(14,4) DEFAULT NULL COMMENT 'Saldo de Interes Moratorio ',
  KEY `INDEX_TMPCRWSALDOSINV_1` (`SolFondeoID`),
  KEY `INDEX_TMPCRWSALDOSINV_2` (`FechaCorte`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: SALDOS INVERSION '$$
