-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPGARPRENDSTAFE
DELIMITER ;
DROP TABLE IF EXISTS `TMPGARPRENDSTAFE`;DELIMITER $$

CREATE TABLE `TMPGARPRENDSTAFE` (
  `GarantiaID` int(11) DEFAULT NULL,
  `ClienteID` int(11) DEFAULT NULL,
  `ProspectoID` int(11) DEFAULT NULL,
  `SolicitudCreditoID` int(11) DEFAULT NULL,
  `ProductoCreditoID` int(11) DEFAULT NULL,
  `NombreCompleto` varchar(500) DEFAULT '',
  `Domicilio` varchar(500) DEFAULT '',
  `Telefono` varchar(500) DEFAULT '',
  `RFC` varchar(20) DEFAULT '',
  `CorreoElect` varchar(100) DEFAULT '',
  `CURP` varchar(20) DEFAULT '',
  `DocIdentificacion` varchar(100) DEFAULT '',
  `MontoCredito` decimal(18,2) DEFAULT '0.00',
  `CreditoID` bigint(12) DEFAULT NULL,
  `TipoGarantiaID` int(11) DEFAULT NULL,
  `TipoDocumentoID` int(11) DEFAULT NULL,
  `TipoDocumento` varchar(100) DEFAULT '',
  `Folio` varchar(100) DEFAULT '',
  `FechaRegistro` date DEFAULT '1900-01-01',
  `ObservacionesGar` varchar(1300) DEFAULT '',
  KEY `ClienteID` (`ClienteID`),
  KEY `GarantiaID` (`GarantiaID`),
  KEY `ProspectoID` (`ProspectoID`),
  KEY `SolicitudCreditoID` (`SolicitudCreditoID`),
  KEY `ProductoCreditoID` (`ProductoCreditoID`),
  KEY `CreditoID` (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$