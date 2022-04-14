-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPBITACORAMODIF
DELIMITER ;
DROP TABLE IF EXISTS `TMPBITACORAMODIF`;DELIMITER $$

CREATE TABLE `TMPBITACORAMODIF` (
  `FechaEvaluacion` date DEFAULT NULL,
  `TotalCambios` bigint(11) DEFAULT NULL,
  KEY `FechaEvaluacion` (`FechaEvaluacion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$