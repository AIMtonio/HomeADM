-- Creacion de tabla CARCAMBIOFONDEOBIT

DELIMITER ;

DROP TABLE IF EXISTS CARCAMBIOFONDEOBIT;

DELIMITER $$

CREATE TABLE CARCAMBIOFONDEOBIT(
	CarCambioFondeoID		BIGINT(20)	NOT NULL COMMENT 'ID de la tabla',
	FechaCambio				DATE		NOT NULL COMMENT 'Fecha en la que se realizo el cambio de Fondeo',
	CreditoID				BIGINT(12)	NOT NULL COMMENT 'ID del Credito a cambiar de fondeador (Une con tabla de CREDITOS)',
	InstitutFondAntID		INT(11)		NOT NULL COMMENT 'ID de la Institucion de Fondeo antes del cambio de Fondeo (une con tabla INSTITUTFONDEO)',
	LineaFondeoAntID		INT(11)		NOT NULL COMMENT 'ID de la linea de Fondea de Pasivo antes del cambio de Fondeo',
	CreditoFondeoAntID		BIGINT(20)	NOT NULL COMMENT 'ID del Credito de Pasivo antes del cambio de Fondeo',
	InstitutFondActID		INT(11)		NOT NULL COMMENT 'ID de la Institucion de Fondeo Actual del Fondeo.',
	LineaFondeoActID		INT(11)		NOT NULL COMMENT 'ID de la linea de Fondea de Pasivo Actual del Fondeo.',
	CreditoFondeoActID		BIGINT(20)	NOT NULL COMMENT 'ID del Credito de Pasivo Actual del Fondeo.',
	EmpresaID				INT(11)		NOT NULL COMMENT 'Parametro de Auditoria',
	Usuario					INT(11)		NOT NULL COMMENT 'Parametro de Auditoria',
	FechaActual				DATE		NOT NULL COMMENT 'Parametro de Auditoria',
	DireccionIP				VARCHAR(15)	NOT NULL COMMENT 'Parametro de Auditoria',
	ProgramaID				VARCHAR(50)	NOT NULL COMMENT 'Parametro de Auditoria',
	Sucursal				INT(11)		NOT NULL COMMENT 'Parametro de Auditoria',
	NumTransaccion			BIGINT(20)	NOT NULL COMMENT 'Parametro de Auditoria',
	PRIMARY KEY (CarCambioFondeoID),
	KEY `fk_CARCAMBIOFONDEOBIT_1` (CreditoID),
	KEY `fk_CARCAMBIOFONDEOBIT_2` (InstitutFondActID),
	CONSTRAINT `fk_CARCAMBIOFONDEOBIT_1` FOREIGN KEY (CreditoID) REFERENCES CREDITOS (CreditoID) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT `fk_CARCAMBIOFONDEOBIT_2` FOREIGN KEY (InstitutFondActID) REFERENCES INSTITUTFONDEO (InstitutFondID) ON DELETE NO ACTION ON UPDATE NO ACTION
)ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tbl: Tabla para Guardar Informacion del tipo de Cambio de Fondeo del Credito'$$
