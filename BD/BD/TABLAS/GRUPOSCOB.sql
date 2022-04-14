-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GRUPOSCOB
DELIMITER ;
DROP TABLE IF EXISTS `GRUPOSCOB`;DELIMITER $$

CREATE TABLE `GRUPOSCOB` (
  `GrupoID` int(12) NOT NULL COMMENT 'Credito ID',
  `Exigible` decimal(18,2) NOT NULL COMMENT 'Exigible',
  PRIMARY KEY (`GrupoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$