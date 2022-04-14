-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPAVALSTAFEPAG
DELIMITER ;
DROP TABLE IF EXISTS `TMPAVALSTAFEPAG`;DELIMITER $$

CREATE TABLE `TMPAVALSTAFEPAG` (
  `ConsecutivoID` bigint(12) DEFAULT NULL,
  `ClienteID` int(11) DEFAULT NULL,
  `AvalID` int(11) DEFAULT NULL,
  `ProspectoID` int(11) DEFAULT NULL,
  `SolicitudCreditoID` int(11) DEFAULT NULL,
  `NombreCompleto` varchar(500) DEFAULT '',
  `Domicilio` varchar(500) DEFAULT '',
  `Telefono` varchar(500) DEFAULT '',
  `CreditoID` bigint(12) DEFAULT NULL,
  KEY `ConsecutivoID` (`ConsecutivoID`),
  KEY `ClienteID` (`ClienteID`),
  KEY `AvalID` (`AvalID`),
  KEY `ProspectoID` (`ProspectoID`),
  KEY `SolicitudCreditoID` (`SolicitudCreditoID`),
  KEY `CreditoID` (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$