-- Creacion de tabla CRCBABONOCTAWS

DELIMITER ;

DROP TABLE IF EXISTS `CRCBABONOCTAWS`;

DELIMITER $$

CREATE TABLE `CRCBABONOCTAWS` (
	`CrcbAbonoCtaID`	BIGINT(12)		NOT NULL COMMENT 'Numero Consecutivo de Abono a Cuentas',
	`CuentaAhoID`		BIGINT(12)		NOT NULL COMMENT 'Numero de Cuenta',
	`Monto`				DECIMAL(14,2)	NOT NULL COMMENT 'Monto del Abono',
	`NatMovimiento`		CHAR(1)			NOT NULL COMMENT 'Naturaleza de Movimiento\nA = Abono a Cuentas',
	`Fecha`				DATE			NOT NULL COMMENT 'Fecha del Abono',
	`ReferenciaMov`		VARCHAR(50)		NOT NULL COMMENT 'Referencia del Movimiento',
	`CodigoRastreo`		VARCHAR(200)	NOT NULL COMMENT 'Codigo de Rastreo',
	`EmpresaID` 		INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
	`Usuario` 			INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
	`FechaActual` 		DATETIME 		NOT NULL COMMENT 'Parametro de Auditoria',
	`DireccionIP` 		VARCHAR(20) 	NOT NULL COMMENT 'Parametro de Auditoria',
	`ProgramaID` 		VARCHAR(50) 	NOT NULL COMMENT 'Parametro de Auditoria',
	`Sucursal` 			INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
	`NumTransaccion` 	BIGINT(20) 		NOT NULL COMMENT 'Parametro de Auditoria',
	PRIMARY KEY (`CrcbAbonoCtaID`),
    INDEX `INDEX_CRCBABONOCTAWS_1` (`CuentaAhoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para registrar informacion de Abono a Cuentas.'$$
