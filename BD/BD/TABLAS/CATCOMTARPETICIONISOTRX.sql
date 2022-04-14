-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATCOMTARPETICIONISOTRX
DELIMITER ;
DROP TABLE IF EXISTS `CATCOMTARPETICIONISOTRX`;

DELIMITER $$
CREATE TABLE CATCOMTARPETICIONISOTRX(
	ComandoID				INT(11)			NOT NULL COMMENT 'Llave de Tabla: Comando',
	Descripcion				VARCHAR(200)	NOT NULL COMMENT 'Descripción de la operación',

	EmpresaID				INT(11)			NOT NULL COMMENT 'ID de la Empresa',
	Usuario					INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID del usuario',
	FechaActual				DATETIME		NOT NULL COMMENT 'Parámetro de auditoría Fecha actual',
	DireccionIP				VARCHAR(15)		NOT NULL COMMENT 'Parámetro de auditoría Dirección IP',
	ProgramaID				VARCHAR(50)		NOT NULL COMMENT 'Parámetro de auditoría Programa',
	Sucursal				INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID de la sucursal',
	NumTransaccion			BIGINT(20)		NOT NULL COMMENT 'Parámetro de auditoría Número de la transacción',
	PRIMARY KEY (`ComandoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cat: Catálogo de Comandos para las peticiones de Tarjetas en ISOTRX.'$$