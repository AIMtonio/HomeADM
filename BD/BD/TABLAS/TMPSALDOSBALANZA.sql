-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPSALDOSBALANZA
DELIMITER ;
DROP TABLE IF EXISTS `TMPSALDOSBALANZA`;

DELIMITER $$
CREATE TABLE `TMPSALDOSBALANZA` (
	`CuentaCompleta`	VARCHAR(50)		DEFAULT NULL COMMENT 'Cuenta contable completa',
	`SaldoIniDeudor`	DECIMAL(18,2)	DEFAULT NULL COMMENT 'Saldo Inicial Deudor de la Cuenta',
	`SaldoIniAcredor`	DECIMAL(18,2)	DEFAULT NULL COMMENT 'Saldo Inicial Acreedor de la Cuenta',
	`Cargos`			DECIMAL(18,2)	DEFAULT NULL COMMENT 'Cargos realizados a la cuenta',
	`Abonos`			DECIMAL(18,2)	DEFAULT NULL COMMENT 'Abonos realizados a la cuenta',
	`SaldoDeudor`		DECIMAL(18,2)	DEFAULT NULL COMMENT 'Saldo deudor a la fecha',
	`SaldoAcreedor`		DECIMAL(18,2)	DEFAULT NULL COMMENT 'Saldo acreedor a la fecha',
	`NumTransaccion`	BIGINT(20)		DEFAULT NULL COMMENT 'Número de transacción',
	`EmpresaID`			INT(11)			DEFAULT NULL,
	`Usuario`			INT(11)			DEFAULT NULL,
	`FechaActual`		DATETIME		DEFAULT NULL,
	`DireccionIP`		VARCHAR(15)		DEFAULT NULL,
	`ProgramaID`		VARCHAR(50)		DEFAULT NULL,
	`Sucursal`			INT(11)			DEFAULT NULL,
	KEY `INDEX_TMPSALDOSBALANZA_1` (`CuentaCompleta`),
	KEY `INDEX_TMPSALDOSBALANZA_2` (`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$