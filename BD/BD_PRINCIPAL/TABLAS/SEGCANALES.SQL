DELIMITER ;

DROP TABLE IF EXISTS SEGCANALES;

DELIMITER $$

CREATE TABLE SEGCANALES (
	`CanalID`						INT(11)				NOT NULL		COMMENT 'Identificador de la tabla',
	`NombreCanal`					VARCHAR(50)			NOT NULL		COMMENT 'Nombre del Canal',
	`EmpresaID`						INT(11)				NOT NULL 		COMMENT 'Empresa ID',
	`Usuario`						INT(11)				NOT NULL		COMMENT 'Usuario ID',
	`FechaActual`					DATETIME			NOT NULL		COMMENT 'Fecha Actual',
	`DireccionIP`					VARCHAR(15)			NOT NULL		COMMENT 'Direccion IP',
	`ProgramaID`					VARCHAR(50)			NOT NULL		COMMENT 'Programa de Auditoria',
	`Sucursal`						INT(11)				NOT NULL		COMMENT 'Sucursal ID',
	`NumTransaccion`				BIGINT(20)			NOT NULL		COMMENT 'Numero de Transaccion',
	PRIMARY KEY(`CanalID`),
	INDEX `INDEX_SEGCANALES_1` (`CanalID` ASC)
)ENGINE = InnoDB DEFAULT CHARSET=latin1 COMMENT = 'Tab: Tabla para almacenar los Canales de acceso de los Web Service.'$$