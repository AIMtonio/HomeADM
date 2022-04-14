-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATORIGENESDOCUMENTOS
DELIMITER ;
DROP TABLE IF EXISTS `CATORIGENESDOCUMENTOS`;

DELIMITER $$
CREATE TABLE `CATORIGENESDOCUMENTOS` (
	CatOrigenDocumentoID	INT(11)			NOT NULL COMMENT 'ID de Tabla',
	NombreOrigen			VARCHAR(50)		NOT NULL COMMENT 'Nombre del Origen de Documentos',
	Descripcion				VARCHAR(200)	NOT NULL COMMENT 'Descripción del Origen de Documentos',
	Estatus					CHAR(1)			NOT NULL COMMENT 'Estatus \nA= Activo \nI= Inactivo.',
	EmpresaID				INT(11)			NOT NULL COMMENT 'ID de la empresa',
	Usuario					INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID del usuario',
	FechaActual				DATETIME		NOT NULL COMMENT 'Parámetro de auditoría Fecha actual',
	DireccionIP				VARCHAR(15)		NOT NULL COMMENT 'Parámetro de auditoría Dirección IP',
	ProgramaID				VARCHAR(50)		NOT NULL COMMENT 'Parámetro de auditoría Programa',
	Sucursal				INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID de la sucursal',
	NumTransaccion			BIGINT(20)		NOT NULL COMMENT 'Parámetro de auditoría Número de la transacción',
	PRIMARY KEY (`CatOrigenDocumentoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cat: Catálogo de Origenes de Documentos Guarda de Valores.'$$