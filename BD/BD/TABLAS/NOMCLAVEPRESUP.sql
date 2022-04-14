-- Creacion de tabla NOMCLAVEPRESUP

DELIMITER ;

DROP TABLE IF EXISTS NOMCLAVEPRESUP;

DELIMITER $$

CREATE TABLE NOMCLAVEPRESUP (
	NomClavePresupID			INT(11)			NOT NULL COMMENT 'Id de la Tabla del Claves Presupuestales',
	NomTipoClavePresupID		INT(11)			NOT NULL COMMENT 'Numero o Id de la Tabla del tipo Clave Presupuestal (Une con tabla NOMTIPOCLAVEPRESUP)',
	Clave						CHAR(8)			NOT NULL COMMENT 'Indica el Clave que corresponde al registro presupuestal ',
	Descripcion					VARCHAR(80)		NOT NULL COMMENT 'Descripcion o nombre del clave presupuestal',

	EmpresaID					INT(11)			NOT NULL COMMENT 'Parametros de Auditoria',
	Usuario						INT(11)			NOT NULL COMMENT 'Parametros de Auditoria',
	FechaActual					DATETIME		NOT NULL COMMENT 'Parametros de Auditoria',
	DireccionIP					VARCHAR(15)		NOT NULL COMMENT 'Parametros de Auditoria',
	ProgramaID					VARCHAR(50)		NOT NULL COMMENT 'Parametros de Auditoria',
	Sucursal					INT(11)			NOT NULL COMMENT 'Parametros de Auditoria',
	NumTransaccion				BIGINT(20)		NOT NULL COMMENT 'Parametros de Auditoria',

	PRIMARY KEY (NomClavePresupID),
	INDEX (NomTipoClavePresupID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tbl: Tabla para el Registro de Clave presupuestal y conceptos'$$
