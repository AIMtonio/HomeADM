-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPBALANZACONTABLE
DELIMITER ;
DROP TABLE IF EXISTS `TMPBALANZACONTABLE`;

DELIMITER $$
CREATE TABLE `TMPBALANZACONTABLE` (
	`NumeroTransaccion`		BIGINT(20)		NOT NULL COMMENT 'Numero de Transaccion',
	`CuentaContable`		VARCHAR(25)		NOT NULL COMMENT 'Cuenta Contable',
	`Grupo`					CHAR(1)			DEFAULT NULL COMMENT 'nivel de Detalle. \nE.- Encabezado \nD.-Detalle',
	`SaldoInicialDeu`		DECIMAL(18,4)	DEFAULT NULL COMMENT 'Saldo Inicial Deudor del Periodo',
	`SaldoInicialAcre`		DECIMAL(18,4)	DEFAULT NULL COMMENT 'Saldo Inicial Acreedor del Periodo',
	`Cargos`				DECIMAL(18,4)	DEFAULT NULL COMMENT 'Cargos',
	`Abonos`				DECIMAL(18,4)	DEFAULT NULL COMMENT 'Abonos',
	`SaldoDeudor`			DECIMAL(18,4)	DEFAULT NULL COMMENT 'Saldo Deudor',
	`SaldoAcreedor`			DECIMAL(18,4)	DEFAULT NULL COMMENT 'Saldo Acreedor',
	`DescripcionCuenta`		VARCHAR(250)	DEFAULT NULL COMMENT 'Descripcion de la Cuenta Contable',
	`CuentaMayor`			VARCHAR(25)		DEFAULT NULL COMMENT 'Cuenta de Mayor',
	`CentroCosto`			VARCHAR(25)		NOT NULL COMMENT 'Centro de Costos',
	PRIMARY KEY (`NumeroTransaccion`,`CuentaContable`,`CentroCosto`),
	KEY `INDEX_TMPBALANZACONTABLE_1` (`CuentaContable`),
	KEY `INDEX_TMPBALANZACONTABLE_2` (`CuentaMayor`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla Temporal Para el Reporte de Balanza Contable'$$
