-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RATIOSCONCEPTOS
DELIMITER ;
DROP TABLE IF EXISTS `RATIOSCONCEPTOS`;DELIMITER $$

CREATE TABLE `RATIOSCONCEPTOS` (
  `RatiosConceptosID` int(11) NOT NULL COMMENT 'ID de la Tabla',
  `Descripcion` varchar(500) DEFAULT NULL COMMENT 'Descripcion de los conceptos de Ratios(CARACTER, CAPITAL, CONDICIONES, CAPACIDAD DE PAGO, ETC)',
  `Porcentaje` decimal(12,2) DEFAULT NULL COMMENT 'Indica el Puntaje asignado a cada uno de los Conceptos',
  PRIMARY KEY (`RatiosConceptosID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Parametros donde se indica el porcentaje que le cor'$$