DELIMITER ;

DROP TABLE IF EXISTS SEGROL;

DELIMITER $$

CREATE TABLE SEGROL (
	`RolID`							INT(11)				NOT NULL		COMMENT 'Identificador de la tabla',
	`NombreRol`						VARCHAR(60)			NOT NULL		COMMENT 'Nombre del Rol',
	`Descripcion`					VARCHAR(100)		NOT NULL		COMMENT 'Descripcion del Rol',

	`EmpresaID`						INT(11)				NOT NULL 		COMMENT 'Empresa ID',
	`Usuario`						INT(11)				NOT NULL		COMMENT 'Usuario ID',
	`FechaActual`					DATETIME			NOT NULL		COMMENT 'Fecha Actual',
	`DireccionIP`					VARCHAR(15)			NOT NULL		COMMENT 'Direccion IP',
	`ProgramaID`					VARCHAR(50)			NOT NULL		COMMENT 'Programa de Auditoria',
	`Sucursal`						INT(11)				NOT NULL		COMMENT 'Sucursal ID',
	`NumTransaccion`				BIGINT(20)			NOT NULL		COMMENT 'Numero de Transaccion',

	PRIMARY KEY(`RolID`),
	INDEX `INDEX_SEGROL_1` (`RolID` ASC)
)ENGINE = InnoDB DEFAULT CHARSET=latin1 COMMENT = 'Tab: Tabla para almacenar los Roles de los usuarios.'$$