DELIMITER ;

DROP TABLE IF EXISTS SEGWSREST;

DELIMITER $$

CREATE TABLE SEGWSREST (
	`WSRestID`						INT(11)				NOT NULL		COMMENT 'Identificador de la tabla',
	`ModuloID`						INT(11)				NOT NULL		COMMENT 'Identificador del modulo',
	`NombreWSRest`					VARCHAR(50)			NOT NULL		COMMENT 'Nombre del Web Service',
	`URLWSRest`						VARCHAR(250)		NOT NULL		COMMENT 'Campo para el PATH del WebService (Debe ser solo la URL relativa es decir sin dominio ni proyecto)',
	`Descripcion`					VARCHAR(250)		NOT NULL		COMMENT 'Campo para la descripcion del Web Service',

	`EmpresaID`						INT(11)				NOT NULL 		COMMENT 'Empresa ID',
	`Usuario`						INT(11)				NOT NULL		COMMENT 'Usuario ID',
	`FechaActual`					DATETIME			NOT NULL		COMMENT 'Fecha Actual',
	`DireccionIP`					VARCHAR(15)			NOT NULL		COMMENT 'Direccion IP',
	`ProgramaID`					VARCHAR(50)			NOT NULL		COMMENT 'Programa de Auditoria',
	`Sucursal`						INT(11)				NOT NULL		COMMENT 'Sucursal ID',
	`NumTransaccion`				BIGINT(20)			NOT NULL		COMMENT 'Numero de Transaccion',

	PRIMARY KEY(`WSRestID`),
	INDEX `INDEX_SEGWSREST_1` (`ModuloID` ASC),
	INDEX `INDEX_SEGWSREST_2` (`URLWSRest` ASC),
	CONSTRAINT `FK_SEGWSREST_1` FOREIGN KEY (`ModuloID`) REFERENCES `SISMODULO` (`ModuloID`)
)ENGINE = InnoDB DEFAULT CHARSET=latin1 COMMENT = 'Tab: Tabla para almacenar los distintos Web Service.'$$