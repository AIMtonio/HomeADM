-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORAERRORNOTICAPLD
DELIMITER ;
DROP TABLE IF EXISTS BITACORAERRORNOTICAPLD;

DELIMITER $$
CREATE TABLE BITACORAERRORNOTICAPLD (
	RegistroID			BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID de tabla',
	OpeInusualID		BIGINT(20)			NOT NULL COMMENT 'ID de la tabla PLDOPEINUSUALES',
	NumeroError			INT(11)				NOT NULL COMMENT 'Codigo error',
	MensajeError		VARCHAR(2000)		NOT NULL COMMENT 'Mensaje del error',

	EmpresaID			INT(11)				NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
	Usuario				INT(11)				NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
	FechaActual			DATETIME			NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
	DireccionIP			VARCHAR(15)			NOT NULL COMMENT 'Parametro de auditoria Direccion IP',
	ProgramaID			VARCHAR(50)			NOT NULL COMMENT 'Parametro de auditoria Programa',
	Sucursal			INT(11)				NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
	NumTransaccion		BIGINT(20)			NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
	PRIMARY KEY (RegistroID),
	KEY IDX_BITACORAERRORNOTICAPLD_1 (OpeInusualID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Bitacora de registros de los errores en la notificación de operaciones inusuales.'$$