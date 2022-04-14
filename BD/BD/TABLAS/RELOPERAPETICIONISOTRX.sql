-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RELOPERAPETICIONISOTRX
DELIMITER ;
DROP TABLE IF EXISTS `RELOPERAPETICIONISOTRX`;

DELIMITER $$
CREATE TABLE RELOPERAPETICIONISOTRX(
	OperacionPeticionID		INT(11)			NOT NULL COMMENT 'Llave de Tabla',
	CodigoOperacion			INT(11)			NOT NULL COMMENT 'Código de Operación',
	Descripcion				VARCHAR(200)	NOT NULL COMMENT 'Descripción de la operación',

	EmpresaID				INT(11)			NOT NULL COMMENT 'ID de la Empresa',
	Usuario					INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID del usuario',
	FechaActual				DATETIME		NOT NULL COMMENT 'Parámetro de auditoría Fecha actual',
	DireccionIP				VARCHAR(15)		NOT NULL COMMENT 'Parámetro de auditoría Dirección IP',
	ProgramaID				VARCHAR(50)		NOT NULL COMMENT 'Parámetro de auditoría Programa',
	Sucursal				INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID de la sucursal',
	NumTransaccion			BIGINT(20)		NOT NULL COMMENT 'Parámetro de auditoría Número de la transacción',
	PRIMARY KEY (`OperacionPeticionID`),
	KEY `IDX_RELOPERAPETICIONISOTRX_1` (`CodigoOperacion`),
	CONSTRAINT `FK_RELOPERAPETICIONISOTRX_1` FOREIGN KEY (`CodigoOperacion`) REFERENCES `CATTIPOPERACIONISOTRX` (`CodigoOperacion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tb: Relación de Operaciones de Petición para ISOTRX.'$$