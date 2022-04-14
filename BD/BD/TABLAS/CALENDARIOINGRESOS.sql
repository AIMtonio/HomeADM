-- Creacion de tabla CALENDARIOINGRESOS

DELIMITER ;

DROP TABLE IF EXISTS `CALENDARIOINGRESOS`;

DELIMITER $$

CREATE TABLE `CALENDARIOINGRESOS` (
	`CalendarioIngID`		BIGINT(12)		NOT NULL COMMENT 'Numero Consecutivo de Calendario Ingresos',
	`InstitNominaID`		INT(11)			NOT NULL COMMENT 'Numero de Institucion de Nomina',
	`ConvenioNominaID`		BIGINT UNSIGNED	NOT NULL COMMENT 'Numero de Convenio de Nomina',
    `Anio`					INT(4)			NOT NULL COMMENT 'Anio Registro de Calendario de Ingresos',
	`Estatus`				CHAR(1)			NOT NULL COMMENT 'Estatus Calendario Ingreso R-Registrado, A-Autorizado y D-Desautorizado',
	`FechaLimiteEnvio`		DATE			NOT NULL COMMENT 'Fecha Limite Envio',
	`FechaPrimerDesc`		DATE			NOT NULL COMMENT 'Fecha Primer Descuento',
	`FechaLimiteRecep`		DATE			NOT NULL DEFAULT '1900-01-01' COMMENT 'Fecha limite que se tiene para cargar las incidencias por parte de la institucion de nomina',
    `NumCuotas`	   			INT(11)			NOT NULL COMMENT 'Numero de Cuotas',
    `FechaRegistro`			DATE			NOT NULL COMMENT 'Fecha Registro Calendario Ingreso',
	`EmpresaID` 			INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
	`Usuario` 				INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
	`FechaActual` 			DATETIME 		NOT NULL COMMENT 'Parametro de Auditoria',
	`DireccionIP` 			VARCHAR(20) 	NOT NULL COMMENT 'Parametro de Auditoria',
	`ProgramaID` 			VARCHAR(50) 	NOT NULL COMMENT 'Parametro de Auditoria',
	`Sucursal` 				INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
	`NumTransaccion` 		BIGINT(20) 		NOT NULL COMMENT 'Parametro de Auditoria',
	PRIMARY KEY (`CalendarioIngID`),
    INDEX `INDEX_CALENDARIOINGRESOS_1` (`InstitNominaID`),
    INDEX `INDEX_CALENDARIOINGRESOS_2` (`ConvenioNominaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para registrar informacion del Calendario de Ingresos.'$$