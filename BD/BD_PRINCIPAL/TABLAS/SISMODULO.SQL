
DELIMITER ;

DROP TABLE IF EXISTS SISMODULO;

DELIMITER $$

CREATE TABLE SISMODULO (
	`ModuloID`						INT(11)				NOT NULL		COMMENT 'Identificador de la tabla',
	`NombreModulo`					VARCHAR(50)			NOT NULL		COMMENT 'Nombre del Modulo',
	`Descripcion`					VARCHAR(250)		NOT NULL		COMMENT 'Descripcion del Modulo',
	
	`EmpresaID`						INT(11)				NOT NULL 		COMMENT 'Empresa ID',
	`Usuario`						INT(11)				NOT NULL		COMMENT 'Usuario ID',
	`FechaActual`					DATETIME			NOT NULL		COMMENT 'Fecha Actual',
	`DireccionIP`					VARCHAR(15)			NOT NULL		COMMENT 'Direccion IP',
	`ProgramaID`					VARCHAR(50)			NOT NULL		COMMENT 'Programa de Auditoria',
	`Sucursal`						INT(11)				NOT NULL		COMMENT 'Sucursal ID',
	`NumTransaccion`				BIGINT(20)			NOT NULL		COMMENT 'Numero de Transaccion',

	PRIMARY KEY(`ModuloID`),
	INDEX `INDEX_SISMODULO_1` (`ModuloID` ASC)
)ENGINE = InnoDB DEFAULT CHARSET=latin1 COMMENT = 'Tab: Tabla para almacenar los Modulos de los usuarios.'$$
