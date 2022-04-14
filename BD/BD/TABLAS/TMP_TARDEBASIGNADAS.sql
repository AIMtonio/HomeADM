-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMP_TARDEBASIGNADAS
DELIMITER ;
DROP TABLE IF EXISTS TMP_TARDEBASIGNADAS;
DELIMITER $$


CREATE TABLE TMP_TARDEBASIGNADAS (
	ID					BIGINT(20) AUTO_INCREMENT 	NOT NULL 				COMMENT 'Identificador de la tabla',
	CodigoEstatus 		VARCHAR(9) 					NOT NULL 				COMMENT 'Estatus Code al consumir el WebServide de tarjetas (200 = Exitoso).',
	CompTarjeta 		VARCHAR(9)					DEFAULT NULL 			COMMENT 'Compuesto del SubBin y Consecutivo de tarjeta.',
	CodRespWSTarjetas	VARCHAR(10)					NOT NULL 				COMMENT 'Codigo de respuesta del WS de consulta de tarjetas.',
	MenRespWSTarjetas	VARCHAR(300)				NOT NULL 				COMMENT 'Mensaje de respuesta del WS de consulta de tarjetas.',
	Estatus 			CHAR(1)						NOT NULL DEFAULT 'R' 	COMMENT 'Estatus para el registro de tarjeta (R=Registrado, E = Generacion de tarjeta Exitosa, F = Generacion de tarjeta Fallida, C = Cancelada).',
	CodRespAsoc			INT(11)						NOT NULL DEFAULT 0 		COMMENT 'Codigo de respuesta al intentar realizar la asociacion de tarjeta',
	MenRespAsoc			VARCHAR(400)				NOT NULL DEFAULT ''  	COMMENT 'Mensaje de respuesta al intentar realizar la asociacion de tarjeta',
	LoteDebSAFIID 		INT(11)						DEFAULT NULL 			COMMENT 'ID Lote de TARJETAS.',
	
	Usuario 			INT(11) 					DEFAULT NULL 			COMMENT 'Parametro de Auditoria',
	FechaActual 		DATETIME 					DEFAULT NULL 			COMMENT 'Parametro de Auditoria',
	DireccionIP 		varchar(15) 				DEFAULT NULL 			COMMENT 'Parametro de Auditoria',
	ProgramaID 			varchar(50) 				DEFAULT NULL 			COMMENT 'Parametro de Auditoria',
	Sucursal 			INT(11) 					DEFAULT NULL 			COMMENT 'Parametro de Auditoria',
	NumTransaccion 		BIGINT(20) 					DEFAULT NULL 			COMMENT 'Parametro de Auditoria',
	PRIMARY KEY (ID),
	INDEX IDX_TMP_TARDEBASIGNADAS_Estatus(Estatus),
	INDEX IDX_TMP_TARDEBASIGNADAS_Tran(NumTransaccion)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla de uso temporal para guardado de resultados de tarjetas.'$$
