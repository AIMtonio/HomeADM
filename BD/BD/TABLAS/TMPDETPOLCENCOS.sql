-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPDETPOLCENCOS
DELIMITER ;
DROP TABLE IF EXISTS `TMPDETPOLCENCOS`;
DELIMITER $$


CREATE TABLE `TMPDETPOLCENCOS` (
	`RegistroID`		BIGINT UNSIGNED AUTO_INCREMENT,
	`CentroCostoID` 	INT(11) 		NOT NULL COMMENT 'Centro de \nCostos',
	`CuentaCompleta`	VARCHAR(50)		NOT NULL COMMENT 'Cuenta Contable\nCompleta',
	`Cargos`			DECIMAL(18,4)	DEFAULT NULL COMMENT 'Cargos',
	`Abonos`			DECIMAL(18,4)	DEFAULT NULL COMMENT 'Abonos',
	`NumTransaccion`	BIGINT(20)		DEFAULT NULL COMMENT 'Número de Transacción',
	PRIMARY KEY (RegistroID),
	KEY `IDX_TMPDETPOLCENCOS` (`NumTransaccion`,`CuentaCompleta`,`CentroCostoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Temporal del Detalle de Poliza Contable'$$
