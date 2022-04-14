-- Creacion de tabla HUELLADUPLICIDAD
DELIMITER ;
DROP TABLE IF EXISTS `HUELLADUPLICIDAD`;

DELIMITER $$
CREATE TABLE `HUELLADUPLICIDAD` (
	`AutRegistroID`					BIGINT UNSIGNED AUTO_INCREMENT 		COMMENT 'Consecutivo del Registro',
	`PIDTarea`						VARCHAR(50)			NOT NULL		COMMENT 'Identificador del hilo de ejecucion de la tarea',
	`FechaDeteccion`				DATETIME			NOT NULL		COMMENT 'Fecha y hora de la deteccion de duplicidad',
	`HuellaDigitalIDEvaluada`		INT(11)				NOT NULL		COMMENT 'Identificador de la huella evaluada, Ref. HUELLADIGITAL',
	`TipoPersonaEvaluada`			CHAR(1)				NOT NULL		COMMENT 'Tipo de Persona Evaluada',
	`PersonaIDEvaluada`				INT					NOT NULL		COMMENT 'Identificador de Persona Evaluada',
	`TipoPersonaDuplicidad`			CHAR(1)				NOT NULL		COMMENT 'Tipo de Persona con la que se encontro duplicidad',
	`PersonaIDDuplicidad`			INT					NOT NULL		COMMENT 'Identificador de la persona con duplicidad',
	`HuellaUnoEvaluada`				VARBINARY(4000)		DEFAULT NULL	COMMENT 'Huella uno de la persona evaluada',
	`FmdHuellaUnoEvaluada`			VARBINARY(4000)		DEFAULT NULL	COMMENT 'Fmd para validar duplicidad de huella de la persona evaluada',
	`DedoHuellaUnoEvaluada`			CHAR(1)				DEFAULT NULL	COMMENT 'Dedo capturado. I .- Indice, M .- Medio, A .- Anular, N .- Menique, P .- Pulgar',
	`HuellaDosEvaluada`				VARBINARY(4000)		DEFAULT NULL	COMMENT 'Dedo dos de la persona evaluada',
	`FmdHuellaDosEvaluada`			VARBINARY(4000)		DEFAULT NULL	COMMENT 'Fmd para validar duplicidad de huella de la persona evaluada',
	`DedoHuellaDosEvaluada`			CHAR(1)				DEFAULT NULL	COMMENT 'Dedo capturado. I .- Indice, M .- Medio, A .- Anular, N .- Menique, P .- Pulgar',

	`EmpresaID`						INT(11)				NOT NULL 		COMMENT 'Empresa ID',
	`Usuario`						INT(11)				NOT NULL		COMMENT 'Usuario ID',
	`FechaActual`					DATETIME			NOT NULL		COMMENT 'Fecha Actual',
	`DireccionIP`					VARCHAR(15)			NOT NULL		COMMENT 'Direccion IP',
	`ProgramaID`					VARCHAR(50)			NOT NULL		COMMENT 'Programa de Auditoria',
	`Sucursal`						INT(11)				NOT NULL		COMMENT 'Sucursal ID',
	`NumTransaccion`				BIGINT(20)			NOT NULL		COMMENT 'Numero de Transaccion',

	PRIMARY KEY(`AutRegistroID`)
)ENGINE = InnoDB DEFAULT CHARSET=latin1 COMMENT = 'Tab: Tabla para almacenar la bitacora de ejecucion de la validacion de huella duplicada.'$$
