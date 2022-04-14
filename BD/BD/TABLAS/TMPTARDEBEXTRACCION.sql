-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPTARDEBEXTRACCION
DELIMITER ;
DROP TABLE IF EXISTS `TMPTARDEBEXTRACCION`;
DELIMITER $$


CREATE TABLE `TMPTARDEBEXTRACCION` (
  `ID`                  BIGINT(20) 		NOT NULL AUTO_INCREMENT 		COMMENT 'ID Conciliacion',
  `TarDebExtraccionID`  INT(11)         NOT NULL DEFAULT 0 	    		COMMENT 'ID de la tabla de Extraccion.',
  `Bin`                 VARCHAR(8)      NOT NULL DEFAULT '' 			COMMENT 'Nombre del archivo por extraer.',
  `SubBin`              VARCHAR(2)      NOT NULL DEFAULT '' 			COMMENT 'Nombre del archivo por extraer.',
  `Contenido`           VARCHAR(600)    NOT NULL DEFAULT '' 			COMMENT 'Contenido del archivo.',
  `EsHeader`            CHAR(1)         NOT NULL DEFAULT '' 			COMMENT 'Indica si el contenido es un Header (S = SI, N = NO).',
  `TipoTarjetaDebID`    INT(11)         NOT NULL DEFAULT 0 	    		COMMENT 'ID del Tipo de Tarjeta de Debito',

  `EmpresaID` 			INT(11) 		NOT NULL DEFAULT 0 				COMMENT 'Parametro de Auditoria.',
  `Usuario` 			INT(11) 		NOT NULL DEFAULT 0 				COMMENT 'Parametro de Auditoria.',
  `FechaActual` 		DATETIME 		NOT NULL DEFAULT '1900-01-01'	COMMENT 'Parametro de Auditoria.',
  `DireccionIP` 		VARCHAR(15) 	NOT NULL DEFAULT '' 			COMMENT 'Parametro de Auditoria.',
  `ProgramaID` 			VARCHAR(50) 	NOT NULL DEFAULT '' 			COMMENT 'Parametro de Auditoria.',
  `Sucursal` 			INT(11) 		NOT NULL DEFAULT 0 				COMMENT 'Parametro de Auditoria.',
  `NumTransaccion` 		BIGINT(20) 		NOT NULL DEFAULT 0				COMMENT 'Parametro de Auditoria.',
  PRIMARY KEY (`ID`),
  KEY `IDX_TMP_TARDEBEXTRACCION_01` (`TarDebExtraccionID`),
  KEY `IDX_TMP_TARDEBEXTRACCION_02` (`Bin`, `SubBin`),
  KEY `IDX_TMP_TARDEBEXTRACCION_03` (`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla temporal para almacenar la informacion de los archivos de transacciones de tarjetas.'$$
