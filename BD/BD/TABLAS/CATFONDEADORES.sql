-- Creacion de tabla CATFONDEADORES

DELIMITER ;

DROP TABLE IF EXISTS `CATFONDEADORES`;

DELIMITER $$

CREATE TABLE `CATFONDEADORES` (
	`CatFondeadorID`	INT(11)			NOT NULL COMMENT 'Identificador de la tabla',
	`TipoFondeador` 	CHAR(1) 		NOT NULL COMMENT 'Tipo Fondeador:\nG = Gubernamental\nF = Persona Fisica\nM = Persona Moral\nA = Persona Fisica Con Actividad Empresarial\nB = Administrador del Fideicomiso Maestro',
	`Descripcion`		VARCHAR(200)	NOT NULL COMMENT 'Descripcion del Fondeador',
    `Estatus` 			CHAR(2) 		NOT NULL DEFAULT 'A' COMMENT 'Estatus del Fondeador\nA = Activo\nI = Inactivo.',
	`EmpresaID` 		INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
	`Usuario` 			INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
	`FechaActual` 		DATETIME 		NOT NULL COMMENT 'Parametro de Auditoria',
	`DireccionIP` 		VARCHAR(20) 	NOT NULL COMMENT 'Parametro de Auditoria',
	`ProgramaID` 		VARCHAR(50) 	NOT NULL COMMENT 'Parametro de Auditoria',
	`Sucursal` 			INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
	`NumTransaccion` 	BIGINT(20) 		NOT NULL COMMENT 'Parametro de Auditoria',
	PRIMARY KEY (`CatFondeadorID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cat: Catalogo de Fondeadores.'$$
