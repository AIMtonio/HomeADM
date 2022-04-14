-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATINSTCIRCREDITO
DELIMITER ;
DROP TABLE IF EXISTS `CATINSTCIRCREDITO`;

DELIMITER $$
CREATE TABLE `CATINSTCIRCREDITO` (
	ClaveID					VARCHAR(3)		NOT NULL COMMENT 'ID de Tabla',
	TipoInstitucion			VARCHAR(100)	NOT NULL COMMENT 'Tipo de Intitucion',
	Estatus					CHAR(1)			NOT NULL COMMENT 'Estatus \nA= Activo \nI= Inactivo.',

	EmpresaID				INT(11)			NOT NULL COMMENT 'ID de la empresa',
	Usuario					INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID del usuario',
	FechaActual				DATETIME		NOT NULL COMMENT 'Parámetro de auditoría Fecha actual',
	DireccionIP				VARCHAR(15)		NOT NULL COMMENT 'Parámetro de auditoría Dirección IP',
	ProgramaID				VARCHAR(50)		NOT NULL COMMENT 'Parámetro de auditoría Programa',
	Sucursal				INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID de la sucursal',
	NumTransaccion			BIGINT(20)		NOT NULL COMMENT 'Parámetro de auditoría Numero de la transacción',
	PRIMARY KEY (`ClaveID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cat: Catálogo de Tipos de Instituciones de Circulo de Crédito.'$$
