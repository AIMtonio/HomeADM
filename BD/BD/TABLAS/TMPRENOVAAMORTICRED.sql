-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPRENOVAAMORTICRED
DELIMITER ;
DROP TABLE IF EXISTS `TMPRENOVAAMORTICRED`;
DELIMITER $$

CREATE TABLE `TMPRENOVAAMORTICRED` (
  `Consecutivo` bigint(21) NOT NULL COMMENT 'Consecutivo',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Credito',
  `AmortizacionID` int(4) NOT NULL COMMENT 'No. Amortizacion',
  `SaldoCapVigente` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Capital Vigente, en el alta nace con ceros',
  `SaldoCapAtrasa` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Capital Atrasado, en el alta nace con ceros',
  `SaldoCapVencido` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Capital Vencido, en el alta nace con ceros',
  `SaldoCapVenNExi` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Capital Vencido no Exigible, en al alta nace con ceros',
  `Transaccion` bigint(20) DEFAULT NULL,  
  PRIMARY KEY (`Consecutivo`,`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP TABLA AUXILIAR PARA GUARDAR LAS AMORTIZACIONES DEL CREDITO ANTERIOR';$$