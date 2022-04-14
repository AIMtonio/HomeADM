-- Creacion de tabla NOMESQUEMATASACRED

DELIMITER ;

DROP TABLE IF EXISTS NOMESQUEMATASACRED;

DELIMITER $$

CREATE TABLE NOMESQUEMATASACRED (
	EsqTasaCredID	BIGINT(20)		NOT NULL	COMMENT 'Identificador de la tabla',
	CondicionCredID	 INT(11) 		NOT NULL 	COMMENT 'Identificador de la Condicion de Credito',
	SucursalID		VARCHAR(500)	NOT NULL	COMMENT 'Identificador de la SucursalID',
	TipoEmpleadoID	VARCHAR(500)	NOT NULL	COMMENT 'Indica el tipo de Empleado de Nomina que le aplicara el esquema',
	PlazoID			VARCHAR(5000)	NOT NULL	COMMENT 'Indica el plazo',
    MinCred			INT(11)			NOT NULL	COMMENT 'Indica el Minimo numeros de creditos',
	MaxCred			INT(11)			NOT NULL	COMMENT 'Indica el Maximo numeros de creditos',
	MontoMin		DECIMAL(12,2)	NOT NULL	COMMENT 'Indica el monto minimo del esquema de la tasa',
	MontoMax		DECIMAL(12,2)	NOT NULL	COMMENT 'Indica el monto maximo del esquema de la tasa',
	Tasa			DECIMAL(12,4)	NOT NULL	COMMENT 'Indica el valor que va a tener la tasa',
	EmpresaID		INT(11)			NOT NULL	COMMENT 'Parametro de Auditoria',
	Usuario			INT(11)			NOT NULL	COMMENT 'Parametro de Auditoria',
	FechaActual		DATETIME		NOT NULL	COMMENT 'Parametro de Auditoria',
	DireccionIP		VARCHAR(15)		NOT NULL	COMMENT 'Parametro de Auditoria',
	ProgramaID		VARCHAR(50)		NOT NULL	COMMENT 'Parametro de Auditoria',
	Sucursal		INT(11)			NOT NULL	COMMENT 'Parametro de Auditoria',
	NumTransaccion	BIGINT(20)		NOT NULL	COMMENT 'Parametro de Auditoria',
	PRIMARY KEY (EsqTasaCredID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para almacenar los esquemas de tasas de un credito'$$


