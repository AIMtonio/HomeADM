-- Creacion de tabla NOMCLAVESCONVENIO

DELIMITER ;

DROP TABLE IF EXISTS NOMCLAVESCONVENIO;

DELIMITER $$

CREATE TABLE NOMCLAVESCONVENIO (
	NomClaveConvenioID			INT(11)			NOT NULL COMMENT 'Id de la Tabla del Claves Presupuestales por Convenios de Nomina.',
	InstitNominaID				INT(11)			NOT NULL COMMENT 'ID o Numero de Institucion de Nomina (Une con tabla INSTITNOMINA)',
	ConvenioNominaID			BIGINT(20)		NOT NULL COMMENT 'Id o numero de  Convenio de la institucion de nomina (Une con tabla CONVENIOSNOMINA)',
	NomClavePresupID			VARCHAR(3000)	NOT NULL COMMENT 'Cadena con los IDS de Claves Presupuestales separados por coma (IDs de la tabla NOMCLAVEPRESUP)',

	EmpresaID					VARCHAR(45)		NOT NULL COMMENT 'Parametros de Auditoria',
	Usuario						INT(11)			NOT NULL COMMENT 'Parametros de Auditoria',
	FechaActual					DATETIME		NOT NULL COMMENT 'Parametros de Auditoria',
	DireccionIP					VARCHAR(15)		NOT NULL COMMENT 'Parametros de Auditoria',
	ProgramaID					VARCHAR(50)		NOT NULL COMMENT 'Parametros de Auditoria',
	Sucursal					INT(11)			NOT NULL COMMENT 'Parametros de Auditoria',
	NumTransaccion				BIGINT(20)		NOT NULL COMMENT 'Parametros de Auditoria',

	PRIMARY KEY (NomClaveConvenioID),
	INDEX `FK_NOMCLAVESCONVENIO_1` (NomClavePresupID),
	KEY `FK_NOMCLAVESCONVENIO_2` (InstitNominaID),
	INDEX `FK_NOMCLAVESCONVENIO_3` (ConvenioNominaID),
	CONSTRAINT `FK_NOMCLAVESCONVENIO_2` FOREIGN KEY (InstitNominaID) REFERENCES INSTITNOMINA (InstitNominaID) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tbl: Tabla para el Registro de las Clave presupuestales por convenios de nomina.'$$
