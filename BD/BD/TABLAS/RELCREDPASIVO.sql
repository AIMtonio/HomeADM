-- Creacion de tabla RELCREDPASIVO

DELIMITER ;

DROP TABLE IF EXISTS RELCREDPASIVO;

DELIMITER $$

CREATE TABLE RELCREDPASIVO(
	RelCreditoPasivoID	BIGINT(12)	NOT NULL COMMENT 'Consecutivo o ID de la Tabla.',
	CreditoID			BIGINT(12)	NOT NULL COMMENT 'ID del credito de activo (Une con tabla CREDITOS)',
	CreditoFondeoID		BIGINT(20)	NOT NULL COMMENT 'ID de Credito de Pasivo (Une con tabla CREDITOFONDEO)',
	EstatusRelacion		CHAR(1)		NOT NULL COMMENT 'Estatus de la relacion entre el credito Activo y pasivo (A= Activa, V= Vencida) nace como activo',
	EmpresaID			INT(11)		NOT NULL COMMENT 'Parametro de Auditoria',
	Usuario				INT(11)		NOT NULL COMMENT 'Parametro de Auditoria',
	FechaActual			DATE		NOT NULL COMMENT 'Parametro de Auditoria',
	DireccionIP			VARCHAR(15)	NOT NULL COMMENT 'Parametro de Auditoria',
	ProgramaID			VARCHAR(50)	NOT NULL COMMENT 'Parametro de Auditoria',
	Sucursal			INT(11)		NOT NULL COMMENT 'Parametro de Auditoria',
	NumTransaccion		BIGINT(20)	NOT NULL COMMENT 'Parametro de Auditoria',
	PRIMARY KEY (RelCreditoPasivoID)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tbl: Tabla para Guardar Informacion del Credito Fondeado con su cuneta de credito Pasivo.'$$
