-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATESTTARJETAISOTRX
DELIMITER ;
DROP TABLE IF EXISTS `CATESTTARJETAISOTRX`;

DELIMITER $$
CREATE TABLE CATESTTARJETAISOTRX(
	EstatusTarjeta			INT(11)			NOT NULL COMMENT 'Llave de Tabla',
	EstatusSAFI				INT(11)			NOT NULL COMMENT 'Estatus de Equivalencia SAFI',
	Descripcion				VARCHAR(200)	NOT NULL COMMENT 'Descripción de la operación',

	EmpresaID				INT(11)			NOT NULL COMMENT 'ID de la Empresa',
	Usuario					INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID del usuario',
	FechaActual				DATETIME		NOT NULL COMMENT 'Parámetro de auditoría Fecha actual',
	DireccionIP				VARCHAR(15)		NOT NULL COMMENT 'Parámetro de auditoría Dirección IP',
	ProgramaID				VARCHAR(50)		NOT NULL COMMENT 'Parámetro de auditoría Programa',
	Sucursal				INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID de la sucursal',
	NumTransaccion			BIGINT(20)		NOT NULL COMMENT 'Parámetro de auditoría Número de la transacción',
	PRIMARY KEY (`EstatusTarjeta`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cat: Catálogo de Estatus de Tarjeta para ISOTRX.'$$