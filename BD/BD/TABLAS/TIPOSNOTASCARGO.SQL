-- Creacion de tabla TIPOSNOTASCARGO

DELIMITER ;

DROP TABLE IF EXISTS `TIPOSNOTASCARGO`;

DELIMITER $$

CREATE TABLE `TIPOSNOTASCARGO` (
	`TipoNotaCargoID`			INT(11)				NOT NULL	COMMENT 'Identificador de la tabla.',
	`NombreCorto`				VARCHAR(50)			NOT NULL	COMMENT 'Nombre corto de la nota de cargo.',
	`Descripcion`				VARCHAR(500)		NOT NULL	COMMENT 'Descripcion de la nota de cargo.',
	`Estatus`					CHAR(1)				NOT NULL	COMMENT 'Estatus del tipo de nota. A = Activo. I = Inactivo.',
	`CobraIVA`					CHAR(1)				NOT NULL	COMMENT 'Indica si el tipo de nota cobra o no cobra un IVA correspondiente. S = Si. N = No.',
	`EmpresaID`					INT(11)				NOT NULL	COMMENT 'Parametro de auditoria.',
	`Usuario`					INT(11)				NOT NULL	COMMENT 'Parametro de auditoria.',
	`FechaActual`				DATETIME			NOT NULL	COMMENT 'Parametro de auditoria.',
	`DireccionIP`				VARCHAR(15)			NOT NULL	COMMENT 'Parametro de auditoria.',
	`ProgramaID`				VARCHAR(50)			NOT NULL	COMMENT 'Parametro de auditoria.',
	`Sucursal`					INT(11)				NOT NULL	COMMENT 'Parametro de auditoria.',
	`NumTransaccion`			BIGINT(20)			NOT NULL	COMMENT 'Parametro de auditoria.',
	PRIMARY KEY (`TipoNotaCargoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para almacenar los tipos de notas de cargo.'$$