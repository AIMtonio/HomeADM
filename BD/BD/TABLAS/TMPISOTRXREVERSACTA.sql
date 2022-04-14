DELIMITER ;
DROP TABLE IF EXISTS TMPISOTRXREVERSACTA;

DELIMITER $$
CREATE TABLE TMPISOTRXREVERSACTA(
	RegistroID				BIGINT(20)			NOT NULL COMMENT 'Consecutivo general de la tabla',
	CuentaAhoID				BIGINT(12)			NOT NULL COMMENT 'Identificador del numero de cuentas de ahorro',
	Saldo					DECIMAL(12,2)		NOT NULL COMMENT 'Saldo de la cuenta',
	BloqueoID				INT(11) 			NOT NULL COMMENT 'ID del bloqueo',
	EmpresaID				INT(11)				NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
	Usuario					INT(11)				NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
	FechaActual				DATETIME			NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
	DireccionIP				VARCHAR(15)			NOT NULL COMMENT 'Parametro de auditoria Direccion IP',
	ProgramaID				VARCHAR(50)			NOT NULL COMMENT 'Parametro de auditoria Programa',
	Sucursal				INT(11)				NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
	NumTransaccion			BIGINT(20)			NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
	PRIMARY KEY(RegistroID),
	INDEX INDEX_1(CuentaAhoID),
	INDEX INDEX_2(NumTransaccion)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla auxiliar para guardar las cuentas de ahorro a realizar el bloqueo o desbloqueo de saldos.'$$