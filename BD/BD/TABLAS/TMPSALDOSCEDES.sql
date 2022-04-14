-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPSALDOSCEDES
DELIMITER ;
DROP TABLE IF EXISTS `TMPSALDOSCEDES`;DELIMITER $$

CREATE TABLE `TMPSALDOSCEDES` (
  `FechaCorte` date NOT NULL,
  `CedeID` int(11) NOT NULL,
  `TipoCedeID` int(11) NOT NULL,
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
  KEY `FechaCorte` (`FechaCorte`,`CedeID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$