-- RES_CNBV_LOCALIDADREP

DELIMITER ;

DROP TABLE IF EXISTS RES_CNBV_LOCALIDADREP;

DELIMITER $$

CREATE TABLE `RES_CNBV_LOCALIDADREP` (
	EstadoID 			INT(11) 		NOT NULL 			COMMENT 'ID Estado',
	MunicipioID 		INT(11) 		NOT NULL 			COMMENT 'ID Municipio',
	LocalidadID 		INT(11) 		NOT NULL 			COMMENT 'ID Localidad',
	NombreLocalidad 	VARCHAR(200) 	DEFAULT NULL 		COMMENT 'Nombre de la localidad',
	NombreLocalidad2 	VARCHAR(200) 	DEFAULT NULL 		COMMENT 'Nombre de la localidad alterna',
	NumHabitantes 		INT(11) 		DEFAULT NULL 		COMMENT 'Numero de Habitantes',
	NumHabitantesHom 	INT(11) 		DEFAULT NULL 		COMMENT 'Numero de Habitantes hombres',
	NumHabitantesMuj 	INT(11) 		DEFAULT NULL 		COMMENT 'Numero de Habitantes mujeres',
	EsMarginada 		CHAR(1) 		DEFAULT NULL 		COMMENT 'Indica si la Localidad es Marginada',
	LocalidadCNBV 		VARCHAR(13) 	DEFAULT NULL 		COMMENT 'Localidad del catalogo CNBV',
	ClaveRiesgo 		CHAR(1) 		DEFAULT NULL 		COMMENT 'Campo para matriz de riesgos PLD - valores A.- Alto , B.-Bajo',
	EmpresaID 			INT(11) 		DEFAULT NULL 		COMMENT 'campo de auditoria',
	Usuario 			INT(11) 		DEFAULT NULL 		COMMENT 'campo de auditoria',
	FechaActual 		DATETIME 		DEFAULT NULL 		COMMENT 'campo de auditoria',
	DireccionIP 		VARCHAR(15) 	DEFAULT NULL 		COMMENT 'campo de auditoria',
	ProgramaID 			VARCHAR(50) 	DEFAULT NULL 		COMMENT 'campo de auditoria',
	Sucursal 			INT(11) 		DEFAULT NULL 		COMMENT 'campo de auditoria',
	NumTransaccion 		BIGINT(20) 		DEFAULT NULL 		COMMENT 'campo de auditoria',
	PRIMARY KEY (EstadoID,MunicipioID,LocalidadID),
	KEY MunicipioIDX (MunicipioID),
	KEY LocalidadIDX (LocalidadID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: respaldo de catalogo de Localidades de la Republica'$$