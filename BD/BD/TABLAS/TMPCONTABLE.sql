-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCONTABLE
DELIMITER ;
DROP TABLE IF EXISTS `TMPCONTABLE`;

DELIMITER $$
CREATE TABLE `TMPCONTABLE` (
	`NumeroTransaccion`		BIGINT(20)		NOT NULL COMMENT 'Número de Transacción',
	`Fecha`					DATE			NOT NULL COMMENT 'Fecha',
	`CuentaContable`		CHAR(25)		NOT NULL COMMENT 'Cuenta Contable',
	`CentroCosto`			INT(11)			NOT NULL COMMENT 'Centro de Costos de la Cuenta Contable',
	`Cargos`				DECIMAL(18,4)	DEFAULT NULL COMMENT 'Cargos de la Cuenta Contable',
	`Abonos`				DECIMAL(18,4)	DEFAULT NULL COMMENT 'Abonos de la Cuenta Contable',
	`Naturaleza`			CHAR(1)			DEFAULT NULL COMMENT 'Naturaleza de la Cuenta Contable \nA.-  Acreedora \nD.- Deudora',
	`SaldoDeudor`			DECIMAL(18,4)	DEFAULT NULL COMMENT 'Saldo Deudor de la Cuenta Contable.',
	`SaldoAcreedor`			DECIMAL(18,4)	DEFAULT NULL COMMENT 'Saldo Acreedor de la Cuenta Contable.',
	`SaldoInicialDeu`		DECIMAL(18,4)	DEFAULT NULL COMMENT 'Saldo Inicial Deudor',
	`SaldoInicialAcr`		DECIMAL(18,4)	DEFAULT NULL COMMENT 'Saldo Inicial Acreedor',
	PRIMARY KEY (`NumeroTransaccion`,`Fecha`,`CuentaContable`,`CentroCosto`),
	KEY `INDEX_TMPCONTABLE_1` (`NumeroTransaccion`,`CuentaContable`),
	KEY `INDEX_TMPCONTABLE_2` (`NumeroTransaccion`,`CuentaContable`,`CentroCosto`),
	KEY `INDEX_TMPCONTABLE_3` (`CuentaContable`,`NumeroTransaccion`),
	KEY `INDEX_TMPCONTABLE_4` (`NumeroTransaccion`),
	KEY `INDEX_TMPCONTABLE_5` (`CuentaContable`,`Fecha`,`NumeroTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla Temporal para Procesos de Contabilidad'$$