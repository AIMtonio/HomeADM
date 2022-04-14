
-- TD_HISBLOQUEOS
DELIMITER ;
DROP TABLE IF EXISTS TD_HISBLOQUEOS;

DELIMITER $$
CREATE TABLE TD_HISBLOQUEOS (
	RegistroID			BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID de la tabla',
	BloqueoID			INT(11)			NOT NULL COMMENT 'ID del bloqueo',
	TarjetaDebID		CHAR(16)		NOT NULL COMMENT 'ID de la Tarjeta de Debito',
	NatMovimiento		CHAR(1)			NOT NULL COMMENT 'Naturaleza del Movimiento\nB.- Bloquear\nD.- Desbloquear',
	FechaMovimiento		DATETIME		NOT NULL COMMENT 'Fecha de movimiento',
	MontoBloqueo		DECIMAL(12,2)	NOT NULL COMMENT 'Monto Bloqueado',
	FechaDesbloqueo		DATETIME		NOT NULL COMMENT 'Fecha para desbloquear',
	TiposBloqID			INT(11)			NOT NULL COMMENT 'Tipo de bloqueo u Origen del Bloqueo',
	Descripcion			VARCHAR(150)	NOT NULL COMMENT 'Descripcion del Bloqueo',
	Referencia			CHAR(12)		NOT NULL COMMENT 'Referencia del origen del bloqueo',
	FolioBloqueo		INT(11)			NOT NULL COMMENT 'Nace con valor cero, cuando se hace un desbloqueo su numero corresponde con el folio de desbloqueo/bloqueo',
	TerminalID			CHAR(16)		NOT NULL COMMENT 'ID de la terminal - TPV o ATM(limitado a 16 caracteres. ISO8583 - DE37 (PROSA))',
	NombreTerminal		CHAR(50)		NOT NULL COMMENT 'Nombre del comercio donde se realizo la operacion(limitado a 50 caracteres.  ISO8583 - DE43.1 (PROSA))',
	LocacionTerminal	CHAR(50)		NOT NULL COMMENT 'Datos de la localidad de la terminal(limitado a 50 caracteres.  ISO8583 - DE43.2 (PROSA))',
	NumAutorizacionAct	CHAR(6)			NOT NULL COMMENT 'Numero de referencia de autorizacion(limitado a 6 caracteres.)',
	NumAutorizacionAnt	CHAR(6)			NOT NULL COMMENT 'Numero de referencia de autorizacion(limitado a 6 caracteres.)',
	EmpresaID			INT(11)			NOT NULL COMMENT 'ID de la empresa',
	Usuario				INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID del usuario',
	FechaActual			DATETIME		NOT NULL COMMENT 'Parámetro de auditoría Fecha actual',
	DireccionIP			VARCHAR(15)		NOT NULL COMMENT 'Parámetro de auditoría Dirección IP',
	ProgramaID			VARCHAR(50)		NOT NULL COMMENT 'Parámetro de auditoría Programa',
	Sucursal			INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID de la Sucursal',
	NumTransaccion		BIGINT(20)		NOT NULL COMMENT 'Parámetro de auditoría Número de la Transacción',
	PRIMARY KEY (RegistroID),
	KEY INDEX_TD_HISBLOQUEOS_1 (BloqueoID),
	KEY INDEX_TD_HISBLOQUEOS_2 (TarjetaDebID),
	KEY INDEX_TD_HISBLOQUEOS_3 (TiposBloqID),
	KEY INDEX_TD_HISBLOQUEOS_4 (NatMovimiento),
	KEY INDEX_TD_HISBLOQUEOS_5 (FolioBloqueo),
	KEY INDEX_TD_HISBLOQUEOS_6 (NumAutorizacionAct),
	KEY INDEX_TD_HISBLOQUEOS_7 (Referencia)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TAB: Historico de Control de Bloqueos y Desbloqueos de Tarjetas de Débito'$$