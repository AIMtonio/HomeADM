-- Creacion de tabla TMPFNMONTOIVAPAGADO

DELIMITER ;

DROP TABLE IF EXISTS `TMPFNMONTOIVAPAGADO`;

DELIMITER $$

CREATE TABLE `TMPFNMONTOIVAPAGADO` (
	`TmpFnMontoIvaID`			INT UNSIGNED		NOT NULL AUTO_INCREMENT	COMMENT 'Identificador de la tabla',
	`CreditoID`					BIGINT(12)			NOT NULL				COMMENT 'Identificador del credito.',
	`AmortizacionID`			INT(11)				NOT NULL				COMMENT 'Identificador de la amortizacion.',
	`TipoMovCreID`				INT(11)				NOT NULL				COMMENT 'Identificador del tipo de movimiento de credito.',
	`NatMovimiento`				CHAR(1)				NOT NULL				COMMENT 'Naturaleza del movimiento',
	`Monto`						DECIMAL(14,2)		NOT NULL				COMMENT 'Monto del pago.',
	`NumTransaccion`			BIGINT(20)			NOT NULL				COMMENT 'Transaccion del pago',
	PRIMARY KEY (`TmpFnMontoIvaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla temporal para almacenar movimientos de credito para el uso de una funcion'$$