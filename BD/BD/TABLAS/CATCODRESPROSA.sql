-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATCODRESPROSA
DELIMITER ;
DROP TABLE IF EXISTS CATCODRESPROSA;

DELIMITER $$
CREATE TABLE CATCODRESPROSA (
	RegistroID			INT(11)			NOT NULL COMMENT 'ID de Tabla',
	Peticion			CHAR(2)			NOT NULL COMMENT 'Peticion\n01.- ATM\n02.- POS',
	Codigo				CHAR(2)			NOT NULL COMMENT 'Codigo de Respuesta',
	Descripcion			VARCHAR(500)	NOT NULL COMMENT 'Descripción del Codigo de Respuesta',

	EmpresaID			INT(11)			NOT NULL COMMENT 'ID de la Empresa',
	Usuario				INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID del usuario',
	FechaActual			DATETIME		NOT NULL COMMENT 'Parámetro de auditoría Fecha actual',
	DireccionIP			VARCHAR(15)		NOT NULL COMMENT 'Parámetro de auditoría Dirección IP',
	ProgramaID			VARCHAR(50)		NOT NULL COMMENT 'Parámetro de auditoría Programa',
	Sucursal			INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID de la Sucursal',
	NumTransaccion		BIGINT(20)		NOT NULL COMMENT 'Parámetro de auditoría Número de la Transacción',
	PRIMARY KEY (RegistroID),
	KEY INDEX_CATCODRESPROSA_1 (Peticion),
	KEY INDEX_CATCODRESPROSA_2 (Codigo)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cat: Catalogo de Codigos de Respuesta de PROSA.'$$