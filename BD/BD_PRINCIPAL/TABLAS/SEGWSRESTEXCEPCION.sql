DELIMITER ;

DROP TABLE IF EXISTS SEGWSRESTEXCEPCION;

DELIMITER $$

CREATE TABLE SEGWSRESTEXCEPCION (
	SegWSRestExcepcionID			INT(11)				NOT NULL		COMMENT 'Identificador de la tabla',
	WSRestID						INT(11)				NOT NULL		COMMENT 'Id del Servicio REST, une con tabla SEGWSREST',
    TipoExcepcion 					CHAR(1)				NOT NULL		COMMENT 'Tipo de Excepcion (P = Excepcion por PathVariable)',

	EmpresaID						INT(11)				NOT NULL 		COMMENT 'Empresa ID',
	Usuario							INT(11)				NOT NULL		COMMENT 'Usuario ID',
	FechaActual						DATETIME			NOT NULL		COMMENT 'Fecha Actual',
	DireccionIP						VARCHAR(15)			NOT NULL		COMMENT 'Direccion IP',
	ProgramaID						VARCHAR(50)			NOT NULL		COMMENT 'Programa de Auditoria',
	Sucursal						INT(11)				NOT NULL		COMMENT 'Sucursal ID',
	NumTransaccion					BIGINT(20)			NOT NULL		COMMENT 'Numero de Transaccion',

	PRIMARY KEY(SegWSRestExcepcionID),
	CONSTRAINT FK_SEGWSRESTEXCEPCION_1 FOREIGN KEY (WSRestID) REFERENCES SEGWSREST(WSRestID)
)ENGINE = InnoDB DEFAULT CHARSET=latin1 COMMENT = 'Tab: Tabla para almacenar las Excepciones por Servicio REST.'$$
