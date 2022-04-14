-- Creacion de tabla BITACORADOMICIPAGOS

DELIMITER ;

DROP TABLE IF EXISTS BITACORADOMICIPAGOS;

DELIMITER $$

CREATE TABLE `BITACORADOMICIPAGOS` (
  `ConsecutivoID` 		BIGINT(20) 		NOT NULL 		COMMENT 'ID Consecutivo',
  `FolioID` 			BIGINT(20) 		DEFAULT NULL 	COMMENT 'ID Folio',
  `Fecha` 				DATETIME 		DEFAULT NULL 	COMMENT 'Fecha Proceso',
  `ClienteID` 			INT(11) 		DEFAULT NULL 	COMMENT 'ID del Cliente',
  `InstitucionID` 		INT(11) 		DEFAULT NULL 	COMMENT 'ID Institucion',
  `CuentaClabe` 		VARCHAR(18) 	DEFAULT NULL 	COMMENT 'Cuenta Clabe',
  `CreditoID` 			BIGINT(12) 		DEFAULT NULL 	COMMENT 'ID Credito',
  `MontoAplicado` 		DECIMAL(14,2) 	DEFAULT NULL 	COMMENT 'Monto Aplicado',
  `MontoNoAplicado` 	DECIMAL(14,2) 	DEFAULT NULL 	COMMENT 'Monto No Aplicado',
  `ClaveDomicilia` 		CHAR(2) 		DEFAULT NULL 	COMMENT 'Clave Domiciliacion\n00 = Exitosa',
  `Reprocesado` 		CHAR(1) 		DEFAULT NULL 	COMMENT 'Reprocesado\nN = NO\nS = SI',
  `InstitNominaID` 		INT(11) 		DEFAULT NULL 	COMMENT 'ID Institucion de Nomina',
  `ConvenioNominaID` 	INT(11) 		DEFAULT NULL 	COMMENT 'ID Convenio',
  `Referencia` 			VARCHAR(100) 	DEFAULT NULL 	COMMENT 'Referencia',
  `Frecuencia` 			CHAR(1) 		DEFAULT NULL 	COMMENT 'Frecuencia de Pago',
  `CuotasPendientes`	INT(11) 		DEFAULT NULL 	COMMENT 'Cuotas Pendientes por Cubrir',
  `MontoPendiente`		INT(11) 		DEFAULT NULL 	COMMENT 'Monto Pendiente por Cubrir',
  `EmpresaID` 			INT(11) 		DEFAULT NULL 	COMMENT 'Parametro de Auditoria',
  `Usuario` 			INT(11) 		DEFAULT NULL 	COMMENT 'Parametro de Auditoria',
  `FechaActual` 		DATETIME 		DEFAULT NULL 	COMMENT 'Parametro de Auditoria',
  `DireccionIP` 		VARCHAR(20) 	DEFAULT NULL 	COMMENT 'Parametro de Auditoria',
  `ProgramaID` 			VARCHAR(50) 	DEFAULT NULL 	COMMENT 'Parametro de Auditoria',
  `Sucursal` 			INT(11) 		DEFAULT NULL 	COMMENT 'Parametro de Auditoria',
  `NumTransaccion` 		BIGINT(20) 		DEFAULT NULL 	COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`ConsecutivoID`),
  KEY `INDEX_BITACORADOMICIPAGOS_1` (`FolioID`),
  KEY `INDEX_BITACORADOMICIPAGOS_2` (`Fecha`),
  KEY `INDEX_BITACORADOMICIPAGOS_3` (`ClienteID`),
  KEY `INDEX_BITACORADOMICIPAGOS_4` (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Bitacora de Domiciliacion de Pagos Procesados.'$$
