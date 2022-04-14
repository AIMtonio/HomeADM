-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPAVALYOBLI
DELIMITER ;
DROP TABLE IF EXISTS `TMPAVALYOBLI`;DELIMITER $$

CREATE TABLE `TMPAVALYOBLI` (
  `ConsecutivoID` int(11) DEFAULT NULL,
  `SolicitudCreditoID` int(11) DEFAULT NULL,
  `NombreCompleto` varchar(200) DEFAULT '',
  `Domicilio` varchar(200) DEFAULT '',
  `Telefono` varchar(20) DEFAULT '',
  `RFC` varchar(20) DEFAULT '',
  `CorreoElect` varchar(100) DEFAULT '',
  `CURP` varchar(20) DEFAULT '',
  `DocIdentificacion` varchar(100) DEFAULT '',
  `CreditoID` bigint(12) DEFAULT NULL,
  KEY `SolicitudCreditoID` (`SolicitudCreditoID`),
  KEY `CreditoID` (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$