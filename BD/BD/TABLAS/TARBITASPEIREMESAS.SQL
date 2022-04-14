-- Creacion de tabla TARBITASPEIREMESAS

DELIMITER ;

DROP TABLE IF EXISTS `TARBITASPEIREMESAS`;

DELIMITER $$

CREATE TABLE `TARBITASPEIREMESAS` (
	`TarBitaSpeiRemID`			INT UNSIGNED AUTO_INCREMENT	NOT NULL	COMMENT 'Identificador de la tabla',
	`SpeiRemID`					BIGINT(20)					NOT NULL	COMMENT 'Identificador de la remesa',
	`ClaveRastreo`				VARCHAR(30)					NOT NULL	COMMENT 'Clave de autorizacion del SPEI. BankAutho.',
	`Metodo`					CHAR(1)						NOT NULL	COMMENT 'Metodo a consumir. R : ReportarPago. D : Devolucion',
	`Estatus`					CHAR(1)						NOT NULL	COMMENT 'Estatus de la depuracion. P : Pendiente. R : Procesada',
	`PIDTarea`					VARCHAR(50)					NOT NULL	COMMENT 'Identificador del hilo de ejecucion de la tarea',
	`Observacion`				VARCHAR(500)				NOT NULL	COMMENT 'Mensaje de exito o error',
	`FechaHoraAlta`				DATETIME					NOT NULL	COMMENT 'Fecha y hora de alta del registro',
	`TransaccionPago`			BIGINT(20)					NOT NULL	COMMENT 'Numero de Transaccion en la que se realizo el pago',
	`EmpresaID`					INT(11)						NOT NULL	COMMENT 'Parametro de auditoria',
	`Usuario`					INT(11)						NOT NULL	COMMENT 'Parametro de auditoria',
	`FechaActual`				DATETIME					NOT NULL	COMMENT 'Parametro de auditoria',
	`DireccionIP`				VARCHAR(15)					NOT NULL	COMMENT 'Parametro de auditoria',
	`ProgramaID`				VARCHAR(50)					NOT NULL	COMMENT 'Parametro de auditoria',
	`Sucursal`					INT(11)						NOT NULL	COMMENT 'Parametro de auditoria',
	`NumTransaccion`			BIGINT(20)					NOT NULL	COMMENT 'Parametro de auditoria',
	PRIMARY KEY (`TarBitaSpeiRemID`),
	INDEX `INDEX_TARBITASPEIREMESAS_1` (`ClaveRastreo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla bitacora para guardar las remesas que aun no han sido procesadas con exito por un metodo de Incorporate'$$