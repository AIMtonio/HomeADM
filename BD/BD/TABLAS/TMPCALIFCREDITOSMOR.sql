-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCALIFCREDITOSMOR
DELIMITER ;
DROP TABLE IF EXISTS `TMPCALIFCREDITOSMOR`;DELIMITER $$

CREATE TABLE `TMPCALIFCREDITOSMOR` (
  `ClienteID` int(11) NOT NULL DEFAULT '0' COMMENT 'ID del cliente',
  `NumCreMoroso` int(11) DEFAULT NULL COMMENT 'Numero de creditos morosos',
  PRIMARY KEY (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena datos temporales para calcular puntajes sobre credi'$$