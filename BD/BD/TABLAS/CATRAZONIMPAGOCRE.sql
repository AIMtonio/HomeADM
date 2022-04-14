-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATRAZONIMPAGOCRE
DELIMITER ;
DROP TABLE IF EXISTS `CATRAZONIMPAGOCRE`;
DELIMITER $$

CREATE TABLE `CATRAZONIMPAGOCRE` (
  CatRazonImpagoCreID   INT(11) NOT NULL COMMENT 'Numero de la razon impago',
  Descripcion           VARCHAR(500) NOT NULL COMMENT 'Descripcion de la razon impago',
  Estatus               CHAR(1) NOT NULL COMMENT 'estatus de la razon impago \n A: Activo \nI: Inactivo',
  Usuario               INT(11) NOT NULL COMMENT 'Parametro de Auditoria',
  FechaActual           DATETIME NOT NULL COMMENT 'Parametro de Auditoria',
  DireccionIP           VARCHAR(15) NOT NULL COMMENT 'Parametro de Auditoria',
  ProgramaID            VARCHAR(50) NOT NULL COMMENT 'Parametro de Auditoria',
  Sucursal              INT(11) NOT NULL COMMENT 'Parametro de Auditoria',
  NumTransaccion        BIGINT(20) NOT NULL COMMENT 'Parametro de Auditoria',

  PRIMARY KEY (CatRazonImpagoCreID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cat: Catalogo de Razones de no pago de Credito para el WS de Pago de Credito.'$$