-- Creacion de tabla TMPSALDOPROMINSTRUM

DELIMITER ;

DROP TABLE IF EXISTS TMPSALDOPROMINSTRUM;

DELIMITER $$

CREATE TABLE `TMPSALDOPROMINSTRUM` (
  `ConsecutivoID` 		BIGINT(12) 		UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Numero Consecutivo Saldo Instrumento',
  `ClienteID` 			INT(11) 		NOT NULL COMMENT 'Numero de Cliente',
  `TipoInstrumentoID` 	INT(11) 		NOT NULL COMMENT 'Tipo de Instrumento\n13 = INVERSION\n28 = CEDE\n31 = APORTACION',
  `InstrumentoID` 		BIGINT(12) 		NOT NULL COMMENT 'Numero de Instrumento(INVERSION,CEDE,APORTACION)',
  `Monto` 				DECIMAL(18,2) 	NOT NULL COMMENT 'Monto del Instrumento',
  `FechaInicio` 		DATE			NOT NULL COMMENT 'Fecha de Inicio del Instrumento',
  `FechaVencimiento` 	DATE 			NOT NULL COMMENT 'Fecha de Vencimiento del Instrumento',
  `Dias` 				INT(11) 		NOT NULL COMMENT 'Dias del Instrumento en el Ejercicio',
  `SaldoPromedio` 		DECIMAL(18,2) 	NOT NULL COMMENT 'Saldo Promedio del Instrumento en el Ejercicio',
  `EmpresaID`           INT(11)         NOT NULL COMMENT 'Parametro de Auditoria',
  `Usuario`             INT(11)         NOT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual`         DATETIME        NOT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP`         VARCHAR(15)     NOT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID`          VARCHAR(50)     NOT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal`            INT(11)         NOT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion`      BIGINT(20)      NOT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`ConsecutivoID`),
  KEY `INDEX_TMPSALDOPROMINSTRUM_1` (`ClienteID`),
  KEY `INDEX_TMPSALDOPROMINSTRUM_2` (`TipoInstrumentoID`),
  KEY `INDEX_TMPSALDOPROMINSTRUM_3` (`InstrumentoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla temporal para el Registro de Saldos Promedios de las INVERSIONES. CEDES y APORTACIONES en el anio'$$
