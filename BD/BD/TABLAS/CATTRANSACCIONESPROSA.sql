-- CATTRANSACCIONESPROSA
DELIMITER ;
DROP TABLE IF EXISTS CATTRANSACCIONESPROSA;

DELIMITER $$
CREATE TABLE CATTRANSACCIONESPROSA (
	Tipo					VARCHAR(3) 		NOT NULL COMMENT 'Numero del Tipo',
	Nombre					VARCHAR(100)	NOT NULL COMMENT 'Nombre de la Transaccines stats',
	Descripcion				VARCHAR(100)	NOT NULL COMMENT 'Descripcion de la transacciones stats',
	Catalogo				VARCHAR(50)		NOT NULL COMMENT 'Catalogo de la transacciones stats',
	TipoOperacionID			VARCHAR(2)		NOT NULL COMMENT 'Referencia al tabla TC_TipoOperaciones',
	Valor					VARCHAR(50)		NOT NULL COMMENT 'Valor obtenido del archivo stats',
	TipoCatalogo			CHAR(1)			NOT NULL COMMENT 'Tipo de archivo del catalogo (S= STATS, E = EMMI)',
	EmpresaID				INT(11)			NOT NULL COMMENT 'Campo de auditoria ID de la empresa',
	Usuario					INT(11)			NOT NULL COMMENT 'Campo de auditoría ID del usuario',
	FechaActual				DATETIME		NOT NULL COMMENT 'Campo de auditoría Fecha actual',
	DireccionIP				VARCHAR(15)		NOT NULL COMMENT 'Campo de auditoría Dirección IP',
	ProgramaID				VARCHAR(50)		NOT NULL COMMENT 'Campo de auditoría Programa',
	Sucursal				INT(11)			NOT NULL COMMENT 'Campo de auditoría ID de la Sucursal',
	NumTransaccion			BIGINT(20)		NOT NULL COMMENT 'Campo de auditoría Número de la Transacción'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cat: Tabla que almacena el catalogo de Transacciones para los archivos EMI y STATS'$$
