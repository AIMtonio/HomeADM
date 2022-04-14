-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALCULOINTERESREAL
DELIMITER ;
DROP TABLE IF EXISTS `CALCULOINTERESREAL`;
DELIMITER $$

	CREATE TABLE `	` (
  `Fecha`             DATE          NOT NULL                  COMMENT 'Fecha Registro informacion para el calculo del Interes Real',
  `Anio`         	  INT(11)       NOT NULL                  COMMENT 'Anio del calculo',
  `Mes`         	  INT(11)       NOT NULL                  COMMENT 'Mes del calculo',
  `ClienteID`         INT(11)       NOT NULL                  COMMENT 'Numero de Cliente',
  `TipoInstrumentoID` INT(11)       NOT NULL                  COMMENT 'Tipo de Instrumento:\n2 = Cuentas\n13 = Inversiones',
  `InstrumentoID`     BIGINT(12)    NOT NULL                  COMMENT 'Numero de Instrumento',
  `Monto`             DECIMAL(18,2) NOT NULL DEFAULT '0.00'   COMMENT 'Monto del instrumento',
  `FechaInicio`       DATE          NOT NULL                  COMMENT 'Fecha de inicio para el calculo del interes real',
  `FechaFin`          DATE          NOT NULL                  COMMENT 'Fecha final para el calculo del interes real',
  `InteresGenerado`   DECIMAL(18,2) NOT NULL DEFAULT '0.00'   COMMENT 'Interes Generado',
  `ISR`               DECIMAL(18,2) NOT NULL DEFAULT '0.00'   COMMENT 'Impuesto Retenido',
  `TasaInteres`       DECIMAL(14,4) NOT NULL DEFAULT '0.0000' COMMENT 'Tasa de Interes',
  `Ajuste`            DECIMAL(18,2) NOT NULL DEFAULT '0.00'   COMMENT 'Valor Ajuste',
  `InteresReal`       DECIMAL(18,2) NOT NULL DEFAULT '0.00'   COMMENT 'Valor Interes Real',
  `Estatus`           CHAR(1)       DEFAULT NULL              COMMENT 'Estatus Calculo Interes Real:\nC = Calculado\nN = No calculado',
  `FechaCalculo`      DATE          NOT NULL      COMMENT 'Fecha del calculo del Interes Real',
  `EmpresaID`         INT(11)       DEFAULT NULL  COMMENT 'Parametro de Auditoria',
  `Usuario`           INT(11)       DEFAULT NULL  COMMENT 'Parametro de Auditoria',
  `FechaActual`       DATETIME      DEFAULT NULL  COMMENT 'Parametro de Auditoria',
  `DireccionIP`       VARCHAR(15)   DEFAULT NULL  COMMENT 'Parametro de Auditoria',
  `ProgramaID`        VARCHAR(50)   DEFAULT NULL  COMMENT 'Parametro de Auditoria',
  `Sucursal`          INT(11)       DEFAULT NULL  COMMENT 'Parametro de Auditoria',
  `NumTransaccion`    BIGINT(20)    DEFAULT NULL  COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`Fecha`,`ClienteID`,`TipoInstrumentoID`,`InstrumentoID`),
  KEY `IDX_CALCULOINTERESREAL_1` (`ClienteID`),
  KEY `IDX_CALCULOINTERESREAL_2` (`Fecha`),
  KEY `IDX_CALCULOINTERESREAL_3` (`TipoInstrumentoID`),
  KEY `IDX_CALCULOINTERESREAL_4` (`InstrumentoID`),
  KEY `IDX_CALCULOINTERESREAL_5` (`Estatus`),
  KEY `IDX_CALCULOINTERESREAL_6` (`Anio`),
  KEY `IDX_CALCULOINTERESREAL_7` (`Mes`),
  CONSTRAINT `fk_Cliente_1` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_TipoInstrumento_1` FOREIGN KEY (`TipoInstrumentoID`) REFERENCES `TIPOINSTRUMENTOS` (`TipoInstrumentoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para el registro del calculo de Interes Real'$$