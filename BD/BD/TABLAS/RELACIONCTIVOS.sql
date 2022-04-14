-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RELACIONCTIVOS
DELIMITER ;
DROP TABLE IF EXISTS RELACIONCTIVOS;

DELIMITER $$
CREATE TABLE RELACIONCTIVOS (
	ConsecutivoID			INT(11)			NOT NULL COMMENT 'ID de Tabla',
	RegistroID				INT(11)			NOT NULL COMMENT 'ID Consecutivo del Cliente ',
	ActivoID 				INT(11)			NOT NULL COMMENT 'ID de Activo',

	EmpresaID				INT(11)			NOT NULL COMMENT 'Parámetro de auditoria ID de la Empresa',
	Usuario					INT(11)			NOT NULL COMMENT 'Parámetro de auditoria ID del Usuario',
	FechaActual				DATETIME		NOT NULL COMMENT 'Parámetro de auditoria Fecha actual',
	DireccionIP				VARCHAR(15)		NOT NULL COMMENT 'Parámetro de auditoria Direccion IP ',
	ProgramaID				VARCHAR(50)		NOT NULL COMMENT 'Parámetro de auditoria Programa ID',
	Sucursal				INT(11)			NOT NULL COMMENT 'Parámetro de auditoria ID de la Sucursal',
	NumTransaccion			BIGINT(20)		NOT NULL COMMENT 'Parámetro de auditoria Número de la transacción',
	PRIMARY KEY ( ConsecutivoID),
	KEY IDX_RELACIONCTIVOS_1 (RegistroID),
	KEY IDX_RELACIONCTIVOS_2 (ActivoID),
	CONSTRAINT `FK_RELACIONCTIVOS_1` FOREIGN KEY (`ActivoID`) REFERENCES `ACTIVOS` (`ActivoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tb.- Tabla de Relación de Folios Activos registrados de forma Masiva.'$$