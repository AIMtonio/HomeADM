-- Creacion de tabla TMPCTERELAPORTANTE

DELIMITER ;

DROP TABLE IF EXISTS TMPCTERELAPORTANTE;

DELIMITER $$

CREATE TABLE `TMPCTERELAPORTANTE` (
  `ConsecutivoID` 		BIGINT(12) 		UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Numero Consecutivo de Relacionados',
  `ClienteID` 			INT(11) 		NOT NULL COMMENT 'Numero de Cliente',
  `EmpresaID`           INT(11)         NULL COMMENT 'Parametro de Auditoria',
  `Usuario`             INT(11)         NULL COMMENT 'Parametro de Auditoria',
  `FechaActual`         DATETIME        NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP`         VARCHAR(15)     NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID`          VARCHAR(50)     NULL COMMENT 'Parametro de Auditoria',
  `Sucursal`            INT(11)         NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion`      BIGINT(20)      NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`ConsecutivoID`),
  KEY `INDEX_TMPCTERELAPORTANTE_1` (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla temporal para obtener informacion de clientes relacionados fiscales como Aportante'$$
