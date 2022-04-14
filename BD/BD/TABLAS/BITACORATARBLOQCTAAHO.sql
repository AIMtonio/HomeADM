DELIMITER ;
DROP TABLE IF EXISTS BITACORATARBLOQCTAAHO;

DELIMITER $$
CREATE TABLE BITACORATARBLOQCTAAHO (
	CuentaAhoID				BIGINT(12)			NOT NULL COMMENT 'Identificador del numero de cuentas de ahorro',
	ClienteID				INT(11)				NOT NULL COMMENT 'Numero del cliente',
	TipoCuentaID			INT(11) 			NOT NULL COMMENT 'Numero de Tipo de Cuenta',
	Saldo 					DECIMAL(12,2) 		NOT NULL COMMENT 'Saldo Real',
	SaldoDisponible			DECIMAL(12,2)		NOT NULL COMMENT 'Saldo disponible antes del bloqueo de la cuenta',
	SaldoBloqueo			DECIMAL(12,2) 		NOT NULL COMMENT 'Saldo Bloqueado',
	SaldoSBC 				DECIMAL(12,2) 		NOT NULL COMMENT 'Saldo Buen Cobro',
	UsuarioBloqueoID		INT(11)				NOT NULL COMMENT 'Identificador del usuario que realiza el bloqueo',
	FechaBloqueo			DATE				NOT NULL COMMENT 'Fecha en la que se realiza el bloqueo',
	PIDTarea				VARCHAR(50)			NOT NULL COMMENT 'PID de la tarea que se le asigno a la hora de ser ejecutada',
	EmpresaID				INT(11)				NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
	Usuario					INT(11)				NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
	FechaActual				DATETIME			NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
	DireccionIP				VARCHAR(15)			NOT NULL COMMENT 'Parametro de auditoria Direccion IP',
	ProgramaID				VARCHAR(50)			NOT NULL COMMENT 'Parametro de auditoria Programa',
	Sucursal				INT(11)				NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
	NumTransaccion			BIGINT(20)			NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
	PRIMARY KEY(CuentaAhoID,NumTransaccion),
	INDEX `INDEX_1` (ClienteID),
	INDEX `INDEX_2` (TipoCuentaID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla de bitacora para almacenar todas las cuentas que se han bloqueada en el proceso de bloqueo de cuentas automaticas.'$$