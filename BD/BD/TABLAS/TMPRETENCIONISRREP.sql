-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPRETENCIONISRREP
DELIMITER ;
DROP TABLE IF EXISTS `TMPRETENCIONISRREP`;DELIMITER $$

CREATE TABLE `TMPRETENCIONISRREP` (
  `ClienteID` int(11) DEFAULT NULL,
  `NombreCompleto` varchar(200) DEFAULT NULL,
  `RFC` varchar(20) DEFAULT NULL,
  `CURP` char(20) DEFAULT NULL,
  `MontoInversion` decimal(12,2) DEFAULT NULL,
  `Plazo` int(11) DEFAULT NULL,
  `MontoISR` decimal(12,2) DEFAULT NULL,
  `FechaInicio` date DEFAULT NULL,
  `FechaVencimiento` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$