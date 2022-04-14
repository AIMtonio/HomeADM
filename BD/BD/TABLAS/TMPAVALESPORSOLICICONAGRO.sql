-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPAVALESPORSOLICICONAGRO
DELIMITER ;
DROP TABLE IF EXISTS TMPAVALESPORSOLICICONAGRO;

DELIMITER $$
CREATE TABLE TMPAVALESPORSOLICICONAGRO (
	Transaccion				BIGINT(20)		NOT NULL COMMENT 'Número de la Transacción',
	ConsecutivoID 			INT(11)			NOT NULL COMMENT 'Número de Consecutivo',
	CreditoID 				BIGINT(12)		NOT NULL COMMENT 'Número de Crédito',
	SolicitudCreditoID 		BIGINT(20)		NOT NULL COMMENT 'Número de Solicitud de Crédito',
	AvalID					INT(11)			NOT NULL COMMENT 'Número de Aval',

	ClienteID				INT(11)			NOT NULL COMMENT 'Número de Cliente',
	ProspectoID				INT(11)			NOT NULL COMMENT 'Número de Prospecto',
	TipoRelacionID			INT(11)			NOT NULL COMMENT 'Identificador del tipo de relacion',
	TiempoDeConocido		DECIMAL(12,2)	NOT NULL COMMENT 'Tiempo de conocido del Aval en anios utilizando decimal',

	EmpresaID				INT(11)			NOT NULL COMMENT 'ID de la empresa',
	Usuario					INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID del usuario',
	FechaActual				DATETIME		NOT NULL COMMENT 'Parámetro de auditoría Fecha actual',
	DireccionIP				VARCHAR(15)		NOT NULL COMMENT 'Parámetro de auditoría Dirección IP',
	ProgramaID				VARCHAR(50)		NOT NULL COMMENT 'Parámetro de auditoría Programa',
	Sucursal				INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID de la Sucursal',
	NumTransaccion			BIGINT(20)		NOT NULL COMMENT 'Parámetro de auditoría Número de la Transacción',
	PRIMARY KEY (Transaccion,ConsecutivoID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmo: Tabla Temporal Física para la validación de Avales Consolidados por Solicitud de Crédito'$$