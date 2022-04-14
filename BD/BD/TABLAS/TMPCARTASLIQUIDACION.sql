DELIMITER ;
DROP TABLE IF EXISTS TMPCARTASLIQUIDACION;

-- -----------------------------------------------------
-- Table TMPCARTASLIQUIDACION
-- -----------------------------------------------------

DELIMITER $$
CREATE TABLE TMPCARTASLIQUIDACION (
	ConsolidaCartaID	INT(11)		NOT NULL	COMMENT 'Folio de consolidación de créditos',
	CartaLiquidaID	 	INT(11)		NOT NULL	COMMENT 'ID Consecutivo de la tabla de Cartas Liquidación',
	RecursoCartaLiq		MEDIUMBLOB	NULL		COMMENT 'Guarda la Carta de liquidación en binario relacionadas con la consolidación',
	EmpresaID			INT(11)		NOT NULL	COMMENT 'Campo de Auditoria',
	Usuario				INT(11)		NOT NULL	COMMENT 'Campo de Auditoria',
	FechaActual			DATETIME	NOT NULL	COMMENT 'Campo de Auditoria',
	DireccionIP			VARCHAR(15) NOT NULL	COMMENT 'Campo de Auditoria',
	ProgramaID			VARCHAR(50) NOT NULL	COMMENT 'Campo de Auditoria',
	Sucursal			INT(11)		NOT NULL	COMMENT 'Campo de Auditoria',
	NumTransaccion		BIGINT(20)	NOT NULL	COMMENT 'Campo de Auditoria',
  PRIMARY KEY (	ConsolidaCartaID, CartaLiquidaID)
  ) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: Tabla temporal para las cartas de liquidacion internas relacionadas con el folio de consolidación'

$$