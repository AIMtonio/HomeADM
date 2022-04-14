DELIMITER ;
DROP TABLE IF EXISTS EDOCTAV2PDFGENERADOS;
DELIMITER $$


CREATE TABLE EDOCTAV2PDFGENERADOS (
	EdoCtaV2PDFID			BIGINT(20)		NOT NULL AUTO_INCREMENT COMMENT 'Numero consecutivo',
	AnioMes 				INT(11) 		NOT NULL COMMENT 'Anio y mes para generar Estado de cuenta',
	ClienteID 				INT(11) 		NOT NULL COMMENT 'Numero de cliente',
	RutaArchivo				VARCHAR(2000)	NOT NULL COMMENT 'Ruta del archivo que se adjuntara',
	PesoByte				LONG			NOT NULL COMMENT 'Peso del archivo a adjuntar',
	PRIMARY KEY (EdoCtaV2PDFID),
	INDEX (AnioMes,ClienteID)

) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para registrar la relacion de PDFs generados por cliente y por periodo'$$
