-- RES_CNBV_TIPOINSTRUM

DELIMITER ;

DROP TABLE IF EXISTS RES_CNBV_TIPOINSTRUM;

DELIMITER $$

CREATE TABLE `RES_CNBV_TIPOINSTRUM` (
	TipoInstruMonID 	INT(11) 	NOT NULL 			COMMENT 'ID del tipo de instrumento monetario',
	Descripcion 		VARCHAR(50) DEFAULT NULL 		COMMENT 'Efectivo,docto SBF, docto mercantil,etc',
	Estatus 			CHAR(1) 	DEFAULT NULL 		COMMENT 'V=Vigente\nB=Baja',
	EmpresaID 			INT(11) 	DEFAULT NULL 		COMMENT 'N. Empresa',
	Usuario 			INT(11) 	DEFAULT NULL 		COMMENT 'campo de auditoria',
	FechaActual 		DATETIME 	DEFAULT NULL 		COMMENT 'campo de auditoria',
	DireccionIP 		VARCHAR(15) DEFAULT NULL 		COMMENT 'campo de auditoria',
	ProgramaID 			VARCHAR(50) DEFAULT NULL 		COMMENT 'campo de auditoria',
	Sucursal 			INT(11) 	DEFAULT NULL 		COMMENT 'campo de auditoria',
	NumTransaccion 		BIGINT(20) 	DEFAULT NULL 		COMMENT 'campo de auditoria',
	PRIMARY KEY (TipoInstruMonID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: respaldo de catalogo de tipos de instrumentos monetarios'$$