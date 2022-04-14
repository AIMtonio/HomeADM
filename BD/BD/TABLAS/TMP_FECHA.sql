-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMP_FECHA
DELIMITER ;
DROP TABLE IF EXISTS `TMP_FECHA`;DELIMITER $$

CREATE TABLE `TMP_FECHA` (
  `FechaEncIni` date DEFAULT NULL,
  `FechaEncFin` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$