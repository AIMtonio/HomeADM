DELIMITER ;

DROP TABLE IF EXISTS SEGOPCIONWSREST;

DELIMITER $$

CREATE TABLE SEGOPCIONWSREST (
	`WSRestID`						INT(11)				NOT NULL		COMMENT 'Identificador del Web Service (SEGWSREST)',
	`RolID`							INT(11)				NOT NULL		COMMENT 'Identificador del Rol (SEGROL)',

	`EmpresaID`						INT(11)				NOT NULL 		COMMENT 'Empresa ID',
	`Usuario`						INT(11)				NOT NULL		COMMENT 'Usuario ID',
	`FechaActual`					DATETIME			NOT NULL		COMMENT 'Fecha Actual',
	`DireccionIP`					VARCHAR(15)			NOT NULL		COMMENT 'Direccion IP',
	`ProgramaID`					VARCHAR(50)			NOT NULL		COMMENT 'Programa de Auditoria',
	`Sucursal`						INT(11)				NOT NULL		COMMENT 'Sucursal ID',
	`NumTransaccion`				BIGINT(20)			NOT NULL		COMMENT 'Numero de Transaccion',

	PRIMARY KEY(`WSRestID`, `RolID`),
	INDEX `INDEX_SEGOPCIONWSREST_1`	(`WSRestID` ASC),
	INDEX `INDEX_SEGOPCIONWSREST_2` (`RolID` ASC),
	CONSTRAINT `FK_SEGOPCIONWSREST_1` FOREIGN KEY (`WSRestID`)	REFERENCES `SEGWSREST` (`WSRestID`),
	CONSTRAINT `FK_SEGOPCIONWSREST_2` FOREIGN KEY (`RolID`) REFERENCES `SEGROL` (`RolID`)
)ENGINE = InnoDB DEFAULT CHARSET=latin1 COMMENT = 'Tab: Tabla para almacenar la realacion de los roles permitidos para acceder a un Web Service.'$$