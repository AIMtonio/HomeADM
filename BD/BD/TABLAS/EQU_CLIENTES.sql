-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EQU_CLIENTES
DELIMITER ;
DROP TABLE IF EXISTS `EQU_CLIENTES`;DELIMITER $$

CREATE TABLE `EQU_CLIENTES` (
  `ClienteIDSAFI` bigint(20) DEFAULT NULL,
  `ClienteIDCte` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$