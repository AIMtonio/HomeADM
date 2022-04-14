DELIMITER ;

DROP TABLE IF EXISTS TARARCHIVOCORREO;

DELIMITER $$

CREATE TABLE TARARCHIVOCORREO (
	`ArchivoID`						BIGINT(20)			NOT NULL		COMMENT 'Identificador de los archivos de correo',
	`EnvioCorreoID`					BIGINT(20)			NOT NULL		COMMENT 'Identificador de los correo',
	`NombreArchivo`					VARCHAR(50)			NOT NULL		COMMENT 'Nombre del archivo',
	`Extension`						CHAR(3)				NOT NULL		COMMENT 'Extension del archivo',
	`Archivo`						BLOB				NOT NULL		COMMENT 'Contenido del archivo',
	`PesoByte`						MEDIUMTEXT			NOT NULL		COMMENT 'Peso del Archivo adjunto',

	`EmpresaID`						INT(11)				NOT NULL		COMMENT 'Campo de Auditoria',
	`Usuario`						INT(11)				NOT NULL		COMMENT 'Campo de Auditoria',
	`FechaActual`					DATETIME			NOT NULL		COMMENT 'Campo de Auditoria',
	`DireccionIP`					VARCHAR(15)			NOT NULL		COMMENT 'Campo de Auditoria',
	`ProgramaID`					VARCHAR(50)			NOT NULL		COMMENT 'Campo de Auditoria',
	`Sucursal`						INT(11)				NOT NULL		COMMENT 'Campo de Auditoria',
	`NumTransaccion`				BIGINT(20)			NOT NULL		COMMENT 'Campo de Auditoria',

	PRIMARY KEY(`ArchivoID`),
	INDEX `INDEX_TARARCHIVOCORREO_1`	(`ArchivoID` ASC)
)ENGINE = InnoDB DEFAULT CHARSET=latin1 COMMENT = 'Tabla para almacenar los grupos de correo para envio de correo.'$$ 

