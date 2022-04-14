-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RATIOSCLASIFICACON
DELIMITER ;
DROP TABLE IF EXISTS `RATIOSCLASIFICACON`;DELIMITER $$

CREATE TABLE `RATIOSCLASIFICACON` (
  `RatiosClasificaConID` int(11) NOT NULL COMMENT 'ID de la tabla	',
  `RatiosConceptosID` int(11) DEFAULT NULL COMMENT 'FK de tabla RATIOSCONCEPTOS ',
  `Descripcion` varchar(500) DEFAULT NULL COMMENT 'Descripcion de los valores a Ponderar para cada uno de los conceptos del Ratios',
  `Porcentaje` decimal(14,2) DEFAULT NULL COMMENT 'Indica el Puntaje asignado a cada uno de los valores a ponderar para los concepto del ratios',
  PRIMARY KEY (`RatiosClasificaConID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Parametrizacion para indicar el porcentaje maximo q'$$