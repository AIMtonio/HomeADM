-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TCR_HEDTRAERR_ADM
DELIMITER ;
DROP TABLE IF EXISTS `TCR_HEDTRAERR_ADM`;DELIMITER $$

CREATE TABLE `TCR_HEDTRAERR_ADM` (
  `Hte_FolioAr` decimal(6,0) NOT NULL COMMENT 'Folio de headers de archivos con registros de error por PROSA',
  `Hte_FecRes` datetime DEFAULT NULL COMMENT 'Fecha Registro de headers de archivos con registros de error por PROSA',
  `Hte_Tipo` char(1) DEFAULT NULL COMMENT 'Tipo headers de archivos con registros de error por PROSA',
  `Hte_Campo1` varchar(7) DEFAULT NULL COMMENT 'Headers de archivos con registros de error por PROSA Campo 1',
  `Hte_Campo2` varchar(3) DEFAULT NULL COMMENT 'Headers de archivos con registros de error por PROSA Campo 2',
  `Hte_Campo3` varchar(5) DEFAULT NULL COMMENT 'Headers de archivos con registros de error por PROSA Campo 3',
  `Hte_Campo4` varchar(4) DEFAULT NULL COMMENT 'Headers de archivos con registros de error por PROSA Campo 4',
  `Hte_Campo5` varchar(2) DEFAULT NULL COMMENT 'Headers de archivos con registros de error por PROSA Campo 5',
  `Hte_Campo6` varchar(6) DEFAULT NULL COMMENT 'Headers de archivos con registros de error por PROSA Campo 6',
  `Hte_Campo7` varchar(4) DEFAULT NULL COMMENT 'Headers de archivos con registros de error por PROSA Campo 7',
  `Hte_Campo8` varchar(12) DEFAULT NULL COMMENT 'Headers de archivos con registros de error por PROSA Campo 8',
  `Hte_Campo9` varchar(8) DEFAULT NULL COMMENT 'Headers de archivos con registros de error por PROSA Campo 9',
  `Hte_Campo10` varchar(16) DEFAULT NULL COMMENT 'Headers de archivos con registros de error por PROSA Campo 10',
  `Hte_Campo11` varchar(9) DEFAULT NULL COMMENT 'Headers de archivos con registros de error por PROSA Campo 11',
  `Hte_Campo12` varchar(6) DEFAULT NULL COMMENT 'Headers de archivos con registros de error por PROSA Campo 12',
  `Hte_Status` char(1) DEFAULT NULL COMMENT 'Estatus Headers de archivos con registros de error por PROSA'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='contiene los headers y trailers de los archivos ERR(archivos con registros de error por PROSA).'$$