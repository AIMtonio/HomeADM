-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EQU_CUENTASAHO
DELIMITER ;
DROP TABLE IF EXISTS `EQU_CUENTASAHO`;DELIMITER $$

CREATE TABLE `EQU_CUENTASAHO` (
  `CuentaAhoIDSAFI` bigint(20) DEFAULT NULL,
  `CuentaAhoIDCte` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$