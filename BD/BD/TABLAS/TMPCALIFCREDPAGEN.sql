-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCALIFCREDPAGEN
DELIMITER ;
DROP TABLE IF EXISTS `TMPCALIFCREDPAGEN`;DELIMITER $$

CREATE TABLE `TMPCALIFCREDPAGEN` (
  `ClienteID` int(11) NOT NULL DEFAULT '0' COMMENT 'ID del cliente',
  `Numero` int(11) DEFAULT NULL COMMENT 'Numero de creditos pagados en su fecha de vencimiento',
  PRIMARY KEY (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena el  numero de creditos pagados en su fecha de vencimiento'$$