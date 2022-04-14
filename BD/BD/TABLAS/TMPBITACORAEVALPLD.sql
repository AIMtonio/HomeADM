-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPBITACORAEVALPLD
DELIMITER ;
DROP TABLE IF EXISTS `TMPBITACORAEVALPLD`;DELIMITER $$

CREATE TABLE `TMPBITACORAEVALPLD` (
  `FechaEvaluacion` date DEFAULT NULL,
  `TotalRegistros` bigint(11) DEFAULT NULL,
  `TotalCambios` bigint(11) DEFAULT NULL,
  KEY `FechaEvaluacion` (`FechaEvaluacion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$