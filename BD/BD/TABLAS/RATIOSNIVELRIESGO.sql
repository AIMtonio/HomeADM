-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RATIOSNIVELRIESGO
DELIMITER ;
DROP TABLE IF EXISTS `RATIOSNIVELRIESGO`;DELIMITER $$

CREATE TABLE `RATIOSNIVELRIESGO` (
  `NivelRiesgoID` int(11) NOT NULL,
  `Descripcion` varchar(500) DEFAULT NULL COMMENT 'Indica la Descripcion del Nivel del Ratios (Normal, Potencial, Deficiente, Alto, Moderado)',
  `RangoInferior` decimal(14,2) DEFAULT NULL COMMENT 'indica el porcentaje minimo inferior  indicado para ese nivel',
  `RangoSuperior` decimal(14,2) DEFAULT NULL COMMENT 'indica el porcentaje maximo  indicado para ese nivel',
  PRIMARY KEY (`NivelRiesgoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Parametrizacion de  niveles de Riesgo para el calcu'$$