-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPEXISIGPERIODO
DELIMITER ;
DROP TABLE IF EXISTS `TMPEXISIGPERIODO`;DELIMITER $$

CREATE TABLE `TMPEXISIGPERIODO` (
  `CreditoID` bigint(20) NOT NULL,
  `AmortizacionID` int(11) DEFAULT NULL,
  `ExigibleSigPeriodo` decimal(16,2) DEFAULT NULL,
  KEY `TMPEXISIGPERIODO_1` (`CreditoID`),
  KEY `TMPEXISIGPERIODO_2` (`CreditoID`,`AmortizacionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$