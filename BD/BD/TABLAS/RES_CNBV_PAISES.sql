-- RES_CNBV_PAISES

DELIMITER ;

DROP TABLE IF EXISTS RES_CNBV_PAISES;

DELIMITER $$

CREATE TABLE `RES_CNBV_PAISES` (
	PaisID 					INT(11) 		NOT NULL 		COMMENT 'Numero de Pais, segun el INEGI',
	PaisCNBV 				INT(5) 			DEFAULT NULL	COMMENT 'Pais segun el catalogo de CNBV',
	PaisRegSITI 			INT(11) 		DEFAULT NULL 	COMMENT 'Clave de Pais SITI - Regulatorios',
	EmpresaID 				INT(11) 		DEFAULT NULL 	COMMENT 'Empresa',
	Nombre 					VARCHAR(150) 	NOT NULL 		COMMENT 'Nombre del Pais',
	Gentilicio 				VARCHAR(100) 	DEFAULT NULL 	COMMENT 'Gentilicio',
	EqBuroCred 				VARCHAR(5) 		DEFAULT NULL 	COMMENT 'Equivalente a la clave del Pais de acuerdo a los catalogos de Buro de Credito',
	ClaveCNBV 				CHAR(4) 		DEFAULT NULL 	COMMENT 'Clave proporcionada por la CNBV para identificar cada pais',
	ClaveRiesgo 			CHAR(1) 		DEFAULT 'B' 	COMMENT 'Nivel de Riesgo del País.\nB.-Bajo\nA.- Alto',
	Usuario 				INT(11) 		DEFAULT NULL 	COMMENT 'campo de auditoria',
	FechaActual 			DATETIME 		DEFAULT NULL 	COMMENT 'campo de auditoria',
	DireccionIP 			VARCHAR(15) 	DEFAULT NULL 	COMMENT 'campo de auditoria',
	ProgramaID 				VARCHAR(50) 	DEFAULT NULL 	COMMENT 'campo de auditoria',
	Sucursal 				INT(11) 		DEFAULT NULL 	COMMENT 'campo de auditoria',
	NumTransaccion 			BIGINT(20) 		DEFAULT NULL 	COMMENT 'campo de auditoria',
	PRIMARY KEY (PaisID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: respaldo de catalogo de los paises'$$