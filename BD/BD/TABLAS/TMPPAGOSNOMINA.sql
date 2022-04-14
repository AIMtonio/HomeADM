-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPPAGOSNOMINA
DELIMITER ;
DROP TABLE IF EXISTS `TMPPAGOSNOMINA`;DELIMITER $$

CREATE TABLE `TMPPAGOSNOMINA` (
  `ClienteID` int(11) DEFAULT NULL,
  `FechaAplicacion` date DEFAULT NULL,
  `InstitNominaID` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$