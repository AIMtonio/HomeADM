-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPBALPOLCENCOSDIA
DELIMITER ;
DROP TABLE IF EXISTS `TMPBALPOLCENCOSDIA`;

DELIMITER $$
CREATE TABLE `TMPBALPOLCENCOSDIA` (
	`NumTransaccion`	BIGINT(20)		NOT NULL COMMENT 'Numero de Transacción de la Operación',
	`CuentaCompleta`	VARCHAR(50)		NOT NULL COMMENT 'Cuenta Contable Completa',
	`CentroCostoID`		INT(11)			NOT NULL COMMENT 'Centro de Costos',
	`Cargos`			DECIMAL(18,4)	NOT NULL COMMENT 'Cargos',
	`Abonos`			DECIMAL(18,4)	NOT NULL COMMENT 'Abonos',
	PRIMARY KEY (`NumTransaccion`,`CuentaCompleta`,`CentroCostoID`),
	KEY `INDEX_TMPBALPOLCENCOSDIA_1` (`NumTransaccion`,`CuentaCompleta`,`CentroCostoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Temporal del Detalle de Poliza Contable al Día'$$