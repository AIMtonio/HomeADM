-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWAMORTICREFONDEO
DELIMITER ;
DROP TABLE IF EXISTS `CRWAMORTICREFONDEO`;
DELIMITER $$


CREATE TABLE `CRWAMORTICREFONDEO` (
  `CreditoID` bigint(12) NOT NULL COMMENT 'ID del credito',
  `AmortizacionID` mediumint(9) NOT NULL COMMENT 'ID de la amortizacion del credito',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus de la amortizacion de credito',
  `FechaInicio` date NOT NULL COMMENT 'Fecha de inicio de la amortizacion',
  `FechaVencimiento` date NOT NULL COMMENT 'Fecha de vencimiento de la amortizacion',
  `FechaExigible` date NOT NULL COMMENT 'Fecha exigible',
  `SaldoCapital` decimal(12,2) NOT NULL COMMENT 'Saldo capital',
  `SaldoFondeo` decimal(12,2) NOT NULL COMMENT 'Saldo fondeo',
  `NumFondeos` int(12) NOT NULL COMMENT 'Numero de fondeos',
  PRIMARY KEY (`CreditoID`,`AmortizacionID`),
  KEY `idx_CreFechaVenc` (`CreditoID`,`FechaVencimiento`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Contiene los saldos insolutos de credito y saldo fondeado por credito'$$

