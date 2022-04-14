-- Creacion de tabla DOMICILIAPAGOSARCH

DELIMITER ;

DROP TABLE IF EXISTS DOMICILIAPAGOSARCH;

DELIMITER $$

CREATE TABLE `DOMICILIAPAGOSARCH` (
  `ConsecutivoID` 		BIGINT(20) 		NOT NULL 		COMMENT 'ID Consecutivo',
  `FolioID` 			BIGINT(20) 		DEFAULT NULL 	COMMENT 'Numero de Folio',
  `Fecha` 				DATE 			DEFAULT NULL 	COMMENT 'Fecha de Proceso de Domiciliacion de Pagos',
  `NombreArchivo` 		VARCHAR(200) 	DEFAULT NULL 	COMMENT 'Nombre del Archivo de Domiciliacion de Pagos Procesado',
  `EmpresaID` 			INT(11) 		DEFAULT NULL 	COMMENT 'Parametro de Auditoria',
  `Usuario` 			INT(11) 		DEFAULT NULL 	COMMENT 'Parametro de Auditoria',
  `FechaActual` 		DATETIME 		DEFAULT NULL 	COMMENT 'Parametro de Auditoria',
  `DireccionIP` 		VARCHAR(20) 	DEFAULT NULL 	COMMENT 'Parametro de Auditoria',
  `ProgramaID` 			VARCHAR(50) 	DEFAULT NULL 	COMMENT 'Parametro de Auditoria',
  `Sucursal` 			INT(11) 		DEFAULT NULL 	COMMENT 'Parametro de Auditoria',
  `NumTransaccion` 		BIGINT(20) 		DEFAULT NULL 	COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`ConsecutivoID`),
  KEY `INDEX_DOMICILIAPAGOSARCH_1` (`FolioID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para el registro del Archivo de Domiciliacion de Pagos Procesado.'$$
