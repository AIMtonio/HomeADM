-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPAVALSTAFE
DELIMITER ;
DROP TABLE IF EXISTS `TMPAVALSTAFE`;DELIMITER $$

CREATE TABLE `TMPAVALSTAFE` (
  `ConsecutivoID` bigint(12) DEFAULT NULL,
  `ClienteID` int(11) DEFAULT NULL,
  `AvalID` int(11) DEFAULT NULL,
  `ProspectoID` int(11) DEFAULT NULL,
  `SolicitudCreditoID` int(11) DEFAULT NULL,
  `NombreCompleto` varchar(200) DEFAULT '',
  `Domicilio` varchar(200) DEFAULT '',
  `Telefono` varchar(20) DEFAULT '',
  `RFC` varchar(20) DEFAULT '',
  `CorreoElect` varchar(100) DEFAULT '',
  `CURP` varchar(20) DEFAULT '',
  `DocIdentificacion` varchar(100) DEFAULT '',
  `MontoCredito` decimal(18,2) DEFAULT '0.00',
  `CreditoID` bigint(12) DEFAULT NULL,
  KEY `ConsecutivoID` (`ConsecutivoID`),
  KEY `ClienteID` (`ClienteID`),
  KEY `AvalID` (`AvalID`),
  KEY `ProspectoID` (`ProspectoID`),
  KEY `SolicitudCreditoID` (`SolicitudCreditoID`),
  KEY `CreditoID` (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$