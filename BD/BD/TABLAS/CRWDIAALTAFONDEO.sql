-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWDIAALTAFONDEO
DELIMITER ;
DROP TABLE IF EXISTS `CRWDIAALTAFONDEO`;
DELIMITER $$


CREATE TABLE `CRWDIAALTAFONDEO` (
  `SolFondeoID` bigint(20) NOT NULL COMMENT 'Numero del fondeo',
  `CuentaAhoID` bigint(12) NOT NULL COMMENT 'Numero de la cuenta de ahorro',
  `ClienteID` int(12) NOT NULL COMMENT 'Numero del cliente ',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Numero del credito',
  `SolicitudCredito` bigint(20) NOT NULL COMMENT 'Numero de la solicitud de credito',
  `ClienteCre` int(12) NOT NULL COMMENT'Numero del cliente del credito',
  `MontoCredito` decimal(12,2) NOT NULL COMMENT 'Monto del credito',
  `MontoFondeo` decimal(12,2) NOT NULL COMMENT 'Monto del fondeo',
  `PorcentajeFondeo` decimal(10,6) NOT NULL COMMENT 'Porcentaje del fondeo',
  `FechaInicio` date NOT NULL COMMENT 'Fecha inicio del fondeo',
  `FechaVencimiento` date NOT NULL COMMENT 'Fecha de vencimiento del fondeo',
  `TasaFija` decimal(9,6) NOT NULL COMMENT 'Tasa fija del fondeo',
  `PeriodicidadCap` mediumint(9) NOT NULL COMMENT 'Peridicidad capital del fondeo',
  `NumAmortizacion` mediumint(9) NOT NULL COMMENT 'Numero de amortizacion del fondeo',
  `FrecuenciaInt` char(1) NOT NULL COMMENT 'Frecuencia de interes del fondeo',
  `EstatusCre` char(1) NOT NULL COMMENT 'Estatus del credito',
  `FechaVencimCre` date NOT NULL COMMENT 'Fecha vecimiento del credito',
  `NoCuotasAtraso` mediumint(9) NOT NULL COMMENT 'Numero de cuotas atraso',
  `NumCuotas` mediumint(9) NOT NULL COMMENT 'Numero de cuotas',
  `DiasAtraso` mediumint(9) NOT NULL COMMENT 'Dias de atraso',
  `DiaAtrasoID` tinyint(4) NOT NULL COMMENT 'ID Dias de atraso',
  `FechaActual` datetime NOT NULL COMMENT 'Fecha actual',
  `ComisionApertura` decimal(12,2) NOT NULL COMMENT 'Comision de la apertura',
  `IVAComisionAper` decimal(12,2) NOT NULL COMMENT 'Iva de la comision por apertura',
  PRIMARY KEY (`SolFondeoID`),
  KEY `idx_FechaCta` (`FechaInicio`,`CuentaAhoID`) USING BTREE,
  KEY `idx_CreditoID` (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Inversiones Crowdfounding.Impulso fondeadas en la fecha del sistema  '$$
