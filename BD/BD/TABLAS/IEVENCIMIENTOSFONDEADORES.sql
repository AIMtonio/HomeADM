-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- IEVENCIMIENTOSFONDEADORES
DELIMITER ;
DROP TABLE IF EXISTS `IEVENCIMIENTOSFONDEADORES`;DELIMITER $$

CREATE TABLE `IEVENCIMIENTOSFONDEADORES` (
  `Sucursal` varchar(20) NOT NULL,
  `Fuente` varchar(20) NOT NULL,
  `HOY` decimal(12,2) NOT NULL,
  `QUINCE` decimal(12,2) NOT NULL,
  `TREINTA` decimal(12,2) NOT NULL,
  `SESENTA` decimal(12,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$