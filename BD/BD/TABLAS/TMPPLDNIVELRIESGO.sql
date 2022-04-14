-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPPLDNIVELRIESGO
DELIMITER ;
DROP TABLE IF EXISTS `TMPPLDNIVELRIESGO`;DELIMITER $$

CREATE TABLE `TMPPLDNIVELRIESGO` (
  `ConceptoMatrizID` int(11) NOT NULL COMMENT 'ID del concepto de la matriz de riesgo CATMATRIZRIESGO.',
  `Concepto` varchar(50) NOT NULL COMMENT 'Concepto/Variable que se evaluara en la matriz.',
  `Descripcion` varchar(150) NOT NULL COMMENT 'Descripcion del Concepto a evaluar.',
  `PonderadoMatriz` smallint(6) NOT NULL COMMENT 'Valor asignado al Concepto.',
  `Limite` tinyint(4) NOT NULL COMMENT 'Limite de operaciones a validar para Insuales y Reelevantes.',
  `CumpleCriterio` char(1) NOT NULL COMMENT 'Cumple el Criterio Si o No.',
  `PuntajeObtenido` varchar(50) NOT NULL COMMENT 'Puntaje Obtenido.',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Numero de transaccion.',
  PRIMARY KEY (`ConceptoMatrizID`,`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla temporal que almacena la evaluacion del nivel de riesgo por transacción por cliente.'$$