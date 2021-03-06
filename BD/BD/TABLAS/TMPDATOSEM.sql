-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPDATOSEM
DELIMITER ;
DROP TABLE IF EXISTS `TMPDATOSEM`;DELIMITER $$

CREATE TABLE `TMPDATOSEM` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ClienteID` int(11) DEFAULT NULL,
  `IdentificaEM` char(2) DEFAULT NULL,
  `RFC` varchar(13) DEFAULT NULL,
  `CURP` varchar(18) DEFAULT NULL,
  `NumDun` varchar(10) DEFAULT NULL,
  `Compania` varchar(75) DEFAULT NULL,
  `PrimerNombre` varchar(75) DEFAULT NULL,
  `SegundoNombre` varchar(75) DEFAULT NULL,
  `ApePaterno` varchar(25) DEFAULT NULL,
  `ApeMaterno` varchar(25) DEFAULT NULL,
  `Nacionalidad` char(2) DEFAULT NULL,
  `CalifCartera` char(2) DEFAULT NULL,
  `ActEconomica1` varchar(11) DEFAULT NULL,
  `ActEconomica2` varchar(11) DEFAULT NULL,
  `ActEconomica3` varchar(11) DEFAULT NULL,
  `PriLinDireccion` varchar(40) DEFAULT NULL,
  `SegLinDireccion` varchar(40) DEFAULT NULL,
  `Colonia` varchar(60) DEFAULT NULL,
  `Municipio` varchar(40) DEFAULT NULL,
  `Ciudad` varchar(40) DEFAULT NULL,
  `Estado` char(4) DEFAULT NULL,
  `CP` varchar(10) DEFAULT NULL,
  `Telefono` varchar(11) DEFAULT NULL,
  `ExtTelefono` varchar(8) DEFAULT NULL,
  `Fax` varchar(11) DEFAULT NULL,
  `TipoCliente` int(1) DEFAULT NULL,
  `EdoExtranjero` varchar(40) DEFAULT NULL,
  `Pais` char(2) DEFAULT NULL,
  `ClaveConsolida` varchar(8) DEFAULT NULL,
  `IdentificaAC` char(2) DEFAULT NULL,
  `RFCAC` varchar(13) DEFAULT NULL,
  `CURPAC` varchar(18) DEFAULT NULL,
  `NumDunAC` varchar(10) DEFAULT NULL,
  `CompaniaAC` varchar(75) DEFAULT NULL,
  `PrimerNombreAC` varchar(75) DEFAULT NULL,
  `SegundoNombreAC` varchar(75) DEFAULT NULL,
  `ApePaternoAC` varchar(25) DEFAULT NULL,
  `ApeMaternoAC` varchar(25) DEFAULT NULL,
  `PorcentajeAC` char(2) DEFAULT NULL,
  `PriLinDireccionAC` varchar(40) DEFAULT NULL,
  `SegLinDireccionAC` varchar(40) DEFAULT NULL,
  `ColoniaAC` varchar(60) DEFAULT NULL,
  `MunicipioAC` varchar(40) DEFAULT NULL,
  `CiudadAC` varchar(40) DEFAULT NULL,
  `EstadoAC` varchar(4) DEFAULT NULL,
  `CPAC` varchar(10) DEFAULT NULL,
  `TelefonoAC` varchar(11) DEFAULT NULL,
  `ExtTelefonoAC` varchar(8) DEFAULT NULL,
  `FaxAC` varchar(11) DEFAULT NULL,
  `TipoClienteAC` varchar(1) DEFAULT NULL,
  `EdoExtranjeroAC` varchar(40) DEFAULT NULL,
  `PaisAC` char(2) DEFAULT NULL,
  `IdentificaCR` char(2) DEFAULT NULL,
  `RFCCR` varchar(13) DEFAULT NULL,
  `NumExpeCred` varchar(6) DEFAULT NULL,
  `ContratoCR` varchar(25) DEFAULT NULL,
  `CreditoIDAnt` varchar(20) DEFAULT NULL,
  `FechaInicio` varchar(8) DEFAULT NULL,
  `Plazo` decimal(6,2) DEFAULT NULL,
  `TipoCredito` varchar(4) DEFAULT NULL,
  `SaldoInicial` int(20) DEFAULT NULL,
  `Moneda` text,
  `NumPagos` int(4) DEFAULT NULL,
  `FrecuenciaPag` varchar(4) DEFAULT NULL,
  `ImportePago` int(20) DEFAULT NULL,
  `FechaUltPago` varchar(8) DEFAULT NULL,
  `FechaReestru` varchar(8) DEFAULT NULL,
  `PagoEfectivo` varchar(20) DEFAULT NULL,
  `FechaLiquida` varchar(8) DEFAULT NULL,
  `Quita` varchar(20) DEFAULT NULL,
  `Dacion` varchar(20) DEFAULT NULL,
  `Quebranto` varchar(20) DEFAULT NULL,
  `ClaveObserva` varchar(4) DEFAULT NULL,
  `CredEspecial` char(1) DEFAULT NULL,
  `FechaPrimerIn` varchar(8) DEFAULT NULL,
  `SaldoInsoluto` int(20) DEFAULT NULL,
  `IdentificaDE` char(2) DEFAULT NULL,
  `RFCDE` varchar(13) DEFAULT NULL,
  `Contrato` varchar(25) DEFAULT NULL,
  `DiasVencido` int(3) DEFAULT NULL,
  `Saldo` int(20) DEFAULT NULL,
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
  `CreditoID` bigint(12) DEFAULT NULL,
  `CredMaxUti` decimal(14,2) DEFAULT NULL,
  `FechIngCarVen` varchar(12) DEFAULT NULL,
  `InteresCred` decimal(14,2) DEFAULT NULL,
  `CadenaAvales` text,
  `Cinta` text,
  `IdentificaTS` text,
  `NumReportes` varchar(7) DEFAULT NULL,
  `TotalSaldos` varchar(20) DEFAULT NULL,
  `SolicitudCreditoID` bigint(12) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `TMPDATOSEM1` (`CreditoID`),
  KEY `TMPDATOSEM2` (`ClienteID`),
  KEY `TMPDATOSEM3` (`FechaLiquida`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$