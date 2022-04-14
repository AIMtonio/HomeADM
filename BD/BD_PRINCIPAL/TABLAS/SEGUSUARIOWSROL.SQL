DELIMITER ;

DROP TABLE IF EXISTS SEGUSUARIOWSROL;

DELIMITER $$

CREATE TABLE SEGUSUARIOWSROL (
	`UsuarioID`						INT(11)				NOT NULL		COMMENT 'Identificador del Usuario (SEGUSUARIOWS)',
	`RolID`							INT(11)				NOT NULL 		COMMENT 'Identificador del Rol (SEGROL',

	`EmpresaID`						INT(11)				NOT NULL 		COMMENT 'Empresa ID',
	`Usuario`						INT(11)				NOT NULL		COMMENT 'Usuario ID',
	`FechaActual`					DATETIME			NOT NULL		COMMENT 'Fecha Actual',
	`DireccionIP`					VARCHAR(15)			NOT NULL		COMMENT 'Direccion IP',
	`ProgramaID`					VARCHAR(50)			NOT NULL		COMMENT 'Programa de Auditoria',
	`Sucursal`						INT(11)				NOT NULL		COMMENT 'Sucursal ID',
	`NumTransaccion`				BIGINT(20)			NOT NULL		COMMENT 'Numero de Transaccion',

	PRIMARY KEY(`UsuarioID`, `RolID`),
	INDEX `INDEX_SEGUSUARIOWSROL_1`	(`UsuarioID` ASC),
	INDEX `INDEX_SEGUSUARIOWSROL_2` (`RolID` ASC),
	CONSTRAINT `FK_SEGUSUARIOWSROL_1` FOREIGN KEY (`UsuarioID`)	REFERENCES `SEGUSUARIOWS` (`UsuarioID`),
	CONSTRAINT `FK_SEGUSUARIOWSROL_2` FOREIGN KEY (`RolID`) REFERENCES `SEGROL` (`RolID`)
)ENGINE = InnoDB DEFAULT CHARSET=latin1 COMMENT = 'Tab: Tabla para almacenar los roles asignados a un usuario'$$