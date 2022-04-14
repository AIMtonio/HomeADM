-- Creacion de tabla NOMTIPOCLAVEPRESUP

DELIMITER ;

DROP TABLE IF EXISTS NOMTIPOCLAVEPRESUP;

DELIMITER $$

CREATE TABLE NOMTIPOCLAVEPRESUP (
	NomTipoClavePresupID		INT(11)			NOT NULL COMMENT 'Id de la Tabla del tipo Clave Presupuestal',
	Descripcion					VARCHAR(80)		NOT NULL COMMENT 'Descripcion o nombre del tipo de clave presupuestal',
	ReqClave					CHAR(1)			NOT NULL COMMENT 'Indicara si sera requerido ingresar una clave cuando se de de alta una clave presupuestal S=Si, N=No',

	EmpresaID					INT(11)			NOT NULL COMMENT 'Parametros de Auditoria',
	Usuario						INT(11)			NOT NULL COMMENT 'Parametros de Auditoria',
	FechaActual					DATETIME		NOT NULL COMMENT 'Parametros de Auditoria',
	DireccionIP					VARCHAR(15)		NOT NULL COMMENT 'Parametros de Auditoria',
	ProgramaID					VARCHAR(50)		NOT NULL COMMENT 'Parametros de Auditoria',
	Sucursal					INT(11)			NOT NULL COMMENT 'Parametros de Auditoria',
	NumTransaccion				BIGINT(20)		NOT NULL COMMENT 'Parametros de Auditoria',

	PRIMARY KEY (NomTipoClavePresupID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tbl: Tabla para el Registro de Tipos de Clave presupuestal.'$$
