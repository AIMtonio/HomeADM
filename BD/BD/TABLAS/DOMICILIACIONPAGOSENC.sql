-- Creacion de tabla DOMICILIACIONPAGOSENC

DELIMITER ;

DROP TABLE IF EXISTS DOMICILIACIONPAGOSENC;

DELIMITER $$

CREATE TABLE `DOMICILIACIONPAGOSENC` (
  `ConsecutivoID` 		BIGINT(20) 		NOT NULL 		COMMENT 'ID Consecutivo',
  `FolioID` 			BIGINT(20) 		DEFAULT NULL 	COMMENT 'Numero de Folio',
  `FechaRegistro` 		DATE 			DEFAULT NULL 	COMMENT 'Fecha de Registro',
  `NombreArchivo` 		VARCHAR(20) 	DEFAULT NULL 	COMMENT 'Nombre del Archivo',
  `Consecutivo` 		INT(11) 		DEFAULT NULL 	COMMENT 'Consecutivo por Dia',
  `ImporteTotal` 		DECIMAL(14,2) 	DEFAULT NULL 	COMMENT 'Importe Total por Folio',
  `EmpresaID` 			INT(11) 		DEFAULT NULL 	COMMENT 'Parametro de Auditoria',
  `Usuario` 			INT(11) 		DEFAULT NULL 	COMMENT 'Parametro de Auditoria',
  `FechaActual` 		DATETIME 		DEFAULT NULL 	COMMENT 'Parametro de Auditoria',
  `DireccionIP` 		VARCHAR(15) 	DEFAULT NULL 	COMMENT 'Parametro de Auditoria',
  `ProgramaID` 			VARCHAR(50) 	DEFAULT NULL 	COMMENT 'Parametro de Auditoria',
  `Sucursal` 			INT(11) 		DEFAULT NULL 	COMMENT 'Parametro de Auditoria',
  `NumTransaccion` 		BIGINT(20) 		DEFAULT NULL 	COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`ConsecutivoID`),
  KEY `INDEX_DOMICILIACIONPAGOSENC_1` (`FolioID`),
  KEY `INDEX_DOMICILIACIONPAGOSENC_2` (`FechaRegistro`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para el registro de informacion para el Encabezado del Layout de Domiciliacion de Pagos'$$
