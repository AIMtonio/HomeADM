-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBEXTRACCION
DELIMITER ;
DROP TABLE IF EXISTS `TARDEBEXTRACCION`;
DELIMITER $$


CREATE TABLE `TARDEBEXTRACCION` (
  `TarDebExtraccionID`  INT(11) 		NOT NULL COMMENT 'ID de la tabla.',
  `Tipo`  				VARCHAR(1) 		NOT NULL COMMENT 'Tipo de Archivo (E = Emi, S = Stats).',
  `NomArchivo` 			VARCHAR(50) 	NOT NULL COMMENT 'Nombre del archivo por extraer.',
  `NomArchivoZip` 		VARCHAR(50) 	NOT NULL COMMENT 'Nombre del archivo zip con que se encuentran los archivos extraidos por Bin y subbin.',
  
  `EmpresaID` 			INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria.',
  `Usuario` 			INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria.',
  `FechaActual` 		DATETIME 		NOT NULL COMMENT 'Parametro de Auditoria.',
  `DireccionIP` 		VARCHAR(15) 	NOT NULL COMMENT 'Parametro de Auditoria.',
  `ProgramaID` 			VARCHAR(50) 	NOT NULL COMMENT 'Parametro de Auditoria.',
  `Sucursal` 			INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria.',
  `NumTransaccion` 		BIGINT(20) 		NOT NULL COMMENT 'Parametro de Auditoria.',
  PRIMARY KEY (`TarDebExtraccionID`),
  KEY `IDX_TARDEBEXTRACCION_01` (`NomArchivo`),
  KEY `IDX_TARDEBEXTRACCION_02` (`NomArchivoZip`),
  KEY `IDX_TARDEBEXTRACCION_03` (`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para almacenar la informacion de los archivos de transacciones de tarjetas.'$$