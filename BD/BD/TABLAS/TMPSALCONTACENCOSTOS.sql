-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPSALCONTACENCOSTOS
DELIMITER ;
DROP TABLE IF EXISTS `TMPSALCONTACENCOSTOS`;

DELIMITER $$
CREATE TABLE `TMPSALCONTACENCOSTOS` (
	`NumeroTransaccion`		BIGINT(20)		NOT NULL COMMENT 'Numero de Transacción de la Operación',
	`CuentaContable`		VARCHAR(50)		NOT NULL COMMENT 'Cuenta Contable Completa',
	`CentroCosto`			INT(11)			NOT NULL COMMENT 'Centro de Costos',
	`SaldoInicialDeu`		DECIMAL(18,4)	DEFAULT NULL COMMENT 'Saldo Inicial Deudor',
	`SaldoInicialAcr`		DECIMAL(18,4)	DEFAULT NULL COMMENT 'Saldo Inicial Acreedor',
	PRIMARY KEY (`NumeroTransaccion`,`CuentaContable`,`CentroCosto`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Temporal para Reporte de Balanza Contable'$$