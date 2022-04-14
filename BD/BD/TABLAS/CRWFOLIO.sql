-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWFOLIO
DELIMITER ;
DROP TABLE IF EXISTS `CRWFOLIO`;
DELIMITER $$


CREATE TABLE `CRWFOLIO` (
  `FolioID` BIGINT(20) NOT NULL	COMMENT 'Numero del folio',
  `Tabla` VARCHAR(60) NOT NULL COMMENT 'Nombre de la tabla que contiene el folio',
  PRIMARY KEY (`Tabla`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Control de Folios CRW'$$
