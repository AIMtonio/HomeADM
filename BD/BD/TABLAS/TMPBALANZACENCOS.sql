-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPBALANZACENCOS
DELIMITER ;
DROP TABLE IF EXISTS `TMPBALANZACENCOS`;

DELIMITER $$
CREATE TABLE `TMPBALANZACENCOS` (
	`RegistroID`			BIGINT UNSIGNED AUTO_INCREMENT,
	`NumeroTransaccion`		BIGINT(20)		NOT NULL COMMENT 'Número de Transacción de la Operación',
	`CuentaContable`		VARCHAR(25)		NOT NULL COMMENT 'Cuenta Contable',
	`CentroCosto`			INT(11)			NOT NULL COMMENT 'Centro de Costos',
	`Grupo`					CHAR(1)			DEFAULT NULL COMMENT 'Tipo de Grupo: \nE.- Encabezado \nD.- Detalle',
	`SaldoInicialDeu`		DECIMAL(18,4)	DEFAULT NULL COMMENT 'Saldo Inicial Deudor Del Periodo',
	`SaldoInicialAcre`		DECIMAL(18,4)	DEFAULT NULL COMMENT 'Saldo Inicial Acreedor Del Periodo',
	`Cargos`				DECIMAL(18,4)	DEFAULT NULL COMMENT 'Cargos',
	`Abonos`				DECIMAL(18,4)	DEFAULT NULL COMMENT 'Abonos',
	`SaldoDeudor`			DECIMAL(18,4)	DEFAULT NULL COMMENT 'Saldo Deudor',
	`SaldoAcreedor`			DECIMAL(18,4)	DEFAULT NULL COMMENT 'Saldo Acreedor',
	`DescripcionCuenta`		VARCHAR(250)	DEFAULT NULL COMMENT 'Descripción de la Cuenta contable',
	`CuentaMayor`			VARCHAR(25)		DEFAULT NULL COMMENT 'Cuenta de Mayor',
	PRIMARY KEY (RegistroID),
	KEY `INDEX_TMPBALANZACENCOS_1` (`NumeroTransaccion`),
	KEY `INDEX_TMPBALANZACENCOS_2` (`NumeroTransaccion`,`CuentaContable`,`CentroCosto`),
	KEY `INDEX_TMPBALANZACENCOS_3` (`Grupo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla Temporal Para el Reporte de Balanza Contable x Centro de Costos'$$
