-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONCEPTOSREGREP
DELIMITER ;
DROP TABLE IF EXISTS `CONCEPTOSREGREP`;DELIMITER $$

CREATE TABLE `CONCEPTOSREGREP` (
  `ConceptoID` int(11) NOT NULL COMMENT 'Llave primaria de la tabla',
  `ReporteID` varchar(20) NOT NULL COMMENT 'Identificador del reporte ej. A2021 u otro valor con el que se identifique el reporte',
  `Descripcion` varchar(500) DEFAULT '' COMMENT 'Descripcion del concepto',
  `CuentaCNBV` varchar(100) DEFAULT '' COMMENT 'Indica el numero de cuenta de la CNBV que ira en el reporte csv',
  `CuentaContable` varchar(500) DEFAULT '' COMMENT 'Indica la cuenta contable o el grupo de cuentas contables',
  `FormulaSaldo` varchar(100) DEFAULT '' COMMENT 'Formula para calcular el saldo (para los campos que lo requieran)',
  `FormulaSaldoProm` varchar(100) DEFAULT '' COMMENT 'Formula para calcular el saldo promedio (para los campos que lo requieran)',
  `FormulaIndicador` varchar(100) DEFAULT '' COMMENT 'Formula pra calcular indicador (para los campos que lo requieren)',
  `DescripcionEsNegrita` char(1) DEFAULT 'N' COMMENT 'Indica si la fuenta para el concepto es en negritas S=si, N=no',
  `SaldoEsNegrita` char(1) DEFAULT 'N' COMMENT 'Indica si la fuente del saldo es negrita S=si, N=no',
  `IndicadorEsNegrita` char(1) DEFAULT 'N' COMMENT 'Indica si la fuente del Indicador es negrita S=si, N=no',
  `ColorCeldaSaldo` char(1) DEFAULT 'N' COMMENT 'Color background de la celda para el Saldo S=si, N=no',
  `ColorCeldaSaldoProm` char(1) DEFAULT 'N' COMMENT 'Saldo calculado del concepto',
  `ColorCeldaIndicador` char(1) DEFAULT 'N' COMMENT 'Color background de la celda para el indicador S=si, N=no',
  `Concepto` varchar(12) DEFAULT NULL,
  `ClaveConcepto` varchar(12) DEFAULT NULL,
  `ClasifRegID` int(11) DEFAULT NULL COMMENT 'ID de la clasificacion para regulatorios',
  `ClaveConceptoCap` varchar(45) DEFAULT NULL,
  `Version` int(11) NOT NULL COMMENT 'Año del reporte',
  PRIMARY KEY (`ConceptoID`,`ReporteID`,`Version`),
  KEY `CONCEPTOSREGREP_IDX1` (`ReporteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena los conceptos y sus caracteristicas mostrados en los reportes regulatorios de contabilidad'$$