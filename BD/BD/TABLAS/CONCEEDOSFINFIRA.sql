-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONCEEDOSFINFIRA
DELIMITER ;
DROP TABLE IF EXISTS `CONCEEDOSFINFIRA`;DELIMITER $$

CREATE TABLE `CONCEEDOSFINFIRA` (
  `EstadoFinanID` int(11) NOT NULL COMMENT 'ID del Reporte Financiero, corresponde a TIPOSESTADOSFINAN.',
  `ConceptoFinanID` int(11) NOT NULL COMMENT 'ID del Concepto Financiero',
  `NumClien` int(11) NOT NULL DEFAULT '0' COMMENT 'Identificador del Cliente',
  `ConsecutivoID` int(11) NOT NULL DEFAULT '0' COMMENT 'Número consecutivo de los conceptos.',
  `Descripcion` varchar(300) NOT NULL COMMENT 'Descripcion del Concepto Financiero',
  `Desplegado` varchar(300) NOT NULL COMMENT 'Desplegado a Mostrar en el Reporte',
  `CuentaContable` varchar(500) NOT NULL COMMENT 'Rango de Cuentas que Integran el Concepto Financiero',
  `EsCalculado` char(1) DEFAULT NULL COMMENT 'Indica si es un Campo calculado(Con formulas)\nS .- SI\nN .- NO',
  `TipoCalculo` char(1) DEFAULT NULL COMMENT 'Indica si es una suma o resta\nS.- Suma\nR.- Resta',
  `NombreCampo` varchar(20) DEFAULT NULL COMMENT 'Nombre del Campo, para el select dinamico ',
  `Espacios` int(11) DEFAULT NULL COMMENT 'Numero  columnas vacias que se dejaran antes de pintar la cadena',
  `Negrita` char(1) DEFAULT NULL COMMENT 'Indica si la cadena se pintara como Negrita\n"S" = Si\n"N" = No',
  `Sombreado` char(1) DEFAULT NULL COMMENT 'Indica si la cadena ira sombreada en el valor \n"S" = Si\n"N" = No',
  `CombinarCeldas` int(11) DEFAULT NULL COMMENT 'Indica el numero de celdas que se combinaran',
  `CuentaFija` varchar(45) DEFAULT NULL COMMENT 'Cuenta Fija que requiere el reporte regulatorio.',
  `Presentacion` char(1) DEFAULT NULL COMMENT 'Presentación del saldo en Positivo o Negativo:\nP : Positivo ( Se muestra el valor absoluto)\nN: Negativo (Se muestra el saldo con signo negativo)\nC: Contable ( Se muestra el saldo con el signo obtenido de la agrupación contable + ó - )',
  `Tipo` char(1) DEFAULT NULL COMMENT 'Tipo:\nE: Encabezado de un grupo de conceptos\nD: Detalle, concepto que no continene subcuentas en el reporte.\nO: Para los encabezados que se omite la sumatorio de sus subcuentas.\nI:  Para conceptos que requieren Formula contable, o que no se deben tomar en cuenta para la sumatoria.',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  PRIMARY KEY (`EstadoFinanID`,`ConceptoFinanID`,`NumClien`,`ConsecutivoID`),
  KEY `fk_CONCEEDOSFINFIRA_1` (`EstadoFinanID`),
  KEY `CONCEEDOSFINFIRA_IDX_1` (`EstadoFinanID`,`EsCalculado`,`NumClien`,`NumTransaccion`),
  KEY `CONCEEDOSFINFIRA_IDX_2` (`EstadoFinanID`,`ConceptoFinanID`,`NumClien`,`NumTransaccion`),
  KEY `CONCEEDOSFINFIRA_IDX_3` (`EstadoFinanID`,`ConceptoFinanID`,`NumClien`),
  KEY `CONCEEDOSFINFIRA_IDX_4` (`EstadoFinanID`,`NumClien`),
  CONSTRAINT `fk_CONCEEDOSFINFIRA_1` FOREIGN KEY (`EstadoFinanID`) REFERENCES `TIPOSESTADOSFINAN` (`EstadoFinanID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Conceptos que Integran los Estados Financieros FIRA.'$$