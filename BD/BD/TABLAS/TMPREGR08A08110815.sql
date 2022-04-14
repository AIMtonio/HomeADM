-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPREGR08A08110815
DELIMITER ;
DROP TABLE IF EXISTS `TMPREGR08A08110815`;DELIMITER $$

CREATE TABLE `TMPREGR08A08110815` (
  `Reg_Concepto` varchar(200) DEFAULT NULL,
  `Reg_SalCapCie` decimal(14,2) DEFAULT NULL,
  `Reg_SalIntNoPa` decimal(14,2) DEFAULT NULL,
  `Reg_SalCieMes` decimal(14,2) DEFAULT NULL,
  `Reg_IntMes` decimal(14,2) DEFAULT NULL,
  `Reg_ComMes` decimal(14,2) DEFAULT NULL,
  `Reg_Orden` int(11) NOT NULL DEFAULT '0',
  `Reg_CuentaCNBV` varchar(40) DEFAULT NULL,
  `Reg_ReporteID` varchar(40) NOT NULL DEFAULT '',
  `NumTransaccion` bigint(20) DEFAULT NULL,
  `Saldo` decimal(14,2) DEFAULT NULL,
  `NumCuentas` bigint(12) DEFAULT NULL,
  `UDIS` decimal(12,2) DEFAULT NULL,
  PRIMARY KEY (`Reg_ReporteID`,`Reg_Orden`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de paso para reportes regulatorios 811 y 815 '$$