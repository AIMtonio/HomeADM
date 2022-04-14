-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TCR_DETARCERR_ADM
DELIMITER ;
DROP TABLE IF EXISTS `TCR_DETARCERR_ADM`;DELIMITER $$

CREATE TABLE `TCR_DETARCERR_ADM` (
  `Dae_FolioAr` decimal(6,0) NOT NULL COMMENT 'Detalle del Folio Error de Archivo de respuesta',
  `Dae_FecRes` datetime DEFAULT NULL COMMENT 'Detalle de Fecha Error de Archivo de respuesta',
  `Dae_Consecutivo` int(11) DEFAULT NULL COMMENT 'Consecutivo Detalle Error de Archivo de respuesta',
  `Dae_Campo1` varchar(16) DEFAULT NULL COMMENT 'Detalle del Error de Archivo de respuesta Campo 1',
  `Dae_Campo2` varchar(16) DEFAULT NULL COMMENT 'Detalle del Error de Archivo de respuesta Campo 2',
  `Dae_Campo3` varchar(7) DEFAULT NULL COMMENT 'Detalle del Error de Archivo de respuesta Campo 3',
  `Dae_Campo4` varchar(9) DEFAULT NULL COMMENT 'Detalle del Error de Archivo de respuesta Campo 4',
  `Dae_Campo5` varchar(4) DEFAULT NULL COMMENT 'Detalle del Error de Archivo de respuesta Campo 5',
  `Dae_Campo6` varchar(4) DEFAULT NULL COMMENT 'Detalle del Error de Archivo de respuesta Campo 6',
  `Dae_Campo7` varchar(5) DEFAULT NULL COMMENT 'Detalle del Error de Archivo de respuesta Campo 7',
  `Dae_Campo8` varchar(2) DEFAULT NULL COMMENT 'Detalle del Error de Archivo de respuesta Campo 8',
  `Dae_Campo9` varchar(30) DEFAULT NULL COMMENT 'Detalle del Error de Archivo de respuesta Campo 9',
  `Dae_Campo10` varchar(2) DEFAULT NULL COMMENT 'Detalle del Error de Archivo de respuesta Campo 10',
  `Dae_Campo11` varchar(15) DEFAULT NULL COMMENT 'Detalle del Error de Archivo de respuesta Campo 11',
  `Dae_Campo12` varchar(19) DEFAULT NULL COMMENT 'Detalle del Error de Archivo de respuesta Campo 12',
  `Dae_Campo13` varchar(7) DEFAULT NULL COMMENT 'Detalle del Error de Archivo de respuesta Campo 13',
  `Dae_Campo14` varchar(4) DEFAULT NULL COMMENT 'Detalle del Error de Archivo de respuesta Campo 14',
  `Dae_Status` char(1) DEFAULT NULL COMMENT 'Detalle estatus'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Detalles Error de respuesta PROSA'$$