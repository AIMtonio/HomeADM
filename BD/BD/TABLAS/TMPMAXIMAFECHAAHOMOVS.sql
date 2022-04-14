DELIMITER ;
DROP TABLE IF EXISTS TMPMAXIMAFECHAAHOMOVS;

DELIMITER $$
CREATE TABLE TMPMAXIMAFECHAAHOMOVS (
	CuentaAhoID				BIGINT(12)			NOT NULL COMMENT 'Identificador del numero de cuentas de ahorro',
	FechaMaxima				DATE				NOT NULL COMMENT 'Fecha del movimiento de la cuenta',
	NumTransaccion 			BIGINT(20)			NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
	PRIMARY KEY(CuentaAhoID),
	INDEX `INDEX_1` (FechaMaxima),
	INDEX `INDEX_2` (NumTransaccion)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Almacena la fecha maximo de las de cuentas que son candidatos a bloquear.'$$