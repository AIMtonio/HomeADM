-- Creacion de tabla NOTASCARGO

DELIMITER ;

DROP TABLE IF EXISTS `NOTASCARGO`;

DELIMITER $$

CREATE TABLE `NOTASCARGO` (
	`NotaCargoID`				BIGINT(20)			NOT NULL	COMMENT 'Identificador de la tabla.',
	`CreditoID`					BIGINT(12)			NOT NULL	COMMENT 'Identificador del credito.',
	`AmortizacionID`			INT(11)				NOT NULL	COMMENT 'Identificador de la amortizacion.',
	`FechaRegistro`				DATE				NOT NULL	COMMENT 'Fecha de alta del registro.',
	`TipoNotaCargoID`			INT(11)				NOT NULL	COMMENT 'Identificador del tipo de nota de cargo. Tabla TIPOSNOTASCARGO.',
	`Monto`						DECIMAL(14,2)		NOT NULL	COMMENT 'Monto a pagar.',
	`IVA`						DECIMAL(14,2)		NOT NULL	COMMENT 'Monto de iva a pagar',
	`Referencia`				BIGINT(20)			NOT NULL	COMMENT 'Numero de referencia en caso que la nota ya haya sido pagada.',
	`Motivo`					VARCHAR(2000)		NOT NULL	COMMENT 'Motivo por el cual se realizo la nota de cargo al credito por parte del usuario',
	`Capital`					DECIMAL(14,2)		NOT NULL	COMMENT 'Monto de capital de la amortizacion al momento del alta de la nota.',
	`Interes`					DECIMAL(14,2)		NOT NULL	COMMENT 'Monto de interes de la amortizacion al momento del alta de la nota.',
	`IVAInteres`				DECIMAL(14,2)		NOT NULL	COMMENT 'Monto de iva de interes de la amortizacion al momento del alta de la nota.',
	`Moratorio`					DECIMAL(14,2)		NOT NULL	COMMENT 'Monto de moratorio de la amortizacion al momento del alta de la nota.',
	`IVAMoratorio`				DECIMAL(14,2)		NOT NULL	COMMENT 'Monto de iva de moratorio de la amortizacion al momento del alta de la nota.',
	`OtrasComisiones`			DECIMAL(14,2)		NOT NULL	COMMENT 'Monto de otras comisiones de la amortizacion al momento del alta de la nota.',
	`IVAComisiones`				DECIMAL(14,2)		NOT NULL	COMMENT 'Monto de iva de comisiones de la amortizacion al momento del alta de la nota.',
	`TotalPago`					DECIMAL(14,2)		NOT NULL	COMMENT 'Monto total pagado de la nota de cargo',
	`Estatus`					CHAR(1)				NOT NULL	COMMENT 'Estatus de la nota de cargo. R = Registrada. P = Pagada.',
	`TranPagoCredito`			BIGINT(20)			NOT NULL	COMMENT 'Numero de transaccion del pago de credito al que se le aplico una nota de pago no reconocido.',
	`AmortizacionPago`			INT(11)				NOT NULL	COMMENT 'Identificador de la amortizacion de un pago de credito',
	`EmpresaID`					INT(11)				NOT NULL	COMMENT 'Parametro de auditoria',
	`Usuario`					INT(11)				NOT NULL	COMMENT 'Parametro de auditoria',
	`FechaActual`				DATETIME			NOT NULL	COMMENT 'Parametro de auditoria',
	`DireccionIP`				VARCHAR(15)			NOT NULL	COMMENT 'Parametro de auditoria',
	`ProgramaID`				VARCHAR(50)			NOT NULL	COMMENT 'Parametro de auditoria',
	`Sucursal`					INT(11)				NOT NULL	COMMENT 'Parametro de auditoria',
	`NumTransaccion`			BIGINT(20)			NOT NULL	COMMENT 'Parametro de auditoria',
	PRIMARY KEY (`NotaCargoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para almacenar las notas de cargo aplicadas a creditos'$$