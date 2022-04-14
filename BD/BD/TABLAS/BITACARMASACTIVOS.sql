-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACARMASACTIVOS
DELIMITER ;
DROP TABLE IF EXISTS BITACARMASACTIVOS;

DELIMITER $$
CREATE TABLE BITACARMASACTIVOS (
	FechaRegistro			DATE			NOT NULL COMMENT 'Fecha de Registro',
	Consecutivo				INT(11)			NOT NULL COMMENT 'Numero Consecutivo',
	RegistroID				INT(11)			NOT NULL COMMENT 'ID Consecutivo del Cliente ',
	TransaccionID			BIGINT(20)		NOT NULL COMMENT 'Número de Transacción de la Operacion',
	NumeroError				INT(11)			NOT NULL COMMENT 'Numero de Errores',

	MensajeError			VARCHAR(500)	NOT NULL COMMENT 'Descripción del Error',

	EmpresaID				INT(11)			NOT NULL COMMENT 'Parámetro de auditoria ID de la Empresa',
	Usuario					INT(11)			NOT NULL COMMENT 'Parámetro de auditoria ID del Usuario',
	FechaActual				DATETIME		NOT NULL COMMENT 'Parámetro de auditoria Fecha actual',
	DireccionIP				VARCHAR(15)		NOT NULL COMMENT 'Parámetro de auditoria Direccion IP ',
	ProgramaID				VARCHAR(50)		NOT NULL COMMENT 'Parámetro de auditoria Programa ID',
	Sucursal				INT(11)			NOT NULL COMMENT 'Parámetro de auditoria ID de la Sucursal',
	NumTransaccion			BIGINT(20)		NOT NULL COMMENT 'Parámetro de auditoria Número de la transacción',
	PRIMARY KEY (FechaRegistro, Consecutivo),
	KEY IDX_BITACARMASACTIVOS_1 (RegistroID, TransaccionID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tb. Bitacora de Carga Masiva de Activos'$$