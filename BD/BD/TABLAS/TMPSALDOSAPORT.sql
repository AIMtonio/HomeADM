-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPSALDOSAPORT
DELIMITER ;
DROP TABLE IF EXISTS `TMPSALDOSAPORT`;DELIMITER $$

CREATE TABLE `TMPSALDOSAPORT` (
  `FechaCorte` date NOT NULL,
  `AportacionID` int(11) NOT NULL,
  `TipoAportacionID` int(11) NOT NULL,
  `SaldoCapital` decimal(16,2) NOT NULL DEFAULT '0.00',
  `SaldoIntProvision` decimal(14,2) NOT NULL DEFAULT '0.00',
  `Estatus` char(1) NOT NULL,
  `TasaFija` decimal(14,4) DEFAULT NULL,
  `TasaISR` decimal(12,4) DEFAULT NULL,
  `InteresGenerado` decimal(12,2) DEFAULT '0.00',
  `InteresRecibir` decimal(12,2) DEFAULT '0.00',
  `InteresRetener` decimal(12,2) DEFAULT '0.00',
  `TasaBase` int(11) DEFAULT NULL,
  `SobreTasa` decimal(12,4) DEFAULT '0.0000',
  KEY `FechaCorte` (`FechaCorte`,`AportacionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$