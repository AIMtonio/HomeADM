DELIMITER ;
DROP TABLE IF EXISTS TMPCIRCULOCREDSALDOSCERO;

DELIMITER $$
CREATE TABLE TMPCIRCULOCREDSALDOSCERO(
	CreditoID				BIGINT(12)			NOT NULL COMMENT 'Identificador del numero de credito',
	EmpresaID				INT(11)				NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
	Usuario					INT(11)				NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
	FechaActual				DATETIME			NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
	DireccionIP				VARCHAR(15)			NOT NULL COMMENT 'Parametro de auditoria Direccion IP',
	ProgramaID				VARCHAR(50)			NOT NULL COMMENT 'Parametro de auditoria Programa',
	Sucursal				INT(11)				NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
	NumTransaccion			BIGINT(20)			NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
	PRIMARY KEY(CreditoID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla para considerar que creditos se reportan con ceros saldos en el reporte de circulo de credito.'$$