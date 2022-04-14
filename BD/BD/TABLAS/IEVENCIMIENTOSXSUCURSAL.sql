-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- IEVENCIMIENTOSXSUCURSAL
DELIMITER ;
DROP TABLE IF EXISTS `IEVENCIMIENTOSXSUCURSAL`;DELIMITER $$

CREATE TABLE `IEVENCIMIENTOSXSUCURSAL` (
  `SUCURSAL` varchar(45) NOT NULL,
  `HOY` decimal(12,2) NOT NULL,
  `QUINCE` decimal(12,2) NOT NULL,
  `TREINTA` decimal(12,2) NOT NULL,
  `SESENTA` decimal(12,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$