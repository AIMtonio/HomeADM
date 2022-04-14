-- TMP_CLIENTES
DELIMITER ;
DROP TABLE IF EXISTS `TMP_CLIENTES`;
DELIMITER $$

CREATE TABLE `TMP_CLIENTES` (
  ID              BIGINT(20) NOT NULL  AUTO_INCREMENT   COMMENT 'Identificador de la tabla',
  PosicionID      INT(11) DEFAULT NULL    COMMENT 'Numero de la posicion',
  ClienteID       INT(11) DEFAULT NULL COMMENT 'Numero del cliente',
  CreditoID       BIGINT(20) DEFAULT NULL COMMENT 'Numero del credito',
  Fecha           DATE DEFAULT NULL COMMENT 'Fecha del proceso',
  Hora            TIME  DEFAULT NULL COMMENT 'hora del proceso',
  TipoMovs        CHAR(2) DEFAULT NULL COMMENT 'Tipo de movimiento',
  EstatusMov      CHAR(2) DEFAULT NULL COMMENT 'Estatus del movimiento', 
  EmpresaID       INT(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  Usuario         INT(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  FechaActual     DATETIME DEFAULT NULL COMMENT 'Campo de Auditoria',
  DireccionIP     VARCHAR(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  ProgramaID      VARCHAR(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  Sucursal        INT(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  NumTransaccion  BIGINT(20) DEFAULT NULL COMMENT 'Campo de Auditoria',

  PRIMARY KEY(ID),
  INDEX(PosicionID),
  INDEX(NumTransaccion),
  INDEX(ClienteID),
  INDEX(ClienteID, NumTransaccion),
  INDEX(ID, NumTransaccion)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: guarda el respaldo de BITACORAMOVSCRE'$$