-- TMPBLOQDESBLOQUEO
DELIMITER ;
DROP TABLE IF EXISTS TMPBLOQDESBLOQUEO;
DELIMITER $$

CREATE TABLE TMPBLOQDESBLOQUEO (
	TmpBloqDesbloqueoID		INT(11) AUTO_INCREMENT COMMENT 'Numero o ID de la tabla',
	BloqueoID				BIGINT(12) NOT NULL COMMENT 'ID o Numero del credito',
	CuentaAhoID				BIGINT(12) NOT NULL COMMENT 'ID o Numero de la cuenta de ahorro',
	MontoBloq				DECIMAL(12,2) NOT NULL COMMENT 'Monto MontoBloqueado por Cobranza Referenciada credito',
	Referencia				BIGINT(20) NOT NULL COMMENT 'Referencia del folio de bloqueo',
	EmpresaID				INT(11) NULL COMMENT 'Parametro de Auditoria',
	Usuario					INT(11) NULL COMMENT 'Parametro de Auditoria',
	FechaActual				DATETIME NULL COMMENT 'Parametro de Auditoria',
	DireccionIP				VARCHAR(15) NULL COMMENT 'ID de la institucion Bancaria',
	ProgramaID				VARCHAR(50) NULL COMMENT 'Parametro de Auditoria',
	Sucursal				INT(11) NULL COMMENT 'Parametro de Auditoria',
	NumTransaccion			BIGINT(20) NULL COMMENT 'Parametro de Auditoria',
	PRIMARY KEY (TmpBloqDesbloqueoID),
	INDEX(BloqueoID),
	INDEX (CuentaAhoID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla temporal Para Guardar la Informcion de los folios de Bloqueos '$$

