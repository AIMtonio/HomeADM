-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPREGCATMIN
DELIMITER ;
DROP TABLE IF EXISTS `TMPREGCATMIN`;
DELIMITER $$

CREATE TABLE `TMPREGCATMIN` (
	`NumeroTransaccion` BIGINT(20)	  NOT NULL COMMENT 'Numero \n    Transaccion',
	`ConceptoFinanID` 	INT(11)		  NOT NULL COMMENT 'Consecutivo ',
	`Fecha` 			DATE		  NOT NULL COMMENT 'Fecha',
	`CuentaContable` 	VARCHAR(500)  NOT NULL COMMENT 'Cuenta Contable',
	`CentroCosto` 		INT(11)		  NOT NULL,
	`Cargos` 			DECIMAL(18,4) DEFAULT NULL COMMENT 'Cargos',
	`Abonos` 			DECIMAL(18,4) DEFAULT NULL COMMENT 'Abonos',
	`Naturaleza` 		CHAR(1)		  DEFAULT NULL COMMENT 'Naturaleza de la Cuenta\nA .-  Acreedora\nD .-  Deudora',
	`SaldoDeudor` 		DECIMAL(18,2) DEFAULT NULL COMMENT 'Saldo Deudor de la Cuenta Contable.',
	`SaldoAcreedor` 	DECIMAL(18,2) DEFAULT NULL COMMENT 'Saldo Acreedor de la Cuenta Contable.',
	`SaldoInicialDeu` 	DECIMAL(18,2) DEFAULT NULL COMMENT 'Saldo Inicial Deudor',
	`SaldoInicialAcr` 	DECIMAL(18,2) DEFAULT NULL COMMENT 'Saldo Inicial Acreedor',
	`LongitoCtaConta`	INT(11)		  DEFAULT NULL COMMENT 'minimo Longitud de la cuenta contable',
	PRIMARY KEY (`NumeroTransaccion`,`ConceptoFinanID`,`Fecha`),
	KEY `index3` (`CuentaContable`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla Temporal para Regulatorio de Catalogo Minimo'$$