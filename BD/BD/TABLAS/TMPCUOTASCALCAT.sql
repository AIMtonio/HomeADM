-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCUOTASCALCAT
DELIMITER ;
DROP TABLE IF EXISTS `TMPCUOTASCALCAT`;DELIMITER $$

CREATE TABLE `TMPCUOTASCALCAT` (
  `TmpNumTransaccion` bigint(20) NOT NULL,
  `TmpCuoNumero` float DEFAULT NULL,
  `TmpCuoMonto` decimal(14,4) DEFAULT NULL,
  `TmpCuo_Xn` float DEFAULT NULL,
  `TmpCuo_Xn_1` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$