-- Creacion de tabla TMPCALCULOINTERESREAL

DELIMITER ;

DROP TABLE IF EXISTS TMPCALCULOINTERESREAL;

DELIMITER $$

CREATE TABLE `TMPCALCULOINTERESREAL` (
  `ConsecutivoID`       INT(11)         NOT NULL COMMENT 'ID Consecutivo',
  `Fecha` 				DATE			NOT NULL COMMENT 'Fecha Registro informacion para el calculo del Interes Real',
  `Anio` 		    	INT(11)			NOT NULL COMMENT 'Anio de Registro para el calculo del Interes Real',
  `Mes` 		    	INT(11)			NOT NULL COMMENT 'Mes de Registro para el calculo del Interes Real',
  `ClienteID` 			INT(11) 		NOT NULL COMMENT 'Numero de Cliente',
  `TipoInstrumentoID` 	INT(11) 		NOT NULL COMMENT 'Tipo de Instrumento:\n2 = Cuentas\n13 = Inversiones',
  `InstrumentoID` 		BIGINT(12) 		NOT NULL COMMENT 'Numero de Instrumento',
  `Monto` 				DECIMAL(18,2) 	NOT NULL COMMENT 'Monto del Instrumento',
  `FechaInicio`			DATE 			NOT NULL COMMENT 'Fecha de Inicio para el calculo del interes real',
  `FechaFin`			DATE 			NOT NULL COMMENT 'Fecha Final para el calculo del interes real',
  `EmpresaID`           INT(11)         NOT NULL COMMENT 'Parametro de Auditoria',
  `Usuario`             INT(11)         NOT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual`         DATETIME        NOT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP`         VARCHAR(15)     NOT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID`          VARCHAR(50)     NOT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal`            INT(11)         NOT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion`      BIGINT(20)      NOT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`ConsecutivoID`),
  KEY `INDEX_TMPCALCULOINTERESREAL_1` (`ConsecutivoID`,`Fecha`,`ClienteID`,`TipoInstrumentoID`,`InstrumentoID`),
  KEY `INDEX_TMPCALCULOINTERESREAL_2` (`Fecha`),
  KEY `INDEX_TMPCALCULOINTERESREAL_3` (`ClienteID`),
  KEY `INDEX_TMPCALCULOINTERESREAL_4` (`TipoInstrumentoID`),
  KEY `INDEX_TMPCALCULOINTERESREAL_5` (`InstrumentoID`),
  KEY `INDEX_TMPCALCULOINTERESREAL_6` (`Anio`),
  KEY `INDEX_TMPCALCULOINTERESREAL_7` (`Mes`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla temporal para el calculo del Interes Real'$$
