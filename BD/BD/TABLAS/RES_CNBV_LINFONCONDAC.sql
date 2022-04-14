-- RES_CNBV_LINFONCONDAC

DELIMITER ;

DROP TABLE IF EXISTS `RES_CNBV_LINFONCONDAC`;

DELIMITER $$

CREATE TABLE RES_CNBV_LINFONCONDAC (
	LineaFondeoID 			INT(11) 	NOT NULL 		COMMENT 'ID de la linea de Fondeo, Consecutivo de linea por Institucion de Fondeo (InstitutFondID)\n',
	ActividadBMXID 			VARCHAR(15) NOT NULL 		COMMENT 'Identificador de tabla ACTIVIDADESBMX',
	EmpresaID 				INT(11) 	DEFAULT NULL 	COMMENT 'Campos de auditoria',
	Usuario 				INT(11) 	DEFAULT NULL 	COMMENT 'Campos de auditoria',
	FechaActual 			DATETIME 	DEFAULT NULL 	COMMENT 'Campos de auditoria',
	ProgramaID 				VARCHAR(50) DEFAULT NULL 	COMMENT 'Campos de auditoria',
	DireccionIP 			VARCHAR(15) DEFAULT NULL 	COMMENT 'Campos de auditoria',
	Sucursal 				INT(11) 	DEFAULT NULL 	COMMENT 'Campos de auditoria',
	NumTransaccion 			BIGINT(20) 	DEFAULT NULL 	COMMENT 'Campos de auditoria',
	PRIMARY KEY (`LineaFondeoID`,`ActividadBMXID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab Tabla de respaldo de datos de Condiciones de LINFONCONDAC'$$
