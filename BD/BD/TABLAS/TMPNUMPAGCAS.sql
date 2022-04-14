-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPNUMPAGCAS
DELIMITER ;
DROP TABLE IF EXISTS `TMPNUMPAGCAS`;DELIMITER $$

CREATE TABLE `TMPNUMPAGCAS` (
  `CreditoID` bigint(20) NOT NULL,
  `NumPagosAtr` int(11) DEFAULT NULL,
  KEY `CreditoID` (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$