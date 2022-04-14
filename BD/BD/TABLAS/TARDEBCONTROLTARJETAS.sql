-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBCONTROLTARJETAS
DELIMITER ;
DROP TABLE IF EXISTS `TARDEBCONTROLTARJETAS`;
DELIMITER $$

CREATE TABLE TARDEBCONTROLTARJETAS (
	Bin					CHAR(8)			NOT NULL COMMENT 'BIN para la generacion de tarjetas.',
	SubBin 				CHAR(2)			NOT NULL COMMENT 'Nombre del SubBIN (Vacio cuando el BIN no maneja SUBBIN)',
	CantTarjetas		INT(11)			NOT NULL COMMENT 'Cantidad de CLABES de tarjetas sin asignacion.',

	EmpresaID           INT(11)			NOT NULL COMMENT 'Parametro de Auditoria.',
	Usuario             INT(11)			NOT NULL COMMENT 'Parametro de Auditoria.',
	FechaActual         DATETIME		NOT NULL COMMENT 'Parametro de Auditoria.',
	DireccionIP         VARCHAR(15)		NOT NULL COMMENT 'Parametro de Auditoria.',
	ProgramaID          VARCHAR(50)		NOT NULL COMMENT 'Parametro de Auditoria.',
	Sucursal            INT(11)			NOT NULL COMMENT 'Parametro de Auditoria.',
	NumTransaccion      BIGINT(20)		NOT NULL COMMENT 'Parametro de Auditoria.',

	PRIMARY KEY (Bin, SubBin),
	INDEX IDX_TARDEBCONTROLTARJETAS_01(Bin),
	INDEX IDX_TARDEBCONTROLTARJETAS_02(SubBin)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para almacenar la cantidad de folios de tarjetas sin asignar por Bin y SubBin.'$$