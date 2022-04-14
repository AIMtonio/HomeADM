-- TMPTD_BLOQUEOS
DELIMITER ;
DROP TABLE IF EXISTS TMPTD_BLOQUEOS;

DELIMITER $$
CREATE TABLE TMPTD_BLOQUEOS (
	RegistroID			INT(11)			NOT NULL COMMENT 'ID de Tabla',
	TransaccionID		BIGINT(20)		NOT NULL COMMENT 'ID de Transaccion',
	BloqueoID			INT(11)			NOT NULL COMMENT 'ID del bloqueo',
	MontoBloqueo		DECIMAL(12,2)	NOT NULL COMMENT 'Monto Bloqueado',
	Descripcion			VARCHAR(150)	NOT NULL COMMENT 'Descripcion del Bloqueo',
	EmpresaID			INT(11)			NOT NULL COMMENT 'ID de la empresa',
	Usuario				INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID del usuario',
	FechaActual			DATETIME		NOT NULL COMMENT 'Parámetro de auditoría Fecha actual',
	DireccionIP			VARCHAR(15)		NOT NULL COMMENT 'Parámetro de auditoría Dirección IP',
	ProgramaID			VARCHAR(50)		NOT NULL COMMENT 'Parámetro de auditoría Programa',
	Sucursal			INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID de la Sucursal',
	NumTransaccion		BIGINT(20)		NOT NULL COMMENT 'Parámetro de auditoría Número de la Transacción',
	PRIMARY KEY (RegistroID, TransaccionID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp:Temporal para el Control de Bloqueos y Desbloqueos de Tarjetas de Débito'$$