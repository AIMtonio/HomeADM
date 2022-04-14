-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATCLASIFREPREG
DELIMITER ;
DROP TABLE IF EXISTS `CATCLASIFREPREG`;DELIMITER $$

CREATE TABLE `CATCLASIFREPREG` (
  `ClasifRegID` int(11) NOT NULL COMMENT 'ID o Numero de la Clasificación de Rep Regulatorios',
  `ReporteID` int(11) DEFAULT NULL COMMENT 'Numero de Reporte',
  `ClaveReporte` varchar(10) DEFAULT NULL COMMENT 'Clave de Reporte',
  `TipoReporte` char(1) DEFAULT NULL COMMENT 'Tipo de Reporte [Indica si el reporte va desglosado o englobado en conceptos grales\\nA .- Analitico o Desglosado\\nC .- Conceptos Generales',
  `Concepto` char(12) DEFAULT NULL COMMENT 'Concepto  [para cálculos]',
  `ClaveConcepto` varchar(12) DEFAULT NULL COMMENT 'Clave de Concepto [para reporte]',
  `Descripcion` varchar(50) DEFAULT NULL COMMENT 'Descripcion',
  `PrioridadConc` int(11) DEFAULT NULL COMMENT 'Nivel de prioridad en clasificación',
  `TipoConcepto` char(1) DEFAULT NULL COMMENT 'Tipo de concepto\\n1 – Clasificación\\n2 - Suma',
  `AplSector` char(1) DEFAULT NULL COMMENT 'Aplica clasificación por sector económico\\nS .- Si Aplica\\nN .- No Aplica',
  `AplActividad` char(1) DEFAULT NULL COMMENT 'Aplica clasificación por actividad\\nS .- Si Aplica\\nN .- No Aplica',
  `AplProducto` char(1) DEFAULT NULL COMMENT 'Aplica clasificación por producto\\\\nS .- Si Aplica\\\\nN .- No Aplica',
  `AplTipoPersona` char(1) DEFAULT NULL COMMENT 'F, E, M vacio para todas\\nS .- Si Aplica\\nN .- No Aplica',
  `Segmento` char(1) DEFAULT NULL COMMENT 'C . Comercial\nO .- Consumo\nH .- Hipotecario',
  `ClasifConta` varchar(20) DEFAULT NULL COMMENT 'Clasificacion Contable de Acuerdo al SITI',
  `ClavePorDestino` varchar(20) DEFAULT NULL COMMENT 'Clave por Destino de Acuerdo al SITI',
  `ClasifContaVenc` varchar(24) DEFAULT NULL COMMENT 'Clasificacion Contable Vencido',
  PRIMARY KEY (`ClasifRegID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de conceptos para Reportes Regulatorios'$$