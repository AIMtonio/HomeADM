-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RATIOSPORCLASIF
DELIMITER ;
DROP TABLE IF EXISTS `RATIOSPORCLASIF`;DELIMITER $$

CREATE TABLE `RATIOSPORCLASIF` (
  `RatiosPorClasifID` int(11) NOT NULL COMMENT 'id de la tabla',
  `RatiosClasificaConID` int(11) DEFAULT NULL COMMENT 'Foranea de la tabla RATIOSCLASIFICACON',
  `Descripcion` varchar(500) DEFAULT NULL COMMENT 'Descripcion del valor a Ponderar',
  `Porcentaje` decimal(14,2) DEFAULT NULL COMMENT 'Porcentaje Maximo a obtener por cada valor a Ponderar',
  PRIMARY KEY (`RatiosPorClasifID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Parametrizacion para indicar el procentaje maximo q'$$