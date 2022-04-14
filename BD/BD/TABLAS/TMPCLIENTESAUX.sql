-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCLIENTESAUX
DELIMITER ;
DROP TABLE IF EXISTS `TMPCLIENTESAUX`;DELIMITER $$

CREATE TABLE `TMPCLIENTESAUX` (
  `Transaccion` bigint(20) DEFAULT NULL,
  `ClienteID` int(11) DEFAULT NULL,
  `NombreCompleto` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$