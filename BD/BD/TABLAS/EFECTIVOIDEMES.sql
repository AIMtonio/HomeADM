-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EFECTIVOIDEMES
DELIMITER ;
DROP TABLE IF EXISTS `EFECTIVOIDEMES`;DELIMITER $$

CREATE TABLE `EFECTIVOIDEMES` (
  `ClienteID` int(11) DEFAULT NULL,
  `CuentaAhoID` bigint(20) DEFAULT NULL,
  `Fecha` date DEFAULT NULL,
  `NatMovimiento` char(1) DEFAULT NULL,
  `Abono` decimal(14,2) DEFAULT NULL,
  `Cargo` decimal(14,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$