-- Creacion de tabla TMPINTERESISRINVER

DELIMITER ;

DROP TABLE IF EXISTS TMPINTERESISRINVER;

DELIMITER $$

CREATE TABLE `TMPINTERESISRINVER` (
  `ConsecutivoID`       BIGINT(12) 		UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Numero Consecutivo',
  `ClienteID` 			INT(11) 		NOT NULL COMMENT 'Numero de Cliente',
  `InversionID` 		BIGINT(12) 		NOT NULL COMMENT 'Numero de Inversion',
  `InteresGravado`   	DECIMAL(18,2) 	NOT NULL COMMENT 'Interes Gravado',
  `InteresExento`     	DECIMAL(18,2) 	NOT NULL COMMENT 'Interes Exento',
  `InteresRetener`    	DECIMAL(18,2) 	NOT NULL COMMENT 'Interes Retenido',
  `EmpresaID`           INT(11)         NOT NULL COMMENT 'Parametro de Auditoria',
  `Usuario`             INT(11)         NOT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual`         DATETIME        NOT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP`         VARCHAR(15)     NOT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID`          VARCHAR(50)     NOT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal`            INT(11)         NOT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion`      BIGINT(20)      NOT NULL COMMENT 'Parametro de Auditoria',
   PRIMARY KEY (`ConsecutivoID`),
   KEY `INDEX_TMPINTERESISRINVER_1` (`ConsecutivoID`),
   KEY `INDEX_TMPINTERESISRINVER_2` (`ClienteID`),
   KEY `INDEX_TMPINTERESISRINVER_3` (`InversionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla temporal para registrar los intereses y retenciones de las inversiones vencidas en el Anio'$$
