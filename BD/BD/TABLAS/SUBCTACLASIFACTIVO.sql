-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTACLASIFACTIVO
DELIMITER ;
DROP TABLE IF EXISTS SUBCTACLASIFACTIVO;
DELIMITER $$

CREATE TABLE SUBCTACLASIFACTIVO (
	ConceptoActivoID	INT(11)		NOT NULL COMMENT 'PK de la tabla, Y FK que corresponde con la tabla de CONCEPTOSACTIVOS',
	TipoActivoID		INT(11)		NOT NULL COMMENT 'Id del tipo de activo',
	SubCuenta			CHAR(15)	NOT NULL COMMENT 'Subcuenta por tipo de activo',

	EmpresaID			INT(11)		NOT NULL COMMENT 'Parámetro de auditoria ID de la empresa',
	Usuario				INT(11)		NOT NULL COMMENT 'Parámetro de auditoria ID del usuario',
	FechaActual			DATETIME	NOT NULL COMMENT 'Parámetro de auditoria Fecha actual',
	DireccionIP			VARCHAR(15)	NOT NULL COMMENT 'Parámetro de auditoria Direccion IP ',
	ProgramaID			VARCHAR(50)	NOT NULL COMMENT 'Parámetro de auditoria Programa ',
	Sucursal			INT(11)		NOT NULL COMMENT 'Parámetro de auditoria ID de la sucursal',
	NumTransaccion		BIGINT(20)	NOT NULL COMMENT 'Parámetro de auditoria Número de la transacción',
	PRIMARY KEY (ConceptoActivoID,TipoActivoID),
	KEY IDX_SUBCTACLASIFACTIVO_1 (ConceptoActivoID),
	KEY IDX_SUBCTACLASIFACTIVO_2 (TipoActivoID),
	CONSTRAINT FK_SUBCTACLASIFACTIVO_1 FOREIGN KEY (ConceptoActivoID) REFERENCES CONCEPTOSACTIVOS (ConceptoActivoID) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT FK_SUBCTACLASIFACTIVO_2 FOREIGN KEY (TipoActivoID) REFERENCES TIPOSACTIVOS (TipoActivoID) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Subcuenta por Clasificación de Activos para el Módulo de Activos'$$