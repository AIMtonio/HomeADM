-- Creacion de tabla FOLIOSCTACANCEL

DELIMITER ;

DROP TABLE IF EXISTS `FOLIOSCTACANCEL`;

CREATE TABLE `FOLIOSCTACANCEL`(
  `FolioClabeID`    VARCHAR(18)  NOT NULL    COMMENT 'Folio o consecutivo',
  `CreditoID`	    BIGINT(20)   NULL      	 COMMENT 'Credito al que le pertenecia la cuenta clabe',
  `EmpresaID`       INT(11)      NULL      	 COMMENT 'AUDITORIA',
  `Usuario`         INT(11)      NULL      	 COMMENT 'AUDITORIA',
  `FechaActual`     DATETIME     NULL      	 COMMENT 'AUDITORIA',
  `DireccionIP`     VARCHAR(15)  NULL      	 COMMENT 'AUDITORIA',
  `ProgramaID`      VARCHAR(50)  NULL      	 COMMENT 'AUDITORIA',
  `Sucursal`        INT(11)      NULL      	 COMMENT 'AUDITORIA',
  `NumTransaccion`  BIGINT(20)   NULL      	 COMMENT 'AUDITORIA',
  PRIMARY KEY(FolioClabeID)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para almacenar las cuentas clabes de creditos eliminados.';