-- Creacion de tabla TMPINVERVENCIDAS

DELIMITER ;

DROP TABLE IF EXISTS TMPINVERVENCIDAS;

DELIMITER $$

CREATE TABLE `TMPINVERVENCIDAS` (
  `ConsecutivoID`       BIGINT(12) 		UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Numero Consecutivo',
  `Fecha` 				DATE			NOT NULL COMMENT 'Fecha de Registro',
  `ClienteID` 			INT(11) 		NOT NULL COMMENT 'Numero de Cliente',
  `TipoInstrumentoID` 	INT(11) 		NOT NULL COMMENT 'Tipo de Instrumento:\n13 = Inversiones',
  `InversionID` 		BIGINT(12) 		NOT NULL COMMENT 'Numero de Inversion',
  `Monto` 				DECIMAL(18,2) 	NOT NULL COMMENT 'Monto del Instrumento',
  `FechaInicio`			DATE 			NOT NULL COMMENT 'Fecha de Inicio de la Inversion',
  `FechaVencimiento`	DATE 			NOT NULL COMMENT 'Fecha de Vencimiento de la Inversion',
  `InteresGravado`   	DECIMAL(18,2) 	NOT NULL COMMENT 'Interes Gravado',
  `InteresExento`     	DECIMAL(18,2) 	NOT NULL COMMENT 'Interes Exento',
  `InteresRetener`    	DECIMAL(18,2) 	NOT NULL COMMENT 'Interes Retenido',
  `TasaInteres`       	DECIMAL(14,4) 	NOT NULL DEFAULT '0.0000' COMMENT 'Tasa de Interes',
  `EmpresaID`           INT(11)         NOT NULL COMMENT 'Parametro de Auditoria',
  `Usuario`             INT(11)         NOT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual`         DATETIME        NOT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP`         VARCHAR(15)     NOT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID`          VARCHAR(50)     NOT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal`            INT(11)         NOT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion`      BIGINT(20)      NOT NULL COMMENT 'Parametro de Auditoria',
   PRIMARY KEY (`ConsecutivoID`,`Fecha`,`ClienteID`,`TipoInstrumentoID`,`InversionID`),
   KEY `INDEX_TMPINVERVENCIDAS_1` (`ConsecutivoID`),
   KEY `INDEX_TMPINVERVENCIDAS_2` (`Fecha`),
   KEY `INDEX_TMPINVERVENCIDAS_3` (`ClienteID`),
   KEY `INDEX_TMPINVERVENCIDAS_4` (`TipoInstrumentoID`),
   KEY `INDEX_TMPINVERVENCIDAS_5` (`InversionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla temporal de las inversiones vencidas en el Anio'$$
