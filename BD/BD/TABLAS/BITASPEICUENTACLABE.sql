-- BITASPEICUENTASCLABE
DELIMITER ;
DROP TABLE IF EXISTS BITASPEICUENTASCLABE;
DELIMITER $$

CREATE TABLE BITASPEICUENTASCLABE (
  ClienteID			INT(11) NOT NULL COMMENT 'Numero del cliente',
  CuentaClabe		VARCHAR(18) NOT NULL COMMENT 'Cuenta clabe del cliente',
  FechaCreacion		DATE DEFAULT NULL COMMENT 'Fecha en la que se creo la cuenta clabe',
  TipoPersona		CHAR(1) DEFAULT NULL COMMENT 'Tipo de persona \nF = Fisica, \nM = Moral',
  TipoInstrumento	CHAR(2)	DEFAULT NULL COMMENT 'Tipo de instrumento \nCH = Cuenta de ahorro, \nCR = Credito',
  Instrumento		BIGINT(12) NOT NULL COMMENT 'Numero de instrumento',
  EmpresaID 		INT(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  Usuario 			INT(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  FechaActual 		DATETIME DEFAULT NULL COMMENT 'Campo de Auditoria',
  DireccionIP 		VARCHAR(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  ProgramaID 		VARCHAR(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  Sucursal 			INT(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  NumTransaccion 	BIGINT(20) DEFAULT NULL COMMENT 'Campo de Auditoria'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena todas las cuentas clabe del spei para perona moral y fisica'$$
