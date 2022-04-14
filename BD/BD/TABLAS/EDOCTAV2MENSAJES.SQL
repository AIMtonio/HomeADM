DELIMITER ;
DROP TABLE IF EXISTS EDOCTAV2MENSAJES;
DELIMITER $$

CREATE TABLE EDOCTAV2MENSAJES (
	SucursalID		INT(11)		NOT NULL COMMENT 'Numero de sucursal para la cual se mostraran los valores de las columnas en el estado de cuenta',
	TipoPersona		CHAR(1)		NOT NULL COMMENT 'Indica el tipo de persona para el cual se mostraran los valores de las columnas en el estado de cuenta. F - Fisica, A - Fisica con act. empresarial, M - Moral',
	Mensaje1		TEXT		NOT NULL COMMENT 'Texto del primer mensaje',
	Mensaje2		TEXT		NOT NULL COMMENT 'Texto del segundo mensaje',
	Mensaje3		TEXT		NOT NULL COMMENT 'Texto del tercer mensaje',
	Mensaje4		TEXT		NOT NULL COMMENT 'Texto del cuarto mensaje',
	Mensaje5		TEXT		NOT NULL COMMENT 'Texto del quinto mensaje',
	EmpresaID 		INT(11) 	NOT NULL COMMENT 'Campo de Auditoria',
	Usuario			INT(11) 	NOT NULL COMMENT 'Campo de Auditoria',
	FechaActual		DATETIME 	NOT NULL COMMENT 'Campo de Auditoria',
	DireccionIP		VARCHAR(15)	NOT NULL COMMENT 'Campo de Auditoria',
	ProgramaID 		VARCHAR(50) NOT NULL COMMENT 'Campo de Auditoria',
	Sucursal		INT(11) 	NOT NULL COMMENT 'Campo de Auditoria',
	NumTransaccion	BIGINT(20)	NOT NULL COMMENT 'Campo de Auditoria',
	PRIMARY KEY (TipoPersona, SucursalID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Mensajes Generales para los Estados de Cuenta'$$
