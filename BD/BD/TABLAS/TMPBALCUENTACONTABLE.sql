-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPBALCUENTACONTABLE
DELIMITER ;
DROP TABLE IF EXISTS `TMPBALCUENTACONTABLE`;

DELIMITER $$
CREATE TABLE `TMPBALCUENTACONTABLE` (
	`NumTransaccion`	BIGINT(20)		NOT NULL COMMENT 'Numero de Transacción de la Operación',
	`CuentaCompleta`	VARCHAR(50)		NOT NULL COMMENT 'Cuenta Contable Completa',
	`CentroCosto`		INT(11)			NOT NULL COMMENT 'Centro de Costos',
	`CuentaMayor`		VARCHAR(30)		NOT NULL COMMENT 'Cuenta de Mayor',
	`Descripcion`		VARCHAR(250)	NOT NULL COMMENT 'Descripción de la Cuenta',
	`Naturaleza`		CHAR(1)			NOT NULL COMMENT 'Naturaleza de la Cuenta \nA.- Acreedora \nD.- Deudora',
	`Grupo`				CHAR(1)			NOT NULL COMMENT 'Nivel de Desglose \nE.-Encabezado \nD.-Detalle',
	`MonedaID`			INT(11)			DEFAULT NULL COMMENT 'Moneda ID',
	PRIMARY KEY (`NumTransaccion`,`CuentaCompleta`,`CentroCosto`),
	KEY `INDEX_TMPBALCUENTACONTABLE_1` (`CuentaMayor`,`NumTransaccion`,`CentroCosto`),
	KEY `INDEX_TMPBALCUENTACONTABLE_2` (`CuentaCompleta`),
	KEY `INDEX_TMPBALCUENTACONTABLE_3` (`CuentaMayor`),
	KEY `INDEX_TMPBALCUENTACONTABLE_4` (`NumTransaccion`,`Grupo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Temporal Maestro o Catalogo de Cuentas Contables'$$