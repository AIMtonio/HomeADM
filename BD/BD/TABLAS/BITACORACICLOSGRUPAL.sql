DELIMITER ;
DROP TABLE IF EXISTS BITACORACICLOSGRUPAL;
DELIMITER $$

CREATE TABLE BITACORACICLOSGRUPAL(
	RegistroID				INT(11)			NOT NULL	COMMENT 'Consecutivo general de la tabla',
	GrupoID					INT(11)			NOT NULL	COMMENT 'ID del Cliente de la tabla de CLIENTES',
	FechaRegistro			DATE			NOT NULL	COMMENT 'Fecha de Registro',
	EmpresaID				INT(11)			NOT NULL	COMMENT 'Parametro de auditoria ID de la empresa',
	Usuario					INT(11)			NOT NULL	COMMENT 'Parametro de auditoria ID del usuario',
	FechaActual				DATETIME		NOT NULL	COMMENT 'Parametro de auditoria Fecha actual',
	DireccionIP				VARCHAR(15)		NOT NULL	COMMENT 'Parametro de auditoria Direccion IP',
	ProgramaID				VARCHAR(50)		NOT NULL	COMMENT 'Parametro de auditoria Programa',
	Sucursal				INT(11)			NOT NULL	COMMENT 'Parametro de auditoria ID de la sucursal',
	NumTransaccion			BIGINT(20)		NOT NULL	COMMENT 'Numero de la transaccion',
PRIMARY KEY (RegistroID),
KEY INDEX_BITACORACICLOSGRUPAL_1(GrupoID,FechaRegistro)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla bitacora para almacenar los grupos de registros que realizaron cambios de ciclos'$$