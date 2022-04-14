-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPAMORTICREPAGOHEADER
DELIMITER ;
DROP TABLE IF EXISTS `TMPAMORTICREPAGOHEADER`;DELIMITER $$

CREATE TABLE `TMPAMORTICREPAGOHEADER` (
  `ClienteID` int(11) DEFAULT NULL,
  `CreditoID` bigint(12) DEFAULT NULL,
  `AmortizacionID` int(11) DEFAULT NULL,
  `Estatus` char(1) DEFAULT NULL,
  `SaldoCapVigente` decimal(14,2) DEFAULT NULL,
  `SaldoCapAtrasa` decimal(14,2) DEFAULT NULL,
  `SaldoCapVencido` decimal(14,2) DEFAULT NULL,
  `SaldoCapVenNExi` decimal(14,2) DEFAULT NULL,
  `SaldoInteresOrd` decimal(14,2) DEFAULT NULL,
  `SaldoInteresAtr` decimal(14,2) DEFAULT NULL,
  `SaldoInteresVen` decimal(14,2) DEFAULT NULL,
  `SaldoInteresPro` decimal(14,2) DEFAULT NULL,
  `SaldoIntNoConta` decimal(14,2) DEFAULT NULL,
  `SaldoIVAInteres` decimal(14,2) DEFAULT NULL,
  `SaldoMoratorios` decimal(14,2) DEFAULT NULL,
  `SaldoIVAMorato` decimal(14,2) DEFAULT NULL,
  `SaldoComFaltaPa` decimal(14,2) DEFAULT NULL,
  `SaldoIVAComFalP` decimal(14,2) DEFAULT NULL,
  `SaldoOtrasComis` decimal(14,2) DEFAULT NULL,
  `SaldoIVAComisi` decimal(14,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$