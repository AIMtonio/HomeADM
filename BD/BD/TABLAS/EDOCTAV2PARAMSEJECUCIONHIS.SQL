DELIMITER ;
DROP TABLE IF EXISTS EDOCTAV2PARAMSEJECUCIONHIS;
DELIMITER $$


CREATE TABLE EDOCTAV2PARAMSEJECUCIONHIS (
	EjecucionID				INT(11) 	NOT NULL COMMENT 'LLAVE PRIMARIA',
	TipoEjecucion			CHAR(1) 	NOT NULL COMMENT 'Tipo de ejecucion C= ejecucion por clientes especificos, S=Ejecucion por Sucursales especificas',
	EjecucionJobPdf			CHAR(1) 	NOT NULL COMMENT 'S= indica que se ejecutara el job para la generacion de pdfs N= inidca que no se jecutara el job para la generacion de pdf',
	EjecucionJobTim			CHAR(1) 	NOT NULL COMMENT 'S= indica que se ejecutara el job para el timbrado N= inidca que no se jecutara el job para el timbrado',
	EjecucionSPPrin			CHAR(1) 	NOT NULL COMMENT 'S= indica que se ejecutara el sp principal, para extraccion de datos N= inidca que no se ejecutara el sp principal',
	Instrumentos			TEXT 		NOT NULL COMMENT 'Dependiendo de la columna TipoEjecucion = C  este columna guardara los ids, de los clientes separados por coma a procesar \n Si TipoEjecucion = S este campo contendra los ids de las sucursales a procesar',
	FechaEjecucion			DATETIME	NOT NULL COMMENT 'Fecha de ejecucion',
	Usuario 				INT(11) 	NOT NULL COMMENT 'Parametro de Auditoria',
	FechaActual 			DATETIME 	NOT NULL COMMENT 'Parametro de Auditoria',
	DireccionIP 			VARCHAR(15) NOT NULL COMMENT 'Parametro de Auditoria',
	ProgramaID 				VARCHAR(50) NOT NULL COMMENT 'Parametro de Auditoria',
	Sucursal 				INT(11) 	NOT NULL COMMENT 'Parametro de Auditoria',
	NumTransaccion 			BIGINT(20)	NOT NULL COMMENT 'Parametro de Auditoria',
	PRIMARY KEY(EjecucionID)

) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='His: Tabla historica para registrar las diferentes formas de ejecucion del proceso de timbrado'$$
