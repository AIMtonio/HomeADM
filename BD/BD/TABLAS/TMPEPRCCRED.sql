-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPEPRCCRED
DELIMITER ;
DROP TABLE IF EXISTS `TMPEPRCCRED`;DELIMITER $$

CREATE TABLE `TMPEPRCCRED` (
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Numero de Cliente\n',
  `Reserva` decimal(34,2) DEFAULT NULL,
  KEY `IDX_TMPEPRCCRED_1` (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$