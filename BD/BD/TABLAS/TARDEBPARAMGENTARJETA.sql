-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBPARAMGENTARJETA
DELIMITER ;
DROP TABLE IF EXISTS `TARDEBPARAMGENTARJETA`;
DELIMITER $$

CREATE TABLE TARDEBPARAMGENTARJETA (
	Bin					CHAR(8)			NOT NULL COMMENT 'BIN para la generacion de tarjetas.',
	ColeccionTarjetas	VARCHAR(40)		NOT NULL COMMENT 'Nombre de la Coleccion donde se guardan el lote de tarjetas por BIN.',

	EmpresaID           INT(11)			NOT NULL COMMENT 'Parametro de Auditoria.',
	Usuario             INT(11)			NOT NULL COMMENT 'Parametro de Auditoria.',
	FechaActual         DATETIME		NOT NULL COMMENT 'Parametro de Auditoria.',
	DireccionIP         VARCHAR(15)		NOT NULL COMMENT 'Parametro de Auditoria.',
	ProgramaID          VARCHAR(50)		NOT NULL COMMENT 'Parametro de Auditoria.',
	Sucursal            INT(11)			NOT NULL COMMENT 'Parametro de Auditoria.',
	NumTransaccion      BIGINT(20)		NOT NULL COMMENT 'Parametro de Auditoria.',

	PRIMARY KEY (Bin)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla de configuracion para el guardado dinamico de los numeros de tarjetas por BIN.'$$