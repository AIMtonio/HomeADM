DELIMITER ;

DROP TABLE IF EXISTS EDOCTAV2TARARCHIVOCORREOHIS;

DELIMITER $$

CREATE TABLE EDOCTAV2TARARCHIVOCORREOHIS (
	`ArchivoID`						BIGINT(20)		UNSIGNED	NOT NULL		COMMENT 'Identificador de los archivos de correo',
	`EnvioCorreoID`					BIGINT(20)		UNSIGNED	NOT NULL		COMMENT 'Identificador de los correo',
	`NombreArchivo`					VARCHAR(50)			NOT NULL		COMMENT 'Nombre del archivo',
	`Extension`						VARCHAR(10)			NOT NULL		COMMENT 'Extension del archivo',
	`Archivo`						VARCHAR(2000)		NOT NULL		COMMENT 'Ruta del archivo que se adjuntara',
	`PesoByte`						LONG				NOT NULL		COMMENT 'Peso del Archivo adjunto',

	`EmpresaID`						INT(11)				NOT NULL		COMMENT 'Campo de Auditoria',
	`Usuario`						INT(11)				NOT NULL		COMMENT 'Campo de Auditoria',
	`FechaActual`					DATETIME			NOT NULL		COMMENT 'Campo de Auditoria',
	`DireccionIP`					VARCHAR(15)			NOT NULL		COMMENT 'Campo de Auditoria',
	`ProgramaID`					VARCHAR(50)			NOT NULL		COMMENT 'Campo de Auditoria',
	`Sucursal`						INT(11)				NOT NULL		COMMENT 'Campo de Auditoria',
	`NumTransaccion`				BIGINT(20)			NOT NULL		COMMENT 'Campo de Auditoria',

	PRIMARY KEY(`ArchivoID`),
	INDEX `INDEX_EDOCTAV2TARARCHIVOCORREOHIS_1`	(`ArchivoID` ASC)
)ENGINE = InnoDB DEFAULT CHARSET=latin1 COMMENT = 'His: Tabla historica para almacenar los archivos de correo para envio de correo.'$$

