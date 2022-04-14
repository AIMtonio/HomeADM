-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TCR_HEDTRAOUT_ADM
DELIMITER ;
DROP TABLE IF EXISTS `TCR_HEDTRAOUT_ADM`;DELIMITER $$

CREATE TABLE `TCR_HEDTRAOUT_ADM` (
  `Hto_FolioAr` decimal(6,0) NOT NULL COMMENT 'Folio de los archivos CARD',
  `Hto_FecRes` datetime DEFAULT NULL COMMENT 'Fecha Registro de los archivos CARD',
  `Hto_Tipo` char(1) DEFAULT NULL COMMENT 'Tipo headers de archivos de los archivos CARD',
  `Hto_Campo1` varchar(7) DEFAULT NULL COMMENT 'Headers de los archivos CARD Campo 1',
  `Hto_Campo2` varchar(3) DEFAULT NULL COMMENT 'Headers de los archivos CARD Campo 2',
  `Hto_Campo3` varchar(5) DEFAULT NULL COMMENT 'Headers de los archivos CARD Campo 3',
  `Hto_Campo4` varchar(4) DEFAULT NULL COMMENT 'Headers de los archivos CARD Campo 4',
  `Hto_Campo5` varchar(2) DEFAULT NULL COMMENT 'Headers de los archivos CARD Campo 5',
  `Hto_Campo6` varchar(6) DEFAULT NULL COMMENT 'Headers de los archivos CARD Campo 6',
  `Hto_Campo7` varchar(4) DEFAULT NULL COMMENT 'Headers de los archivos CARD Campo 7',
  `Hto_Campo8` varchar(12) DEFAULT NULL COMMENT 'Headers de los archivos CARD Campo 8',
  `Hto_Campo9` varchar(8) DEFAULT NULL COMMENT 'Headers de los archivos CARD Campo 9',
  `Hto_Campo10` varchar(16) DEFAULT NULL COMMENT 'Headers de los archivos CARD Campo 10',
  `Hto_Campo11` varchar(9) DEFAULT NULL COMMENT 'Headers de los archivos CARD Campo 11',
  `Hto_Campo12` varchar(6) DEFAULT NULL COMMENT 'Headers de los archivos CARD Campo 12',
  `Hto_Status` char(1) DEFAULT NULL COMMENT 'Estatus Headers de archivos CARD por PROSA'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Contiene los headers y trailers de los archivos CARD(archivos con tajetas generadas con éxito por PROSA).'$$