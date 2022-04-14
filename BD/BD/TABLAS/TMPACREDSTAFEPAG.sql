-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPACREDSTAFEPAG
DELIMITER ;
DROP TABLE IF EXISTS `TMPACREDSTAFEPAG`;DELIMITER $$

CREATE TABLE `TMPACREDSTAFEPAG` (
  `ConsecutivoID` bigint(12) DEFAULT NULL,
  `ClienteID` int(11) DEFAULT NULL,
  `SolicitudCreditoID` int(11) DEFAULT NULL,
  `NombreCompleto` varchar(500) DEFAULT '',
  `Domicilio` varchar(500) DEFAULT '',
  `Telefono` varchar(500) DEFAULT '',
  `CreditoIDInt` bigint(12) DEFAULT NULL,
  `CreditoID` bigint(12) DEFAULT NULL,
  KEY `ConsecutivoID` (`ConsecutivoID`),
  KEY `ClienteID` (`ClienteID`),
  KEY `SolicitudCreditoID` (`SolicitudCreditoID`),
  KEY `CreditoIDInt` (`CreditoIDInt`),
  KEY `CreditoID` (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$