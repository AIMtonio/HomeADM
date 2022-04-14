-- TMPANALISTASOLPROD
DELIMITER ;
DROP TABLE IF EXISTS TMPANALISTASOLPROD;

DELIMITER $$

CREATE TABLE TMPANALISTASOLPROD(
	Transaccion				BIGINT		NOT NULL	COMMENT 'Numero de Transaccion de la Operacion',
	Consecutivo				INT 		NOT NULL	COMMENT	'Consecutivo de Registro',
	UsuarioID				INT(11)		NOT NULL	COMMENT 'Identificador del Analista ',
    SolicitudCreditoID		INT(11)		NOT NULL	COMMENT	'Numero de Canceladas por analista en el periodo',
    Estatus					CHAR(1)		NOT NULL	COMMENT 'Estatus',
    FechaAsignacion			DATETIME	NOT NULL	COMMENT 'Fecha Final del reporte',
    
	EmpresaID				INT(11)		NULL	COMMENT	'Parametro de auditoria',
    Usuario					INT(11)		NULL	COMMENT	'Parametro de auditoria',
    FechaActual				DATETIME	NULL	COMMENT	'Parametro de auditoria',
    DireccionIP				VARCHAR(15)	NULL	COMMENT	'Parametro de auditoria',
    ProgramaID				VARCHAR(50)	NULL	COMMENT	'Parametro de auditoria',
    Sucursal				INT(11)		NULL	COMMENT	'Parametro de auditoria',
    NumTransaccion			BIGINT(20)	NULL	COMMENT	'Parametro de auditoria',
    PRIMARY KEY (Transaccion,Consecutivo),
    INDEX TMPANALISTASOLPROD (UsuarioID)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Temporal parcial para reporte productividad analistas'$$

