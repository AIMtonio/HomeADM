-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TCR_ISSARCH_ADM
DELIMITER ;
DROP TABLE IF EXISTS `TCR_ISSARCH_ADM`;DELIMITER $$

CREATE TABLE `TCR_ISSARCH_ADM` (
  `Arc_FolioAr` decimal(6,0) NOT NULL COMMENT 'Folio de los registros que formaran los archivos ISS',
  `Arc_Enviado` char(1) DEFAULT NULL COMMENT 'Archivo enviado registros que formaran los archivos ISS',
  `Arc_FecGen` datetime DEFAULT NULL COMMENT 'Fecha Archivo Generado registros que formaran los archivos ISS',
  `Arc_Orden` bigint(20) DEFAULT NULL COMMENT 'Orden Archivo Generado registros que formaran los archivos ISS',
  `Arc_Seccion` varchar(2) DEFAULT NULL COMMENT 'Seccion Archivo Generado registros que formaran los archivos ISS',
  `Arc_Registro` text COMMENT 'Registro del archivo que formaran los archivos ISS',
  `Arc_NumDoc` decimal(15,0) DEFAULT NULL COMMENT 'numero documento del archivo que formaran los archivos ISS',
  KEY `idx_Nonclustered_TCR_ISSARCH_ADM_Arc_FolioAr` (`Arc_FolioAr`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Contiene los registros que formaran los archivos ISS'$$