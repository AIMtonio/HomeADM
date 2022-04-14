-- Creacion de tabla TMPDOMICILIACIONPAGOS

DELIMITER ;

DROP TABLE IF EXISTS TMPDOMICILIACIONPAGOS;

DELIMITER $$

CREATE TABLE `TMPDOMICILIACIONPAGOS` (
  `FolioID` 			BIGINT(20) 		DEFAULT NULL COMMENT 'Numero de Folio',
  `ClienteID` 			INT(11) 		DEFAULT NULL COMMENT 'ID Cliente',
  `InstitucionID` 		INT(11) 		DEFAULT NULL COMMENT 'ID Institucion',
  `CuentaClabe` 		VARCHAR(18) 	DEFAULT NULL COMMENT 'Cuenta Clabe',
  `AmortizacionID` 		INT(11) 		DEFAULT NULL COMMENT 'ID Amortizacion',
  `CreditoID` 			BIGINT(20) 		DEFAULT NULL COMMENT 'ID Credito',
  `MontoExigible` 		DECIMAL(14,2) 	DEFAULT NULL COMMENT 'Monto Exigible',
  `EmpresaID` 			INT(11) 		DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` 			INT(11) 		DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` 		DATETIME 		DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` 		VARCHAR(15) 	DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` 			VARCHAR(50) 	DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` 			INT(11) 		DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` 		BIGINT(20) 		DEFAULT NULL COMMENT 'Parametro de Auditoria',
  KEY `INDEX_TMPDOMICILIACIONPAGOS_1` (`FolioID`),
  KEY `INDEX_TMPDOMICILIACIONPAGOS_2` (`ClienteID`),
  KEY `INDEX_TMPDOMICILIACIONPAGOS_3` (`CreditoID`),
  KEY `INDEX_TMPDOMICILIACIONPAGOS_4` (`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla temporal para el registro de informacion del Layout de Domiciliacion de Pagos.'$$
