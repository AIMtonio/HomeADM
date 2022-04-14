-- TMPDESBLOQCOBRANZAREF
DELIMITER ;
DROP TABLE IF EXISTS TMPDESBLOQCOBRANZAREF;
DELIMITER $$

CREATE TABLE TMPDESBLOQCOBRANZAREF (
	DesbloqCobranzaRefID	INT(11) AUTO_INCREMENT COMMENT 'Numero o ID de la tabla de Parametros de web service credito Payment',
	CreditoID				BIGINT(12) NOT NULL COMMENT 'ID o Numero del credito',
	CuentaID				BIGINT(12) NOT NULL COMMENT 'ID o Numero de la cuenta de ahorro',
	SaldoExigible			DECIMAL(12,2) NOT NULL COMMENT 'Saldo exigible del credito',
	MontoBloqueado			DECIMAL(12,2) NOT NULL COMMENT 'Monto MontoBloqueado por Cobranza Referenciada credito',
	EmpresaID				INT(11) NULL COMMENT 'Parametro de Auditoria',
	Usuario					INT(11) NULL COMMENT 'Parametro de Auditoria',
	FechaActual				DATETIME NULL COMMENT 'Parametro de Auditoria',
	DireccionIP				VARCHAR(15) NULL COMMENT 'ID de la institucion Bancaria',
	ProgramaID				VARCHAR(50) NULL COMMENT 'Parametro de Auditoria',
	Sucursal				INT(11) NULL COMMENT 'Parametro de Auditoria',
	NumTransaccion			BIGINT(20) NULL COMMENT 'Parametro de Auditoria',
	PRIMARY KEY (DesbloqCobranzaRefID),
	INDEX(CreditoID),
	INDEX (CuentaID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla temporal que guarda la informacion de los creditos que tienen un bloqueo de cobranza Refenciado '$$

