-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- tmp_ContaSaldosDeCuentas
DELIMITER ;
DROP TABLE IF EXISTS `tmp_ContaSaldosDeCuentas`;DELIMITER $$

CREATE TABLE `tmp_ContaSaldosDeCuentas` (
  `NumTipCuenta` int(11) DEFAULT NULL,
  `TipoCuenta` varchar(200) DEFAULT NULL,
  `Ope_SinGravamen` decimal(14,2) DEFAULT NULL,
  `Conta_SinGravamen` decimal(14,2) DEFAULT NULL,
  `Ope_ConGravamen` decimal(14,2) DEFAULT NULL,
  `Conta_ConGravamen` decimal(14,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$