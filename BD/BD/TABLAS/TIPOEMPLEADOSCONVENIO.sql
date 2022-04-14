-- Creacion de tabla TIPOEMPLEADOSCONVENIO

DELIMITER ;

DROP TABLE IF EXISTS `TIPOEMPLEADOSCONVENIO`;

DELIMITER $$

CREATE TABLE `TIPOEMPLEADOSCONVENIO` (
	`TipoEmpleadoConvID`	BIGINT(12)		NOT NULL COMMENT 'Numero Consecutivo de Tipo Empleados Convenio',
	`InstitNominaID`		INT(11)			NOT NULL COMMENT 'Numero de Institucion de Nomina',
	`ConvenioNominaID`		BIGINT UNSIGNED	NOT NULL COMMENT 'Numero de Convenio de Nomina',
	`TipoEmpleadoID`		INT(11)			NOT NULL COMMENT 'Identificador del Tipo de Empleado',
	`SinTratamiento`		DECIMAL(12,2)	NOT NULL COMMENT 'Porcentaje de Capacidad Sin tratamiento',
	`ConTratamiento`	    DECIMAL(12,2)	NOT NULL COMMENT 'Porcentaje de Capacidad Con tratamiento',
    `EstatusCheck`	   		CHAR(1)			NOT NULL COMMENT 'Estatus seleccionado.-S / no seleccionado.-N',
	`EmpresaID` 			INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
	`Usuario` 				INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
	`FechaActual` 			DATETIME 		NOT NULL COMMENT 'Parametro de Auditoria',
	`DireccionIP` 			VARCHAR(20) 	NOT NULL COMMENT 'Parametro de Auditoria',
	`ProgramaID` 			VARCHAR(50) 	NOT NULL COMMENT 'Parametro de Auditoria',
	`Sucursal` 				INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
	`NumTransaccion` 		BIGINT(20) 		NOT NULL COMMENT 'Parametro de Auditoria',
	PRIMARY KEY (`TipoEmpleadoConvID`),
    INDEX `INDEX_TIPOEMPLEADOSCONVENIO_1` (`InstitNominaID`),
    INDEX `INDEX_TIPOEMPLEADOSCONVENIO_2` (`ConvenioNominaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para registrar informacion de Tipo Empleado Convenio.'$$