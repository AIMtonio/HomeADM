-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCONTABLEBALANCE
DELIMITER ;
DROP TABLE IF EXISTS `TMPCONTABLEBALANCE`;
DELIMITER $$

CREATE TABLE `TMPCONTABLEBALANCE` (
	`NumeroTransaccion`		bigint(20)		NOT NULL COMMENT 'Número de Transacción',
	`Fecha`					date			NOT NULL COMMENT 'Fecha',
	`CuentaContable`		char(25)		NOT NULL COMMENT 'Cuenta Contable',
	`CentroCosto`			int(11)			NOT NULL COMMENT 'Centro de Costos de la Cuenta Contable',
	`Cargos`				decimal(18,4)	DEFAULT NULL COMMENT 'Cargos de la Cuenta Contable',
	`Abonos`				decimal(18,4)	DEFAULT NULL COMMENT 'Abonos de la Cuenta Contable',
	`Naturaleza`			char(1)			DEFAULT NULL COMMENT 'Naturaleza de la Cuenta Contable \nA.-  Acreedora \nD.- Deudora',
	`SaldoDeudor`			decimal(18,4)	DEFAULT NULL COMMENT 'Saldo Deudor de la Cuenta Contable.',
	`SaldoAcreedor`			decimal(18,4)	DEFAULT NULL COMMENT 'Saldo Acreedor de la Cuenta Contable.',
	`SaldoInicialDeu`		decimal(18,4)	DEFAULT NULL COMMENT 'Saldo Inicial Deudor',
	`SaldoInicialAcr`		decimal(18,4)	DEFAULT NULL COMMENT 'Saldo Inicial Acreedor',
	PRIMARY KEY (`NumeroTransaccion`,`Fecha`,`CuentaContable`,`CentroCosto`),
	KEY `INDEX_TMPCONTABLEBALANCE_1` (`NumeroTransaccion`,`CuentaContable`),
	KEY `INDEX_TMPCONTABLEBALANCE_2` (`NumeroTransaccion`,`CuentaContable`,`CentroCosto`),
	KEY `INDEX_TMPCONTABLEBALANCE_3` (`CuentaContable`,`NumeroTransaccion`),
	KEY `INDEX_TMPCONTABLEBALANCE_4` (`NumeroTransaccion`),
	KEY `INDEX_TMPCONTABLEBALANCE_5` (`CuentaContable`,`Fecha`,`NumeroTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla Temporal para Procesos de Contabilidad'$$