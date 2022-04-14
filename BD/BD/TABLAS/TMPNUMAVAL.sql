-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPNUMAVAL
DELIMITER ;
DROP TABLE IF EXISTS `TMPNUMAVAL`;DELIMITER $$

CREATE TABLE `TMPNUMAVAL` (
  `SolCred` varchar(30) DEFAULT NULL,
  `NumAval` int(11) DEFAULT NULL,
  KEY `SolCred` (`SolCred`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$