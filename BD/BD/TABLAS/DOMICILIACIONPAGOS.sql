-- Creacion de tabla DOMICILIACIONPAGOS

DELIMITER ;

DROP TABLE IF EXISTS DOMICILIACIONPAGOS;

DELIMITER $$

CREATE TABLE `DOMICILIACIONPAGOS` (
  `DomiciliacionID` 	BIGINT(20) 		NOT NULL 		COMMENT 'ID Domiciliacion',
  `FolioID` 			BIGINT(20) 		DEFAULT NULL 	COMMENT 'Numero de Folio',
  `ClienteID` 			INT(11) 		DEFAULT NULL 	COMMENT 'ID Cliente',
  `InstitucionID` 		INT(11) 		DEFAULT NULL 	COMMENT 'ID Institucion',
  `CuentaClabe` 		VARCHAR(18) 	DEFAULT NULL 	COMMENT 'Cuenta Clabe',
  `CreditoID` 			BIGINT(20) 		DEFAULT NULL 	COMMENT 'ID Credito',
  `MontoExigible` 		DECIMAL(14,2) 	DEFAULT NULL 	COMMENT 'Monto Exigible',
  `Referencia` 			VARCHAR(50) 	DEFAULT NULL 	COMMENT 'Referencia del Cliente',
  `NoEmpleado` 			VARCHAR(30) 	DEFAULT NULL 	COMMENT 'Numero de Empleado en su Empresa de Nomina',
  `EmpresaID` 			INT(11) 		DEFAULT NULL 	COMMENT 'Parametro de Auditoria',
  `Usuario` 			INT(11) 		DEFAULT NULL 	COMMENT 'Parametro de Auditoria',
  `FechaActual` 		DATETIME 		DEFAULT NULL 	COMMENT 'Parametro de Auditoria',
  `DireccionIP` 		VARCHAR(15) 	DEFAULT NULL 	COMMENT 'Parametro de Auditoria',
  `ProgramaID` 			VARCHAR(50) 	DEFAULT NULL 	COMMENT 'Parametro de Auditoria',
  `Sucursal` 			INT(11) 		DEFAULT NULL 	COMMENT 'Parametro de Auditoria',
  `NumTransaccion` 		BIGINT(20) 		DEFAULT NULL 	COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`DomiciliacionID`),
  KEY `INDEX_DOMICILIACIONPAGOS_1` (`FolioID`),
  KEY `INDEX_DOMICILIACIONPAGOS_2` (`ClienteID`),
  KEY `INDEX_DOMICILIACIONPAGOS_3` (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para el registro de informacion del Layout de Domiciliacion de Pagos.'$$
