-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TCR_ARCHRESPPROSA_TMP
DELIMITER ;
DROP TABLE IF EXISTS `TCR_ARCHRESPPROSA_TMP`;DELIMITER $$

CREATE TABLE `TCR_ARCHRESPPROSA_TMP` (
  `Arc_NombreArch` varchar(30) DEFAULT NULL COMMENT 'Nombre del Archivo Generado',
  `Arc_Registro` text COMMENT 'Nombre del Archivo de Registro'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Archivos de respuesta PROSA'$$