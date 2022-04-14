-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTARESUMCREDITOS
DELIMITER ;
DROP TABLE IF EXISTS `EDOCTARESUMCREDITOS`;DELIMITER $$

CREATE TABLE `EDOCTARESUMCREDITOS` (
  `AnioMes` int(11) NOT NULL,
  `SucursalID` int(11) NOT NULL,
  `ClienteID` int(11) DEFAULT NULL,
  `CreditoID` bigint(12) NOT NULL,
  `Orden` int(11) NOT NULL,
  `SaldoMesAnterior` decimal(18,2) DEFAULT NULL,
  `Capital` decimal(18,2) DEFAULT NULL,
  `Interes` decimal(18,2) DEFAULT NULL,
  `Moratorios` decimal(18,2) DEFAULT NULL,
  `ComFaltaPago` decimal(18,2) DEFAULT NULL,
  `GastoAdmon` decimal(18,2) DEFAULT NULL,
  `OtrasCom` decimal(18,2) DEFAULT NULL,
  `IVAS` decimal(18,2) DEFAULT NULL,
  `ValorIVAInt` decimal(18,2) DEFAULT NULL,
  `ValorIVAMora` decimal(18,2) DEFAULT NULL,
  `ValorIVAAccesorios` decimal(18,2) DEFAULT NULL,
  `TotalAdeudo` decimal(18,2) DEFAULT NULL,
  `MontoExigible` decimal(18,2) DEFAULT NULL,
  `FechaProxPago` varchar(20) DEFAULT NULL,
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Identificador de Moneda ',
  `DescMoneda` varchar(10) DEFAULT NULL COMMENT 'Descripcion de Moneda ',
  `FechaFormalizacion` varchar(20) DEFAULT NULL COMMENT 'Fecha de Inicio del Credito',
  `TipoPago` varchar(20) DEFAULT NULL COMMENT 'Tipo de Pago',
  `SaldoInicial` decimal(18,2) DEFAULT NULL COMMENT 'Saldo Inicial del Periodo',
  `CAT` decimal(12,1) DEFAULT NULL COMMENT 'CAT',
  `ProductoCred` varchar(100) DEFAULT NULL,
  `Estatus` varchar(45) DEFAULT NULL COMMENT 'Estatus del Credito',
  `MontoOtorgado` decimal(12,2) DEFAULT NULL,
  `TasaFija` decimal(12,4) DEFAULT NULL,
  `TasaMoratoria` float DEFAULT NULL,
  `TotalAtrasado` decimal(12,2) DEFAULT NULL COMMENT 'Importe en atraso al inicio del ciclo.',
  `FechaVencimiento` varchar(10) DEFAULT NULL COMMENT 'Fecha de Vencimiento del Credito.',
  `FechaUltimoPago` varchar(10) DEFAULT NULL COMMENT 'Fecha  de el ultimo pago realizado al credito, no importa el monto o el conepto que pago',
  `InteresaPagar` decimal(12,2) DEFAULT NULL COMMENT 'Es el total de Intereses Exigibles Normales y Comisiones no pagados al Fin de Mes ',
  `Comisiones` decimal(12,2) DEFAULT NULL COMMENT 'Contiene  las Comisiones generadas no cobradas, es decir el saldo de comisiones que debe al fin de mes.',
  `SaldoIntMora` decimal(12,2) DEFAULT '0.00' COMMENT 'Saldo al Corte Interes Moratorio',
  `SaldoIntNormal` decimal(12,2) DEFAULT '0.00' COMMENT 'Saldo al Corte Interes Normal',
  `SaldoCapital` decimal(12,2) DEFAULT '0.00' COMMENT 'Saldo al Corte Capital',
  `AmorizaCapital` decimal(12,2) DEFAULT '0.00' COMMENT 'Amortizaciones de Capital Vencidos',
  `IvaInterMora` decimal(12,2) DEFAULT '0.00' COMMENT 'Iva al Corte de Intereses Moratorios',
  `IvaInterNormal` decimal(12,2) DEFAULT '0.00' COMMENT 'Iva al Corte Interes Normal',
  `Abono` decimal(14,2) DEFAULT NULL,
  `Cargo` decimal(14,2) DEFAULT NULL,
  `Pagos` varchar(10) DEFAULT NULL,
  `AmortiMin` varchar(3) DEFAULT NULL,
  `AmortiMax` varchar(3) DEFAULT NULL,
  PRIMARY KEY (`AnioMes`,`SucursalID`,`CreditoID`,`Orden`),
  KEY `idx_EDOCTARESUMCREDITOS_1` (`CreditoID`),
  KEY `idx_EDOCTARESUMCREDITOS_2` (`CreditoID`,`ClienteID`),
  KEY `idx_EDOCTARESUMCREDITOS_3` (`ClienteID`),
  KEY `idx_EDOCTARESUMCREDITOS_4` (`Orden`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$