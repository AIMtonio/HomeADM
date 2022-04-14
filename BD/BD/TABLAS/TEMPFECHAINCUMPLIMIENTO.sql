-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TEMPFECHAINCUMPLIMIENTO
DELIMITER ;
DROP TABLE IF EXISTS `TEMPFECHAINCUMPLIMIENTO`;DELIMITER $$

CREATE TABLE `TEMPFECHAINCUMPLIMIENTO` (
  `CreditoID` bigint(12) NOT NULL,
  `FechaIncumple` date DEFAULT NULL,
  `DiasAtraso` int(11) DEFAULT NULL,
  PRIMARY KEY (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$