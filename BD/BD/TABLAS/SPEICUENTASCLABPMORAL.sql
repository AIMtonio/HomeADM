-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEICUENTASCLABPMORAL
DELIMITER ;
DROP TABLE IF EXISTS SPEICUENTASCLABPMORAL;
DELIMITER $$

CREATE TABLE SPEICUENTASCLABPMORAL (
	SpeiCuentaPMoralID		INT(11) 			NOT NULL 		COMMENT 'Numero de spei de la cuenta clabe',
	ClienteID				INT(11) 			NOT NULL 		COMMENT 'Numero del cliente',
	CuentaClabe				VARCHAR(18) 		DEFAULT NULL 	COMMENT 'Cuenta clabe del cliente',
	FechaCreacion			DATE 				DEFAULT NULL 	COMMENT 'Fecha en la que se creo la cuenta clabe',
	Estatus					CHAR(1) 			DEFAULT NULL 	COMMENT 'Estatus de la cuenta \nI = Inactiva, \nP = Proceso de autorizar, \nA = Autorizado, \nB = Baja',

	TipoInstrumento			CHAR(2)				DEFAULT NULL 	COMMENT 'Tipo de instrumento \nCH = Cuenta de ahorro',
	Instrumento				BIGINT(12) 			NOT NULL 		COMMENT 'Numero de instrumento',
	RazonSocial				VARCHAR(50)			NOT NULL		COMMENT 'Nombre del Cliente',
	EmpresaSTP				VARCHAR(15)			NOT NULL		COMMENT 'Nombre de la empresa con la que fue dada de alta la cuenta ante STP.',
	RFC						VARCHAR(18)			NOT NULL		COMMENT 'RFC del Cliente.',

	CURP					VARCHAR(18)			NOT NULL		COMMENT 'Clave Única de Registro de Población (CURP) del Cliente.',
	FechaConstitucion		DATE 				NOT NULL		COMMENT 'Tiempo especificado por el día, el mes y el año en que nació la persona.',
	ClavePaisSTP			INT(11)				NOT NULL		COMMENT 'Clave de Pais del Catalogo de STP',
	Firma					VARCHAR(1000)		NOT NULL		COMMENT 'Firma encriptada por la transferencia.',
	PIDTarea				VARCHAR(50)			NOT NULL		COMMENT 'ID del Hilo de tarea para el Demonio.',

	IDRespuesta				INT(11)				NOT NULL		COMMENT 'ID de la respuesta del WS de STP para registro de Cuenta Clabe persona fisica (0 = El proceso se ejecuto de manera correcta, > 0 Ocurrio un error durante el procesamiento)',
	DescripcionRespuesta	VARCHAR(256)		NOT NULL		COMMENT 'Descripcion de la respuesta del WS de STP para registro de Cuenta Clabe persona fisica',
	NumIntentos 			INT(11) 			NOT NULL 		COMMENT 'Numero de veces que se ha intentado realizar el alta de cuenta clabe a STP',
	Comentario				VARCHAR(300)		NOT NULL 		COMMENT 'Comentario de baja',

	EmpresaID 				INT(11) 			DEFAULT NULL 	COMMENT 'Campo de Auditoria',
	Usuario 				INT(11) 			DEFAULT NULL 	COMMENT 'Campo de Auditoria',
	FechaActual 			DATETIME 			DEFAULT NULL 	COMMENT 'Campo de Auditoria',
	DireccionIP 			VARCHAR(15) 		DEFAULT NULL 	COMMENT 'Campo de Auditoria',
	ProgramaID 				VARCHAR(50) 		DEFAULT NULL 	COMMENT 'Campo de Auditoria',
	Sucursal 				INT(11) 			DEFAULT NULL 	COMMENT 'Campo de Auditoria',
	NumTransaccion 			BIGINT(20) 			DEFAULT NULL 	COMMENT 'Campo de Auditoria',
	PRIMARY KEY (SpeiCuentaPMoralID),
	KEY `fk_SPEICUENTACLABEPMORAL_1` (ClienteID),
	CONSTRAINT `fk_SPEICUENTACLABEPMORAL_1` FOREIGN KEY (ClienteID) REFERENCES CLIENTES (ClienteID) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla de las cuentas clabes de personas morales para STP'$$
