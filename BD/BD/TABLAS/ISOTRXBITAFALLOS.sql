-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ISOTRXBITAFALLOS
DELIMITER ;
DROP TABLE IF EXISTS `ISOTRXBITAFALLOS`;

DELIMITER $$
CREATE TABLE `ISOTRXBITAFALLOS` (
	BitacoraID				BIGINT(20)		NOT NULL COMMENT 'ID de Tabla',
	RegistroID				BIGINT(20)		NOT NULL COMMENT 'ID de Tabla ISOTRXTARNOTIFICA',
	FechaOperacion			DATE			NOT NULL COMMENT 'Fecha en que se realizo la Operacion.',
	PIDTarea				VARCHAR(50)		NOT NULL COMMENT 'Identificador del hilo de ejecucion de la tarea',
	NumeroError				INT(11)			NOT NULL COMMENT 'Número de Error de Web Service',

	MensajeError			VARCHAR(500)	NOT NULL COMMENT 'Mensaje de Error del Web Service',
	Transaccion 			BIGINT(20)		NOT NULL COMMENT 'Numero de la transaccion',

	EmpresaID				INT(11)			NOT NULL COMMENT 'ID de la empresa',
	Usuario					INT(11)			NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
	FechaActual				DATETIME		NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
	DireccionIP				VARCHAR(15)		NOT NULL COMMENT 'Parametro de auditoria Direccion IP',
	ProgramaID				VARCHAR(50)		NOT NULL COMMENT 'Parametro de auditoria Programa',
	Sucursal				INT(11)			NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
	NumTransaccion 			BIGINT(20)		NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
	PRIMARY KEY (`BitacoraID`),
	KEY `IDX_ISOTRXBITAFALLOS_1` (`RegistroID`),
	KEY `IDX_ISOTRXBITAFALLOS_2` (`FechaOperacion`),
	KEY `IDX_ISOTRXBITAFALLOS_3` (`PIDTarea`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tb: Tabla de Bitácora de fallos en las Notificaciones de la Tarea: TAREA_ISOTRX_NOTIFICASALDO.'$$
