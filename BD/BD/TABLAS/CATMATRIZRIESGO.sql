-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATMATRIZRIESGO
DELIMITER ;
DROP TABLE IF EXISTS `CATMATRIZRIESGO`;DELIMITER $$

CREATE TABLE `CATMATRIZRIESGO` (
  `CodigoMatriz` int(11) NOT NULL COMMENT 'Codigo identificador del conjunto de valores de la matriz',
  `ConceptoMatrizID` tinyint(4) NOT NULL COMMENT 'ID del concepto de la matriz de riesgo',
  `Concepto` varchar(50) NOT NULL COMMENT 'Concepto/Variable que se evaluara en la matriz',
  `Descripcion` varchar(150) NOT NULL COMMENT 'Descripcion del Concepto a evaluar',
  `Valor` smallint(6) NOT NULL COMMENT 'Valor asignado a la Variable',
  `LimiteValida` tinyint(4) NOT NULL COMMENT 'Limite de operaciones a validar para Insuales y Reelevantes',
  `Grupo` varchar(16) NOT NULL COMMENT 'Define para que operaciones se evaluara el concepto',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoMatrizID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de la Matriz de Riesgos, contiene los conceptos a evaluar y el valor ponderado'$$