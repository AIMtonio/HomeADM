-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPAVALESLISTA
DELIMITER ;
DROP TABLE IF EXISTS `TMPAVALESLISTA`;DELIMITER $$

CREATE TABLE `TMPAVALESLISTA` (
  `SolCred` varchar(30) DEFAULT NULL,
  `CredID` varchar(30) DEFAULT NULL,
  `IdentificaAV` char(2) DEFAULT NULL,
  `RFCAV` varchar(13) DEFAULT NULL,
  `CURPAV` varchar(18) DEFAULT NULL,
  `NumDunAV` varchar(10) DEFAULT NULL,
  `CompaniaAV` varchar(75) DEFAULT NULL,
  `PrimerNombreAV` varchar(75) DEFAULT NULL,
  `SegundoNombreAV` varchar(75) DEFAULT NULL,
  `ApePaternoAV` varchar(25) DEFAULT NULL,
  `ApeMaternoAV` varchar(25) DEFAULT NULL,
  `PriLinDireccionAV` varchar(40) DEFAULT NULL,
  `SegLinDireccionAV` varchar(40) DEFAULT NULL,
  `ColoniaAV` varchar(60) DEFAULT NULL,
  `MunicipioAV` varchar(40) DEFAULT NULL,
  `CiudadAV` varchar(40) DEFAULT NULL,
  `EstadoAV` varchar(4) DEFAULT NULL,
  `CPAV` varchar(10) DEFAULT NULL,
  `TelefonoAV` varchar(11) DEFAULT NULL,
  `ExtTelefonoAV` varchar(8) DEFAULT NULL,
  `FaxAV` varchar(11) DEFAULT NULL,
  `TipoClienteAV` varchar(1) DEFAULT NULL,
  `EdoExtranjeroAV` varchar(40) DEFAULT NULL,
  `PaisAV` char(2) DEFAULT NULL,
  `CadenaAval` text,
  `NumAvales` int(11) DEFAULT NULL,
  `ClienteID` int(11) DEFAULT NULL,
  `AvalID` int(11) DEFAULT NULL,
  `ProspectoID` int(11) DEFAULT NULL,
  KEY `TMPAVALESLISTA1` (`SolCred`),
  KEY `TMPAVALESLISTA2` (`CredID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$