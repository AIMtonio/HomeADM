DELIMITER ;

DROP TABLE IF EXISTS SEGUSUARIOWS;

DELIMITER $$

CREATE TABLE SEGUSUARIOWS (
	`UsuarioID`						INT(11)				NOT NULL		COMMENT 'Identificador de la tabla',
	`NombreCompleto` 				VARCHAR(250) 		NOT NULL		COMMENT 'Nombre completo del usuario',
	`Clave`							VARCHAR(50)			NOT NULL		COMMENT 'Clave del usuario (username)',
	`Contrasenia`					VARCHAR(50)			NOT NULL		COMMENT 'Contrasenia del usuario encriptada (password)',
	`Estatus`						CHAR(1)				NOT NULL		COMMENT 'Estatus del usuario (A = Activo, I = Inactivo, B = Bloqueado, E = Eliminado)',
	`Semilla` 						VARCHAR(50)			NOT NULL		COMMENT 'Semilla para la encriptacion del password',
	`OrigenDatos` 					VARCHAR(50) 		NOT NULL 		COMMENT 'Origen de datos donde se conectara el Usuario.',
	`EmpresaID`						INT(11)				NOT NULL 		COMMENT 'Empresa ID',
	`Usuario`						INT(11)				NOT NULL		COMMENT 'Usuario ID',
	`FechaActual`					DATETIME			NOT NULL		COMMENT 'Fecha Actual',
	`DireccionIP`					VARCHAR(15)			NOT NULL		COMMENT 'Direccion IP',
	`ProgramaID`					VARCHAR(50)			NOT NULL		COMMENT 'Programa de Auditoria',
	`Sucursal`						INT(11)				NOT NULL		COMMENT 'Sucursal ID',
	`NumTransaccion`				BIGINT(20)			NOT NULL		COMMENT 'Numero de Transaccion',

	PRIMARY KEY(`UsuarioID`),
	INDEX `INDEX_SEGROL_1` (`UsuarioID` ASC),
	INDEX `INDEX_SEGROL_2` (`Clave` ASC)
)ENGINE = InnoDB DEFAULT CHARSET=latin1 COMMENT = 'Tab: Tabla para almacenar la informacion de los usuarios.'$$