-- TMP_CLIENTESBAJ
DELIMITER ;
DROP TABLE IF EXISTS `TMP_CLIENTESBAJ`;
DELIMITER $$

CREATE TABLE `TMP_CLIENTESBAJ` (
  ID              BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT 'Identificador de la tabla',
  ClientesBajID   INT(11) DEFAULT NULL COMMENT 'Numero de la posicion',
  Cantidad        INT(11) DEFAULT NULL COMMENT 'Numero que se repiten los cliente',
  PosicionID      INT(11) DEFAULT NULL COMMENT 'Posicion del Cliente en la lista de cobro',
  ClienteID       INT(11) DEFAULT NULL COMMENT 'Numero de cliente',
  EmpresaID       INT(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  Usuario         INT(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  FechaActual     DATETIME DEFAULT NULL COMMENT 'Campo de Auditoria',
  DireccionIP     VARCHAR(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  ProgramaID      VARCHAR(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  Sucursal        INT(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  NumTransaccion  BIGINT(20) DEFAULT NULL COMMENT 'Campo de Auditoria',

  PRIMARY KEY(ID),
  INDEX(PosicionID),
  INDEX(ClienteID),
  INDEX(ClienteID, PosicionID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: guarda el respaldo de BITACORAMOVSCRE'$$