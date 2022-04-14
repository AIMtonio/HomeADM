-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPMOVSCTA
DELIMITER ;
DROP TABLE IF EXISTS `TMPMOVSCTA`;
DELIMITER $$


CREATE TABLE `TMPMOVSCTA` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `SaldoPromedio` decimal(12,2) DEFAULT NULL COMMENT 'Saldo promedio ',
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla de paso para CIERRE DE MES'$$
