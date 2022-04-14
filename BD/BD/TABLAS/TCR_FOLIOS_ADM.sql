-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TCR_FOLIOS_ADM
DELIMITER ;
DROP TABLE IF EXISTS `TCR_FOLIOS_ADM`;DELIMITER $$

CREATE TABLE `TCR_FOLIOS_ADM` (
  `FolioID` char(3) NOT NULL COMMENT 'Folio ID de archivos ISS que se envian a Prosa',
  `Num_Folio` int(11) NOT NULL COMMENT 'Numero de Folio de archivos ISS que se envian a Prosa'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Control de Folios de archivos ISS que se envian a Prosa'$$