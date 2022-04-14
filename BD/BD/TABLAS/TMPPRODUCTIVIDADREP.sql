-- TMPPRODUCTIVIDADREP
DELIMITER ;
DROP TABLE IF EXISTS TMPPRODUCTIVIDADREP;

DELIMITER $$

CREATE TABLE TMPPRODUCTIVIDADREP(
	Transaccion				BIGINT		NOT NULL	COMMENT 'Numero de Transaccion de la Operacion',
	UsuarioID				INT(11)		NOT NULL	COMMENT 'Numero de Usuario Analista ',
    Asignadas		 		INT			NOT NULL	COMMENT 'Numero de Solicitudes Asignadas',
    Revision		 		INT			NOT NULL	COMMENT 'Numero de Solicitudes en Revision',
    Devueltas		 		INT			NOT NULL	COMMENT 'Numero de Solicitudes Devueltas',
    Canceladas		 		INT			NOT NULL	COMMENT 'Numero de Solicitudes Canceladas',
    Rechazadas		 		INT			NOT NULL	COMMENT 'Numero de Solicitudes Rechazadas',
    Autorizadas		 		INT			NOT NULL	COMMENT 'Numero de Solicitudes Autorizadas',
    PendientesGlo			DECIMAL(16,2) NOT NULL	COMMENT 'Numero de Pendientes Global',
    AutorizadasGlo			DECIMAL(16,2) NOT NULL	COMMENT 'Numero de Autorizadas Global',
    PendientesInd			DECIMAL(16,2) NOT NULL	COMMENT 'Numero de Pendientes Individual',
    TerminadasInd			DECIMAL(16,2) NOT NULL	COMMENT 'Numero de Terminadas Individual',
    TipoRegistro			CHAR(1)		NOT NULL	COMMENT 'Tipo R- Registro, T - Totales',
    
	EmpresaID				INT(11)		NULL	COMMENT	'Parametro de auditoria',
    Usuario					INT(11)		NULL	COMMENT	'Parametro de auditoria',
    FechaActual				DATETIME	NULL	COMMENT	'Parametro de auditoria',
    DireccionIP				VARCHAR(15)	NULL	COMMENT	'Parametro de auditoria',
    ProgramaID				VARCHAR(50)	NULL	COMMENT	'Parametro de auditoria',
    Sucursal				INT(11)		NULL	COMMENT	'Parametro de auditoria',
    NumTransaccion			BIGINT(20)	NULL	COMMENT	'Parametro de auditoria',
    PRIMARY KEY (Transaccion,UsuarioID),
    INDEX TMPPRODUCTIVIDADREP (UsuarioID)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Temporal parcial para reporte productividad analistas'$$

