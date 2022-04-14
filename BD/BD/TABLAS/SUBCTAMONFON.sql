-- SUBCTAMONFON
DELIMITER ;
DROP TABLE IF EXISTS SUBCTAMONFON;
DELIMITER $$

CREATE TABLE SUBCTAMONFON (
  ConceptoFonID		INT(11) NOT NULL COMMENT 'ID del Concepto de Fondeo une con tabla (CONCEPTOSFONDEO)',
  TipoFondeo		CHAR(1) NOT NULL COMMENT 'Indica el tipo de Fondeador INVERSIONISTA(I)/FONDEADOR(F)',
  MonedaID			INT(11) NOT NULL COMMENT 'ID de la Moneda (Tabla MONEDAS)',
  SubCuenta			VARCHAR(6) DEFAULT NULL COMMENT 'Sub Clasificacion contable',
  EmpresaID			INT(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  Usuario			INT(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  FechaActual		DATETIME DEFAULT NULL COMMENT 'Campo de Auditoria',
  DireccionIP		VARCHAR(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  ProgramaID		VARCHAR(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  Sucursal			INT(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  NumTransaccion 	BIGINT(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (ConceptoFonID, TipoFondeo, MonedaID),
  KEY `fk_SUBCTAMONFON_1` (MonedaID),
  CONSTRAINT `fk_SUBCTAMONFON_1` FOREIGN KEY (MonedaID) REFERENCES MONEDAS (MonedaID) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT=''$$
