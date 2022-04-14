DELIMITER ;
DROP TABLE IF EXISTS `TOTALAPLICADOSWSPAG`;

DELIMITER ;
CREATE TABLE `TOTALAPLICADOSWSPAG`(
	`TotalAplicWSPagID` 	BIGINT(20) NOT NULL COMMENT 'Identificador de la tabla',
	`FechaPago` 			DATE DEFAULT NULL COMMENT 'Fecha en que se realiza el pago',
	`CreditoID`				BIGINT(12) NOT NULL COMMENT 'Identificador del credito',
	`ClienteID`				INT(11) NOT NULL COMMENT 'Identificador del cliente',
	`TotalOperacion`		DECIMAL(12,2) DEFAULT NULL COMMENT 'Monto total recibido por el WS',
	`InstitPagoID`			BIGINT(12) DEFAULT NULL COMMENT 'Institucion bancaria de tesoreria',
	`OrigenPago`			VARCHAR(20) NOT NULL DEFAULT 'SERVICIO WEB' COMMENT 'Nombre del servicio WEB',
	`EmpresaID` 			INT(11) 		NOT NULL COMMENT 'Campo de Auditoria',
	`Usuario` 				INT(11) 		NOT NULL COMMENT 'Campo de Auditoria',
	`FechaActual` 			DATETIME 		NOT NULL COMMENT 'Campo de Auditoria',
	`DireccionIP` 			VARCHAR(15)	 	NOT NULL COMMENT 'Campo de Auditoria',
	`ProgramaID` 			VARCHAR(50) 	NOT NULL COMMENT 'Campo de Auditoria',
	`Sucursal` 				INT(11) 		NOT NULL COMMENT 'Campo de Auditoria',
	`NumTransaccion` 		BIGINT(20) 		NOT NULL COMMENT 'Campo de Auditoria',
	PRIMARY KEY(TotalAplicWSPagID)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para registrar los pagos del web service /credit/referencedCreditPayment';