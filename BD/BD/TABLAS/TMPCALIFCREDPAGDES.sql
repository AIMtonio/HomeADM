-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCALIFCREDPAGDES
DELIMITER ;
DROP TABLE IF EXISTS `TMPCALIFCREDPAGDES`;DELIMITER $$

CREATE TABLE `TMPCALIFCREDPAGDES` (
  `ClienteID` int(11) NOT NULL DEFAULT '0' COMMENT 'ID del cliente',
  `Numero` int(11) DEFAULT NULL COMMENT 'Numero de creditos pagados despues de su fecha de vencimiento',
  PRIMARY KEY (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena el  numero de creditos pagados despues'$$