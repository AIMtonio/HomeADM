DELIMITER ;

DROP TABLE IF EXISTS SEGWSRESTCANAL;

DELIMITER $$

CREATE TABLE SEGWSRESTCANAL (
	`WSRestID`						INT(11)				NOT NULL		COMMENT 'Identificador del Web Service (SEGWSREST)',
	`CanalID`						INT(11)				NOT NULL		COMMENT 'Identificador del Canal (SEGCANALES)',

	`EmpresaID`						INT(11)				NOT NULL 		COMMENT 'Empresa ID',
	`Usuario`						INT(11)				NOT NULL		COMMENT 'Usuario ID',
	`FechaActual`					DATETIME			NOT NULL		COMMENT 'Fecha Actual',
	`DireccionIP`					VARCHAR(15)			NOT NULL		COMMENT 'Direccion IP',
	`ProgramaID`					VARCHAR(50)			NOT NULL		COMMENT 'Programa de Auditoria',
	`Sucursal`						INT(11)				NOT NULL		COMMENT 'Sucursal ID',
	`NumTransaccion`				BIGINT(20)			NOT NULL		COMMENT 'Numero de Transaccion',

	PRIMARY KEY(`WSRestID`, `CanalID`),
	INDEX `INDEX_SEGWSRESTCANAL_1` (`WSRestID` ASC),
	INDEX `INDEX_SEGWSRESTCANAL_2` (`CanalID` ASC),
	CONSTRAINT `FK_SEGWSRESTCANAL_1` FOREIGN KEY (`WSRestID`) REFERENCES `SEGWSREST` (`WSRestID`),
	CONSTRAINT `FK_SEGWSRESTCANAL_2` FOREIGN KEY (`CanalID`) REFERENCES `SEGCANALES` (`CanalID`)
)ENGINE = InnoDB DEFAULT CHARSET=latin1 COMMENT = 'Tab: Tabla para almacenar la relacion de los canales permitidos para acceder al Web Service.'$$