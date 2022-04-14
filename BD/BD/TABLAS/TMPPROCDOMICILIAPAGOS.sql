-- Creacion de tabla TMPPROCDOMICILIAPAGOS

DELIMITER ;

DROP TABLE IF EXISTS TMPPROCDOMICILIAPAGOS;

DELIMITER $$

CREATE TABLE `TMPPROCDOMICILIAPAGOS` (
  `ConsecutivoID` 		BIGINT(20) 		NOT NULL 		COMMENT 'ID Consecutivo',
  `FolioID` 			BIGINT(20) 		DEFAULT NULL 	COMMENT 'Numero de Afiliacion',
  `ClienteID` 			INT(11) 		DEFAULT NULL 	COMMENT 'ID del Cliente',
  `InstitucionID` 		INT(11) 		DEFAULT NULL 	COMMENT 'ID Institucion',
  `CuentaClabe` 		VARCHAR(18) 	DEFAULT NULL 	COMMENT 'Cuenta Clabe',
  `CreditoID` 			BIGINT(12) 		DEFAULT NULL 	COMMENT 'ID Credito',
  `MontoTotal` 			DECIMAL(14,2) 	DEFAULT NULL 	COMMENT 'Monto Total',
  `MontoPendiente` 		DECIMAL(14,2) 	DEFAULT NULL 	COMMENT 'Monto Pendiente',
  `ClaveDomicilia` 		CHAR(2) 		DEFAULT NULL 	COMMENT 'Clave Domiciliacion\n00 = Exitosa',
  `EmpresaID` 			INT(11) 		DEFAULT NULL 	COMMENT 'Parametro de Auditoria',
  `Usuario` 			INT(11) 		DEFAULT NULL 	COMMENT 'Parametro de Auditoria',
  `FechaActual` 		DATETIME 		DEFAULT NULL 	COMMENT 'Parametro de Auditoria',
  `DireccionIP` 		VARCHAR(20) 	DEFAULT NULL 	COMMENT 'Parametro de Auditoria',
  `ProgramaID` 			VARCHAR(50) 	DEFAULT NULL 	COMMENT 'Parametro de Auditoria',
  `Sucursal` 			INT(11) 		DEFAULT NULL 	COMMENT 'Parametro de Auditoria',
  `NumTransaccion` 		BIGINT(20) 		DEFAULT NULL 	COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`ConsecutivoID`),
  KEY `INDEX_TMPPROCDOMICILIAPAGOS_1` (`FolioID`),
  KEY `INDEX_TMPPROCDOMICILIAPAGOS_2` (`ClienteID`),
  KEY `INDEX_TMPPROCDOMICILIAPAGOS_3` (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla temporal para el registro de Domiciliacion de Pagos para Procesar.'$$
