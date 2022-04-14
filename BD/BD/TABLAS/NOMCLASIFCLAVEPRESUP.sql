-- Creacion de tabla NOMCLASIFCLAVEPRESUP

DELIMITER ;

DROP TABLE IF EXISTS NOMCLASIFCLAVEPRESUP;

DELIMITER $$

CREATE TABLE NOMCLASIFCLAVEPRESUP (
	NomClasifClavPresupID		INT(11)			NOT NULL COMMENT 'Id de la Tabla del Clasificacion de Claves Presupuestales',
	Descripcion					VARCHAR(100)	NOT NULL COMMENT 'Indica el tipo de clasificacion de clave presupuestal',
	Estatus						CHAR(1)			NOT NULL COMMENT 'Indica el Estatus de la Clasificacion de clave presupuestal  Nace A=Activo,I=Inactivo',
	Prioridad					INT(11)			NOT NULL COMMENT 'Numero de la Prioridad de la Clasificacion de Clave Presupuestal',
	NomClavePresupID			VARCHAR(3000)	NOT NULL COMMENT 'Cadena con los IDS de Claves Presupuestales separados por coma (IDs de la tabla NOMCLAVEPRESUP)',

	EmpresaID					VARCHAR(45)		NOT NULL COMMENT 'Parametros de Auditoria',
	Usuario						INT(11)			NOT NULL COMMENT 'Parametros de Auditoria',
	FechaActual					DATETIME		NOT NULL COMMENT 'Parametros de Auditoria',
	DireccionIP					VARCHAR(15)		NOT NULL COMMENT 'Parametros de Auditoria',
	ProgramaID					VARCHAR(50)		NOT NULL COMMENT 'Parametros de Auditoria',
	Sucursal					INT(11)			NOT NULL COMMENT 'Parametros de Auditoria',
	NumTransaccion				BIGINT(20)		NOT NULL COMMENT 'Parametros de Auditoria',

	PRIMARY KEY (NomClasifClavPresupID),
	INDEX (NomClavePresupID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tbl: Tabla para el Registro de la Clasificacion de Clave presupuestales.'$$
