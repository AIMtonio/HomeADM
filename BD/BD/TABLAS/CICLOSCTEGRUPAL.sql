DELIMITER ;
DROP TABLE IF EXISTS CICLOSCTEGRUPAL;
DELIMITER $$

CREATE TABLE CICLOSCTEGRUPAL(
	ClienteID				INT(11)			NOT NULL	COMMENT 'ID del Cliente de la tabla de CLIENTES',
	ProspectoID				INT(11)			NOT NULL	COMMENT 'ID del Prospecto de la tabla PROSPECTOS',
	CicloBase				INT(11)			NOT NULL	COMMENT 'Ciclo actual del cliente',
	EmpresaID				INT(11)			NOT NULL	COMMENT 'Parametro de auditoria ID de la empresa',
	Usuario					INT(11)			NOT NULL	COMMENT 'Parametro de auditoria ID del usuario',
	FechaActual				DATETIME		NOT NULL	COMMENT 'Parametro de auditoria Fecha actual',
	DireccionIP				VARCHAR(15)		NOT NULL	COMMENT 'Parametro de auditoria Direccion IP',
	ProgramaID				VARCHAR(50)		NOT NULL	COMMENT 'Parametro de auditoria Programa',
	Sucursal				INT(11)			NOT NULL	COMMENT 'Parametro de auditoria ID de la sucursal',
	NumTransaccion			BIGINT(20)		NOT NULL	COMMENT 'Numero de la transaccion',
PRIMARY KEY (ClienteID,ProspectoID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para almacenar ciclos de los clientes y prospectos'$$