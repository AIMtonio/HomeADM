-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISCALINTERESREAL
DELIMITER ;
DROP TABLE IF EXISTS `HISCALINTERESREAL`;
DELIMITER $$


CREATE TABLE `HISCALINTERESREAL` (
  `Fecha` date NOT NULL COMMENT 'Fecha Registro informacion para el calculo del Interes Real',
  `Anio` int(11) NOT NULL DEFAULT '0' COMMENT 'Anio del calculo',
  `Mes` int(11) NOT NULL DEFAULT '0' COMMENT 'Mes del calculo',
  `ClienteID` int(11) NOT NULL COMMENT 'Numero de Cliente',
  `TipoInstrumentoID` int(11) NOT NULL COMMENT 'Tipo de Instrumento:\n2 = Cuentas\n13 = Inversiones\n28 = Cedes',
  `InstrumentoID` bigint(12) NOT NULL COMMENT 'Numero de Instrumento',
  `Monto` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT 'Monto del instrumento',
  `FechaInicio` date NOT NULL COMMENT 'Fecha de inicio para el calculo del interes real',
  `FechaFin` date NOT NULL COMMENT 'Fecha final para el calculo del interes real',
  `InteresGenerado` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT 'Interes Generado',
  `ISR` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT 'Impuesto Retenido',
  `TasaInteres` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT 'Tasa de Interes',
  `Ajuste` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT 'Valor Ajuste',
  `InteresReal` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT 'Valor Interes Real',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus Calculo Interes Real:\nC = Calculado\nN = No calculado',
  `FechaCalculo` date NOT NULL COMMENT 'Fecha del calculo del Interes Real',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`Fecha`,`ClienteID`,`TipoInstrumentoID`,`InstrumentoID`),
  KEY `IDX_HISCALINTERESREAL_1` (`ClienteID`),
  KEY `IDX_HISCALINTERESREAL_2` (`Fecha`),
  KEY `IDX_HISCALINTERESREAL_3` (`TipoInstrumentoID`),
  KEY `IDX_HISCALINTERESREAL_4` (`InstrumentoID`),
  KEY `IDX_HISCALINTERESREAL_5` (`Estatus`),
  KEY `IDX_HISCALINTERESREAL_6` (`Anio`),
  KEY `IDX_HISCALINTERESREAL_7` (`Mes`),
  CONSTRAINT `fk_HISCALINTERESREAL_1` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_HISCALINTERESREAL_2` FOREIGN KEY (`TipoInstrumentoID`) REFERENCES `TIPOINSTRUMENTOS` (`TipoInstrumentoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para el registro historico del calculo de Interes Real'$$