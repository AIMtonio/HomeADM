-- TMPPRODUCTIVIDASUM
DELIMITER ;
DROP TABLE IF EXISTS TMPPRODUCTIVIDASUM;

DELIMITER $$

CREATE TABLE TMPPRODUCTIVIDASUM(
	Transaccion				BIGINT		NOT NULL	COMMENT 'Numero de Transaccion de la Operacion',
	UsuarioID				INT(11)		NOT NULL	COMMENT 'Numero de Usuario Analista ',
    Devueltas		 		INT			NOT NULL	COMMENT 'Numero de Solicitudes Devueltas',
    Canceladas		 		INT			NOT NULL	COMMENT 'Numero de Solicitudes Canceladas',
    Rechazadas		 		INT			NOT NULL	COMMENT 'Numero de Solicitudes Rechazadas',
    Autorizadas		 		INT			NOT NULL	COMMENT 'Numero de Solicitudes Autorizadas',
    
	EmpresaID				INT(11)		NULL	COMMENT	'Parametro de auditoria',
    Usuario					INT(11)		NULL	COMMENT	'Parametro de auditoria',
    FechaActual				DATETIME	NULL	COMMENT	'Parametro de auditoria',
    DireccionIP				VARCHAR(15)	NULL	COMMENT	'Parametro de auditoria',
    ProgramaID				VARCHAR(50)	NULL	COMMENT	'Parametro de auditoria',
    Sucursal				INT(11)		NULL	COMMENT	'Parametro de auditoria',
    NumTransaccion			BIGINT(20)	NULL	COMMENT	'Parametro de auditoria',
    PRIMARY KEY (Transaccion,UsuarioID),
    INDEX TMPPRODUCTIVIDASUM (UsuarioID)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Temporal parcial para reporte productividad analistas'$$

