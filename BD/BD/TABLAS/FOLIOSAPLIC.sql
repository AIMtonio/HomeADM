-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FOLIOSAPLIC
DELIMITER ;
DROP TABLE IF EXISTS `FOLIOSAPLIC`;DELIMITER $$

CREATE TABLE `FOLIOSAPLIC` (
  `FolioID` bigint(20) NOT NULL COMMENT 'Folio o \nConsecutivo\n',
  `Tabla` varchar(100) NOT NULL COMMENT 'Nombre de\nla Tabla',
  PRIMARY KEY (`Tabla`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Control de Folios de la Aplicacion'$$