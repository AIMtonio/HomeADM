-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWSALDOSINV
DELIMITER ;
DROP TABLE IF EXISTS `CRWSALDOSINV`;
DELIMITER $$

CREATE TABLE `CRWSALDOSINV` (
  `SolFondeoID`              BIGINT(20)              NOT NULL COMMENT 'numero de fondeoID',
  `FechaCorte`               DATETIME             NOT NULL COMMENT 'Fecha',
  `ClienteID`                INT(12)              NOT NULL COMMENT 'Numero o ID\nDel Cliente\n',
  `CreditoID`                BIGINT(12)              NOT NULL COMMENT 'Numero o ID\nDel Credito\nFondedo\n',
  `SalCapVigente`            DECIMAL(12,2)        NOT NULL,
  `SalCapExigible`           DECIMAL(12,2)        NOT NULL,
  `SalCapCtaOrden`           DECIMAL(14,4)        NOT NULL COMMENT 'Capital que se encuentra en las cuentas de orden(capital que se uso para aplicar la garantia del credito)',
  `SaldoInteres`             DECIMAL(12,4)        NOT NULL,
  `SalIntCtaOrden`           DECIMAL(14,4)        NOT NULL COMMENT 'interes que se encuentra en cuentas de Orden(interes que se uso para aplicar la garantia al credito)',
  `ProvisionAcum`            DECIMAL(12,4)        NOT NULL,
  `MoratorioPagado`          DECIMAL(12,2)        NOT NULL,
  `ComFalPagPagada`          DECIMAL(12,4)        NOT NULL,
  `IntOrdRetenido`           DECIMAL(12,4)        NOT NULL,
  `IntMorRetenido`           DECIMAL(12,4)        NOT NULL,
  `ComFalPagRetenido`        DECIMAL(12,4)        NOT NULL,
  `GAT`                      DECIMAL(12,4)        NOT NULL COMMENT 'Ganancia anual\ntotal\n',
  `NumAtras1A15`             INT(11)              NOT NULL COMMENT 'numero inv atrasado de \n1 a 15 dias',
  `SalAtras1A15`             DECIMAL(12,4)        NOT NULL COMMENT 'saldo inv atrasado de \n1 a 15 dias',
  `NumAtras16a30`            INT(11)              NOT NULL COMMENT 'numero inv atrasado de \n16 a 30 dias',
  `SaldoAtras16a30`          DECIMAL(12,4)        NOT NULL COMMENT 'saldo inv atrasado de \n16 a 30 dias',
  `NumAtras31a90`            INT(11)              NOT NULL COMMENT 'num inv atrasado de \n31 a 90 dias',
  `SalAtras31a90`            DECIMAL(12,4)        NOT NULL COMMENT 'saldo inv atrasado de \n31 a 90 dias',
  `NumVenc91a120`            INT(11)              NOT NULL COMMENT 'num inv vencido \nde 91 a 120 dias',
  `SalVenc91a120`            DECIMAL(12,4)        NOT NULL COMMENT 'saldo inv vencido de 91 a 120 dias',
  `NumVenc120a180`           INT(11)              NOT NULL COMMENT 'numero inv vencido  de 120 a 180 dias',
  `SalVenc120a180`           DECIMAL(12,4)        NOT NULL COMMENT 'saldo inv vencido  de 120 a 180 dias vencido  de 120 a 180 dias',
  `SalIntMoratorio`          DECIMAL(14,4)        NOT NULL COMMENT 'Saldo de Interes Moratorio ',
  KEY `index2` (`FechaCorte`),
  KEY `fk_SALDOSINV_2` (`CreditoID`),
  KEY `INDEX_DETALLEINV` (`ClienteID`,`FechaCorte`),
  KEY `idx_KuboFondeoFechaCor` (`SolFondeoID`,`FechaCorte`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='SALDOS INVERSION'$$
