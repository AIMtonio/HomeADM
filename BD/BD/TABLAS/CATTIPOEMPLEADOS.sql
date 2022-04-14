-- Creacion de tabla CATTIPOEMPLEADOS

DELIMITER ;

DROP TABLE IF EXISTS `CATTIPOEMPLEADOS`;

DELIMITER $$

CREATE TABLE `CATTIPOEMPLEADOS` (
	`TipoEmpleadoID`		INT(11)			NOT NULL COMMENT 'Numero Consecutivo de Tipo de Empleado',
	`TipoEmpleado`			CHAR(1)			NOT NULL COMMENT 'Nomenclatura Tipo de Empleado',
	`Descripcion`			VARCHAR(150)	NOT NULL COMMENT 'Descripcion del Tipo de Empleado',
    `Estatus`				CHAR(1)			NOT NULL COMMENT 'Estatus del Tipo de Empleado (A = Activo, I = INactivo)',
	`EmpresaID` 			INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
	`Usuario` 				INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
	`FechaActual` 			DATETIME 		NOT NULL COMMENT 'Parametro de Auditoria',
	`DireccionIP` 			VARCHAR(20) 	NOT NULL COMMENT 'Parametro de Auditoria',
	`ProgramaID` 			VARCHAR(50) 	NOT NULL COMMENT 'Parametro de Auditoria',
	`Sucursal` 				INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
	`NumTransaccion` 		BIGINT(20) 		NOT NULL COMMENT 'Parametro de Auditoria',
	PRIMARY KEY (`TipoEmpleadoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='CAT: Catalogo de Tipos de Empleado.'$$