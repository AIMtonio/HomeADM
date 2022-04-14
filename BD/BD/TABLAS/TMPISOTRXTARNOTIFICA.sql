-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPISOTRXTARNOTIFICA
DELIMITER ;
DROP TABLE IF EXISTS `TMPISOTRXTARNOTIFICA`;

DELIMITER $$
CREATE TABLE `TMPISOTRXTARNOTIFICA` (
	Consecutivo				INT(11)			NOT NULL COMMENT 'Numero Consecutivo',
	FechaOperacion			DATE			NOT NULL COMMENT 'Fecha en que se realizo la Operacion.',
	RegistroID				BIGINT(20)		NOT NULL COMMENT 'ID de Registro',
	PIDTarea				VARCHAR(50)		NOT NULL COMMENT 'Identificador del hilo de ejecucion de la tarea',

	EmpresaID				INT(11)			NOT NULL COMMENT 'ID de la empresa',
	Usuario					INT(11)			NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
	FechaActual				DATETIME		NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
	DireccionIP				VARCHAR(15)		NOT NULL COMMENT 'Parametro de auditoria Direccion IP',
	ProgramaID				VARCHAR(50)		NOT NULL COMMENT 'Parametro de auditoria Programa',
	Sucursal				INT(11)			NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
	NumTransaccion 			BIGINT(20)		NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
	PRIMARY KEY ( `Consecutivo` ,`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla Temporal Física para la reversa de operación de Notificación para la Tarea: TAREA_ISOTRX_NOTIFICASALDO.'$$