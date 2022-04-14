DELIMITER ;
DROP TABLE IF EXISTS TMPBLOQUEOCUENTASAHO;

DELIMITER $$
CREATE TABLE TMPBLOQUEOCUENTASAHO (
	BloqueoCuentasAhoID		INT(11)				NOT NULL COMMENT 'Identificador consecutivo de la tabla',
	CuentaAhoID				BIGINT(12)			NOT NULL COMMENT 'Identificador del numero de cuentas de ahorro',
	Fecha					DATE				NOT NULL COMMENT 'Fecha del movimiento de la cuenta',
	PIDTarea				VARCHAR(50)			NOT NULL COMMENT 'PID de la tarea que se le asigno a la hora de ser ejecutada',
	UsuarioBloID			INT(11)				NOT NULL COMMENT 'Identificador del usuario que realiza el bloqueo',
	FechaBloqueo			DATE				NOT NULL COMMENT 'Fecha en la que se realiza el bloqueo',
	FechaActual				DATETIME 			NOT NULL COMMENT 'Campo de auditoria de fecha actual',
	ProgramaID				VARCHAR(50)			NOT NULL COMMENT 'Nombre del programa', 
	NumTransaccion 			BIGINT(20)			NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
	PRIMARY KEY(BloqueoCuentasAhoID),
	INDEX `INDEX_1` (Fecha),
	INDEX `INDEX_2` (CuentaAhoID),
	INDEX `INDEX_3` (NumTransaccion)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Almacena los numeros de cuentas que son candidatos a bloquear.'$$