-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CIRCULOCRECUENT
DELIMITER ;
DROP TABLE IF EXISTS `CIRCULOCRECUENT`;DELIMITER $$

CREATE TABLE `CIRCULOCRECUENT` (
  `fk_SolicitudID` varchar(45) NOT NULL COMMENT 'Es el numero de \nconsecutivo \nobtenido del \nprograma de \ncirculo de credito \nde la tabla de \nCIRCULOCRESOL',
  `Consecutivo` int(11) NOT NULL COMMENT 'Es el consecutivo\ndel numero de \nobjetos que se \nencuentran \nrelacionados a la\ntabla correspondiente\nen este caso son \nlas cuentas que \ntiene con el/los otorgante(s) \nla persona consultada',
  `FecActualizacion` date DEFAULT NULL,
  `RegImpugnado` varchar(45) DEFAULT NULL,
  `ClaveOtorgante` varchar(45) DEFAULT NULL,
  `NomOtorgante` varchar(45) DEFAULT NULL,
  `CuentaActual` varchar(45) DEFAULT NULL,
  `TipRespons` varchar(45) DEFAULT NULL COMMENT 'Es el tipo de responsabilidad\ndefinido en el manual\nesquema consulta y \nrespuesta en la seccion\nde anexos en la tabla\nTipos de Responsabilidad\n',
  `TipoCuenta` varchar(45) DEFAULT NULL COMMENT 'Es el tipo de cuenta\ndefinido en el manual\nesquema consulta y \nrespuesta en la seccion\nde anexos en la tabla\nTipos de Cuenta',
  `TipoCredito` varchar(45) DEFAULT NULL COMMENT 'Es el tipo de credito\ndefinido en el manual\nesquema consulta y \nrespuesta en la seccion\nde anexos en la tabla\nTipos de Credito\n',
  `ClveUniMon` varchar(45) DEFAULT NULL,
  `ValActValuacion` decimal(14,2) DEFAULT NULL,
  `NumeroPagos` int(11) DEFAULT NULL,
  `FrecuenciaPagos` varchar(5) DEFAULT NULL,
  `MontoPagar` decimal(14,2) DEFAULT NULL,
  `FecApeCuenta` date DEFAULT NULL,
  `FecUltPago` date DEFAULT NULL,
  `FecUltCompra` date DEFAULT NULL,
  `FecCieCuenta` date DEFAULT NULL,
  `FecRespote` date DEFAULT NULL,
  `UltFecSalCero` date DEFAULT NULL,
  `Garantia` varchar(100) DEFAULT NULL,
  `CreditoMaximo` decimal(14,2) DEFAULT NULL,
  `SaldoActual` decimal(14,2) DEFAULT NULL,
  `LimiteCredito` decimal(14,2) DEFAULT NULL,
  `SaldoVencido` decimal(14,2) DEFAULT NULL,
  `NumPagVencidos` int(11) DEFAULT NULL,
  `Cuenta` varchar(45) DEFAULT NULL,
  `MOP0` int(11) DEFAULT NULL,
  `MOP1` int(11) DEFAULT NULL,
  `MOP2` int(11) DEFAULT NULL,
  `MOP3` int(11) DEFAULT NULL,
  `MOP4` int(11) DEFAULT NULL,
  `ClavePreven` varchar(45) DEFAULT NULL,
  `TotalPagosRep` decimal(14,2) DEFAULT NULL,
  `FecAntHisPagos` date DEFAULT NULL,
  `PagoActual` varchar(2) DEFAULT NULL,
  `PeorAtraso` int(11) DEFAULT NULL,
  `FechaPeorAtraso` date DEFAULT NULL,
  `SalVenPeorAtraso` int(11) DEFAULT NULL,
  PRIMARY KEY (`fk_SolicitudID`,`Consecutivo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='contiene el comportamiento actual e histórico del Crédito de'$$