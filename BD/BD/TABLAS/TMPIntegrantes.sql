-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPIntegrantes
DELIMITER ;
DROP TABLE IF EXISTS `TMPIntegrantes`;DELIMITER $$

CREATE TABLE `TMPIntegrantes` (
  `IntegranteID` int(11) NOT NULL AUTO_INCREMENT,
  `ClienteID` int(11) DEFAULT NULL,
  `SolicitudCreditoID` int(11) DEFAULT NULL,
  `Nombre` varchar(200) DEFAULT NULL,
  `ApellidoPaterno` varchar(100) DEFAULT NULL,
  `ApellidoMaterno` varchar(100) DEFAULT NULL,
  `MontoCredito` decimal(14,2) DEFAULT NULL,
  PRIMARY KEY (`IntegranteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$