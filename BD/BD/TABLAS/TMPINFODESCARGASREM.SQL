-- Creacion de tabla TMPINFODESCARGASREM

DELIMITER ;

DROP TABLE IF EXISTS `TMPINFODESCARGASREM`;

DELIMITER $$

CREATE TABLE `TMPINFODESCARGASREM` (
	`TmpInfoDesRemID`			INT UNSIGNED AUTO_INCREMENT	NOT NULL	COMMENT 'Identificador de la tabla temporal',
	`AuthoNumber`				VARCHAR(30)					NOT NULL	COMMENT 'AUTHO_NUMBER',
	`Status`					CHAR(3)						NOT NULL	COMMENT 'STATUS',
	`OpCode1`					CHAR(3)						NOT NULL	COMMENT 'Codigo para indicar si el registro genero algun error',
	`OpCode2`					CHAR(3)						NOT NULL	COMMENT 'Codigo del error generado',
	`NumTransaccion`			BIGINT(20)					NOT NULL	COMMENT 'Parametro de auditoria',
	PRIMARY KEY (`TmpInfoDesRemID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla temporal para obtener la lista de ordenes que el metodo Notificaciones de Incorporate devolvio'$$