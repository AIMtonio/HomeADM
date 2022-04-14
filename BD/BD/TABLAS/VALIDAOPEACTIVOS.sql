-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- VALIDAOPEACTIVOS
DELIMITER ;
DROP TABLE IF EXISTS `VALIDAOPEACTIVOS`;

DELIMITER $$
CREATE TABLE `VALIDAOPEACTIVOS` (
	RegistroID					INT(11)			NOT NULL COMMENT 'ID de Tabla',
	ActivoID					INT(11)			NOT NULL COMMENT 'ID de Tabla ACTIVOS',

	EmpresaID					INT(11)			NOT NULL COMMENT 'ID de la empresa',
	Usuario						INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID del usuario',
	FechaActual					DATETIME		NOT NULL COMMENT 'Parámetro de auditoría Fecha actual',
	DireccionIP					VARCHAR(15)		NOT NULL COMMENT 'Parámetro de auditoría Dirección IP',
	ProgramaID					VARCHAR(50)		NOT NULL COMMENT 'Parámetro de auditoría Programa',
	Sucursal					INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID de la Sucursal',
	NumTransaccion				BIGINT(20)		NOT NULL COMMENT 'Parámetro de auditoría Número de la Transacción',
	PRIMARY KEY (`RegistroID`),
	KEY `IDX_VALIDAOPEACTIVOS_1` (`RegistroID`),
	KEY `IDX_VALIDAOPEACTIVOS_2` (`ActivoID`),
	CONSTRAINT `FK_VALIDAOPEACTIVOS_1` FOREIGN KEY (`ActivoID`) REFERENCES `ACTIVOS` (`ActivoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla de Validación para el proceso de Modificación de Activos.'$$
