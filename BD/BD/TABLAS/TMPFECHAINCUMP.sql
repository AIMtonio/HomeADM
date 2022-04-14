-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPFECHAINCUMP
DELIMITER ;
DROP TABLE IF EXISTS `TMPFECHAINCUMP`;DELIMITER $$

CREATE TABLE `TMPFECHAINCUMP` (
  `CreditoIDSAFI` bigint(20) NOT NULL,
  `Incumplimiento` date DEFAULT NULL,
  KEY `CreditoIDSAFI` (`CreditoIDSAFI`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$