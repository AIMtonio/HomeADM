-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TOTALESSOCIOS
DELIMITER ;
DROP TABLE IF EXISTS `TOTALESSOCIOS`;DELIMITER $$

CREATE TABLE `TOTALESSOCIOS` (
  `ClienteID` int(11) NOT NULL,
  `Total` decimal(12,2) DEFAULT '0.00',
  PRIMARY KEY (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para guardar los saldos totales de cada socio'$$