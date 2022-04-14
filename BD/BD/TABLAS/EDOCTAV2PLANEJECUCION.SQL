DELIMITER ;
DROP TABLE IF EXISTS EDOCTAV2PLANEJECUCION;
DELIMITER $$


CREATE TABLE EDOCTAV2PLANEJECUCION (
	EjecucionID				INT(11) 	NOT NULL COMMENT 'LLAVE PRIMARIA',
	TipoEjecucion			VARCHAR(30)	NOT NULL COMMENT 'Tipo de ejecucion C= ejecucion por clientes especificos, S=Ejecucion por Sucursales especificas',
	EjecucionJobPdf			VARCHAR(30)	NOT NULL COMMENT 'S= indica que se ejecutara el job para la generacion de pdfs N= inidca que no se jecutara el job para la generacion de pdf',
	EjecucionJobTim			VARCHAR(30)	NOT NULL COMMENT 'S= indica que se ejecutara el job para el timbrado N= inidca que no se jecutara el job para el timbrado',
	EjecucionSPPrin			VARCHAR(30)	NOT NULL COMMENT 'S= indica que se ejecutara el sp principal, para extraccion de datos N= inidca que no se ejecutara el sp principal',
	Instrumentos			TEXT 		NOT NULL COMMENT 'Dependiendo de la columna TipoEjecucion = C  este columna guardara los ids, de los clientes separados por coma a procesar \n Si TipoEjecucion = S este campo contendra los ids de las sucursales a procesar',
	Usuario 				INT(11) 	NOT NULL COMMENT 'Parametro de Auditoria',
	FechaActual 			DATETIME 	NOT NULL COMMENT 'Parametro de Auditoria',
	DireccionIP 			VARCHAR(15) NOT NULL COMMENT 'Parametro de Auditoria',
	ProgramaID 				VARCHAR(50) NOT NULL COMMENT 'Parametro de Auditoria',
	Sucursal 				INT(11) 	NOT NULL COMMENT 'Parametro de Auditoria',
	NumTransaccion 			BIGINT(20)	NOT NULL COMMENT 'Parametro de Auditoria',
	PRIMARY KEY(EjecucionID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para registrar las diferentes formas de ejecución del proceso de timbrado'$$