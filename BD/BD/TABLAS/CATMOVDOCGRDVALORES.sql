-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DOCUMENTOSGRDVALORES
DELIMITER ;
DROP TABLE IF EXISTS `CATMOVDOCGRDVALORES`;

DELIMITER $$
CREATE TABLE `CATMOVDOCGRDVALORES` (
	CatMovimientoID			INT(11)			NOT NULL COMMENT 'ID de Tabla',
	NombreMovimiento		VARCHAR(50)		NOT NULL COMMENT 'Nombre del Movimiento',
	Descripcion				VARCHAR(200)	NOT NULL COMMENT 'Descripción del Movimiento',
	Estatus					CHAR(1)			NOT NULL COMMENT 'Estatus \nA= Activo \nI= Inactivo.',
	EstatusRelacion			CHAR(1)			NOT NULL COMMENT 'Estatus de Relación con la Tabla de DOCUMENTOSGRDVALORES.',
	EmpresaID				INT(11)			NOT NULL COMMENT 'ID de la empresa',
	Usuario					INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID del usuario',
	FechaActual				DATETIME		NOT NULL COMMENT 'Parámetro de auditoría Fecha actual',
	DireccionIP				VARCHAR(15)		NOT NULL COMMENT 'Parámetro de auditoría Dirección IP',
	ProgramaID				VARCHAR(50)		NOT NULL COMMENT 'Parámetro de auditoría Programa',
	Sucursal				INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID de la sucursal',
	NumTransaccion			BIGINT(20)		NOT NULL COMMENT 'Parámetro de auditoría Número de la transacción',
	PRIMARY KEY (`CatMovimientoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cat: Catálogo de Movimientos Préstamo de Documentos en Guarda de Valores.'$$