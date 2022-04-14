-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- tmpTMPINTEGRACONTRATOS
DELIMITER ;
DROP TABLE IF EXISTS `tmpTMPINTEGRACONTRATOS`;DELIMITER $$

CREATE TABLE `tmpTMPINTEGRACONTRATOS` (
  `NumeroID` int(11) NOT NULL AUTO_INCREMENT,
  `NombreIntegrante` varchar(100) DEFAULT NULL,
  `DireccionIntegrante` varchar(200) DEFAULT NULL,
  `Comision` decimal(14,2) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  `Consecutivo` int(11) DEFAULT NULL,
  PRIMARY KEY (`NumeroID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$$