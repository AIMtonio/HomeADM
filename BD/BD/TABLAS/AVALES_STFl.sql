-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AVALES_STFl
DELIMITER ;
DROP TABLE IF EXISTS `AVALES_STFl`;DELIMITER $$

CREATE TABLE `AVALES_STFl` (
  `TransaccionID` bigint(20) DEFAULT NULL,
  `Consecutivo` int(11) DEFAULT NULL,
  `Aval_Nombre1` varchar(250) DEFAULT NULL,
  `Aval_Domicilio1` varchar(250) DEFAULT NULL,
  `Aval_Nombre2` varchar(250) DEFAULT NULL,
  `Aval_Domicilio2` varchar(250) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$