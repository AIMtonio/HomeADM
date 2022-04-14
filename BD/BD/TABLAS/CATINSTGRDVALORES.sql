-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATINSTGRDVALORES
DELIMITER ;
DROP TABLE IF EXISTS `CATINSTGRDVALORES`;

DELIMITER $$
CREATE TABLE `CATINSTGRDVALORES` (
	CatInsGrdValoresID		INT(11)			NOT NULL COMMENT 'ID de Tabla',
	NombreInstrumento		VARCHAR(50)		NOT NULL COMMENT 'Nombre del Instrumento',
	Descripcion				VARCHAR(200)	NOT NULL COMMENT 'Descripción del Instrumento',
	Estatus					CHAR(1)			NOT NULL COMMENT 'Estatus \nA= Activo \nI= Inactivo.',
	ManejaCheckList 		CHAR(1)			NOT NULL COMMENT 'El Instrumento maneja un check list \nS= SI \nN= NO',
	ManejaDigitalizacion	CHAR(1)			NOT NULL COMMENT 'El Instrumento maneja un Digitalización \nS= SI \nN= NO',
	EmpresaID				INT(11)			NOT NULL COMMENT 'ID de la empresa',
	Usuario					INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID del usuario',
	FechaActual				DATETIME		NOT NULL COMMENT 'Parámetro de auditoría Fecha actual',
	DireccionIP				VARCHAR(15)		NOT NULL COMMENT 'Parámetro de auditoría Dirección IP',
	ProgramaID				VARCHAR(50)		NOT NULL COMMENT 'Parámetro de auditoría Programa',
	Sucursal				INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID de la sucursal',
	NumTransaccion			BIGINT(20)		NOT NULL COMMENT 'Parámetro de auditoría Numero de la transacción',
	PRIMARY KEY (`CatInsGrdValoresID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cat: Catálogo de Instrumentos de Documentos Guarda de Valores.'$$