-- Creacion de tabla BITACORAHUELLAPROCESO
DELIMITER ;

DROP TABLE IF EXISTS `BITACORAHUELLAPROCESO`;

DELIMITER $$

CREATE TABLE `BITACORAHUELLAPROCESO` (
	`AutRegistroID`			BIGINT UNSIGNED AUTO_INCREMENT		COMMENT 'Consecutivo del Registro',
	`PIDTarea`				VARCHAR(50)			NOT NULL		COMMENT 'Identificador del hilo de ejecucion de la tarea',
	`FechaInicio`			DATETIME			NOT NULL		COMMENT 'Fecha y hora del inicio',
	`Estatus`				CHAR(1)				NOT NULL		COMMENT 'Estatus del Proceso: P - Proceso, T: Terminado',
	`HuellasNuevas`			INT					NOT NULL		COMMENT 'Mensaje de la tarea',
	`HuellasSAFI`			INT					NOT NULL		COMMENT 'Mensaje de la tarea',
	`HuellasRepetidas`		INT					NOT NULL		COMMENT 'Mensaje de la tarea',
	`HuellasAutorizadas`	INT					NOT NULL		COMMENT 'Mensaje de la tarea',
	`FechaFin`				DATETIME			NOT NULL		COMMENT 'Fecha y hora de termino',

	`EmpresaID`				INT(11)				NOT NULL 		COMMENT 'Empresa ID',
	`Usuario`				INT(11)				NOT NULL		COMMENT 'Usuario ID',
	`FechaActual`			DATETIME			NOT NULL		COMMENT 'Fecha Actual',
	`DireccionIP`			VARCHAR(15)			NOT NULL		COMMENT 'Direccion IP',
	`ProgramaID`			VARCHAR(50)			NOT NULL		COMMENT 'Programa de Auditoria',
	`Sucursal`				INT(11)				NOT NULL		COMMENT 'Sucursal ID',
	`NumTransaccion`		BIGINT(20)			NOT NULL		COMMENT 'Numero de Transaccion',

	PRIMARY KEY(`AutRegistroID`),
	INDEX IDX_BITACORAHUELLAPROCESO_1 (`Estatus`)
)ENGINE = InnoDB DEFAULT CHARSET=latin1 COMMENT = 'Tab: Tabla para almacenar la bitacora de ejecucion de la validacion de huella duplicada.'$$