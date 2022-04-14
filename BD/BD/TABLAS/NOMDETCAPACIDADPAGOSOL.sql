-- Creacion de tabla NOMDETCAPACIDADPAGOSOL

DELIMITER ;

DROP TABLE IF EXISTS NOMDETCAPACIDADPAGOSOL;

DELIMITER $$

CREATE TABLE NOMDETCAPACIDADPAGOSOL (
	NomDetCapacidadPagoSolID	BIGINT(12)		NOT NULL COMMENT 'Numero o ID de la Tabla de Capacidad de pago por Solicitud de Credito.',
	NomCapacidadPagoSolID		BIGINT(12)		NOT NULL COMMENT 'Numero o ID de la Tabla de Capacidad de pago por Solicitud de Credito.',
	ClasifClavePresupID			INT(11)			NOT NULL COMMENT 'Indica el Numero de la Clasificacion de la Clave Presupuestal',
	DescClasifClavePresup		VARCHAR(80)		NOT NULL COMMENT 'Indica la Descripcion de la Clasificacion de la Clave Presupuestal',
	ClavePresupID				INT(11)			NOT NULL COMMENT 'Indica el Numero de la Clave Presupuestal',
	Clave						VARCHAR(8)		NOT NULL COMMENT 'Indica la Clave Presupuestal, si se trata de un Concepto fijo que no Cuenta con una Clave se Vizualiza Vacio',
	DescClavePresup				VARCHAR(80)		NOT NULL COMMENT 'Indica la Descripción de las Claves Presupuestales y de los Conceptos Fijos',
	Monto						DECIMAL(12,2)	NOT NULL COMMENT 'Indica el Monto por cada Clave Presupuestal Y Conceptos Fijos',
	EmpresaID					VARCHAR(45)		NOT NULL COMMENT 'Parametros de Auditoria',
	Usuario						INT(11)			NOT NULL COMMENT 'Parametros de Auditoria',
	FechaActual					DATETIME		NOT NULL COMMENT 'Parametros de Auditoria',
	DireccionIP					VARCHAR(15)		NOT NULL COMMENT 'Parametros de Auditoria',
	ProgramaID					VARCHAR(50)		NOT NULL COMMENT 'Parametros de Auditoria',
	Sucursal					INT(11)			NOT NULL COMMENT 'Parametros de Auditoria',
	NumTransaccion				BIGINT(20)		NOT NULL COMMENT 'Parametros de Auditoria',
	PRIMARY KEY (NomDetCapacidadPagoSolID),
	KEY `fk_NOMDETCAPACIDADPAGOSOL_1` (NomCapacidadPagoSolID),
	INDEX(ClasifClavePresupID),
	INDEX(ClavePresupID),
	CONSTRAINT `fk_NOMDETCAPACIDADPAGOSOL_1` FOREIGN KEY (NomCapacidadPagoSolID) REFERENCES NOMCAPACIDADPAGOSOL (NomCapacidadPagoSolID) ON DELETE NO ACTION ON UPDATE NO ACTION
)ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tbl: Tabla para el Registro del Detalle de Datos Socioeconomico de Capacidad de Pago Por Solicitud.'$$
