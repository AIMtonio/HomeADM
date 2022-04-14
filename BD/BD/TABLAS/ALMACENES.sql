-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ALMACENES
DELIMITER ;
DROP TABLE IF EXISTS `ALMACENES`;

DELIMITER $$
CREATE TABLE `ALMACENES` (
	AlmacenID					INT(11)			NOT NULL COMMENT 'ID de Tabla',
	NombreAlmacen				VARCHAR(50)		NOT NULL COMMENT 'Nombre o Descripción del Almacén',
	Estatus						CHAR(1)			NOT NULL COMMENT 'Estatus del Almacén \nA.- Activo \nI.- Inactivo',
	SucursalID					INT(11)			NOT NULL COMMENT 'ID de Tabla SUCURSALES',
	EmpresaID					INT(11)			NOT NULL COMMENT 'ID de la empresa',
	Usuario						INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID del usuario',
	FechaActual					DATETIME		NOT NULL COMMENT 'Parámetro de auditoría Fecha actual',
	DireccionIP					VARCHAR(15)		NOT NULL COMMENT 'Parámetro de auditoría Dirección IP',
	ProgramaID					VARCHAR(50)		NOT NULL COMMENT 'Parámetro de auditoría Programa',
	Sucursal					INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID de la Sucursal',
	NumTransaccion				BIGINT(20)		NOT NULL COMMENT 'Parámetro de auditoría Número de la Transacción',
	PRIMARY KEY (`AlmacenID`),
	KEY `IDX_ALMACENES_1` (`AlmacenID`),
	KEY `IDX_ALMACENES_2` (`SucursalID`),
	CONSTRAINT `FK_ALMACENES_1` FOREIGN KEY (`SucursalID`) REFERENCES `SUCURSALES` (`SucursalID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tb: Tabla de Almacenes para Guarda de Valores.'$$