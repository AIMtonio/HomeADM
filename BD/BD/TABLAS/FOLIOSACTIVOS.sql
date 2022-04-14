-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FOLIOSACTIVOS
DELIMITER ;
DROP TABLE IF EXISTS FOLIOSACTIVOS;

DELIMITER $$
CREATE TABLE FOLIOSACTIVOS (
	Anio				INT(11)			NOT NULL COMMENT 'Año',
	Mes					INT(11)			NOT NULL COMMENT 'Mes',
	TipoActivoID		INT(11)			NOT NULL COMMENT 'Tipo Activo ID',
	Folio 				INT(11)			NOT NULL COMMENT 'Número de Folio',

	EmpresaID			INT(11)			NOT NULL COMMENT 'Parámetro de auditoria ID de la Empresa',
	Usuario				INT(11)			NOT NULL COMMENT 'Parámetro de auditoria ID del Usuario',
	FechaActual			DATETIME		NOT NULL COMMENT 'Parámetro de auditoria Fecha actual',
	DireccionIP			VARCHAR(15)		NOT NULL COMMENT 'Parámetro de auditoria Direccion IP ',
	ProgramaID			VARCHAR(50)		NOT NULL COMMENT 'Parámetro de auditoria Programa ID',
	Sucursal			INT(11)			NOT NULL COMMENT 'Parámetro de auditoria ID de la Sucursal',
	NumTransaccion		BIGINT(20)		NOT NULL COMMENT 'Parámetro de auditoria Número de la transacción',
	PRIMARY KEY ( Anio, Mes,TipoActivoID),
	CONSTRAINT `FK_FOLIOSACTIVOS_1` FOREIGN KEY (`TipoActivoID`) REFERENCES `TIPOSACTIVOS` (`TipoActivoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tb.- Tabla Foliadora para el Tipo de Activo por Año y mes.'$$