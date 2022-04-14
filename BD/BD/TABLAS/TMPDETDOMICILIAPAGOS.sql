-- Creacion de tabla TMPDETDOMICILIAPAGOS

DELIMITER ;

DROP TABLE IF EXISTS TMPDETDOMICILIAPAGOS;

DELIMITER $$

CREATE TABLE `TMPDETDOMICILIAPAGOS` (
  `ConsecutivoID` 		BIGINT(20) 			NOT NULL AUTO_INCREMENT 	COMMENT 'ID Consecutivo',
  `FolioID` 			BIGINT(20) 			DEFAULT NULL 				COMMENT 'Numero de Folio',
  `ClienteID` 			INT(11) 			DEFAULT NULL 				COMMENT 'ID Cliente',
  `NombreCompleto` 		VARCHAR(250) 		DEFAULT NULL 				COMMENT 'Nombre Completo del CLiente',
  `InstitucionID` 		INT(11) 			DEFAULT NULL 				COMMENT 'ID Institucion',
  `NombreInstitucion` 	VARCHAR(45) 		DEFAULT NULL 				COMMENT 'Nombre Institucion',
  `CuentaClabe` 		VARCHAR(18) 		DEFAULT NULL 				COMMENT 'Cuenta Clabe',
  `CreditoID` 			BIGINT(20) 			DEFAULT NULL 				COMMENT 'ID Credito',
  `MontoExigible` 		DECIMAL(14,2) 		DEFAULT NULL 				COMMENT 'Monto Exigible del Credito',
  `EmpresaID` 			INT(11) 			DEFAULT NULL 				COMMENT 'Parametro de Auditoria',
  `Usuario` 			INT(11) 			DEFAULT NULL 				COMMENT 'Parametro de Auditoria',
  `FechaActual` 		DATETIME 			DEFAULT NULL 				COMMENT 'Parametro de Auditoria',
  `DireccionIP` 		VARCHAR(15) 		DEFAULT NULL 				COMMENT 'Parametro de Auditoria',
  `ProgramaID` 			VARCHAR(50) 		DEFAULT NULL 				COMMENT 'Parametro de Auditoria',
  `Sucursal` 			INT(11) 			DEFAULT NULL 				COMMENT 'Parametro de Auditoria',
  `NumTransaccion` 		BIGINT(20) 			DEFAULT NULL 				COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`ConsecutivoID`),
  KEY `INDEX_TMPDETDOMICILIAPAGOS_1` (`FolioID`),
  KEY `INDEX_TMPDETDOMICILIAPAGOS_2` (`ClienteID`),
  KEY `INDEX_TMPDETDOMICILIAPAGOS_3` (`CreditoID`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla temporal para el registro de informacion de detalles para generar la domiciliacion de pagos.'$$