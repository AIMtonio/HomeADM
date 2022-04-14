DELIMITER ;
DROP TABLE IF EXISTS EDOCTAV2TARENVIOCORREOHIS;
DELIMITER $$

CREATE TABLE EDOCTAV2TARENVIOCORREOHIS (
	`EnvioCorreoID`					BIGINT(20)			UNSIGNED NOT NULL   COMMENT 'Identificador de los correos',
	`ClienteID`						INT(11)				UNSIGNED NOT NULL   COMMENT 'Identificador de los correos',
	`Periodo`						INT(11)				NOT NULL   		COMMENT 'Identificador de los correos',
	`Contrasenia`					VARCHAR(20)			NOT NULL   		COMMENT 'Identificador de los correos',
	`EmailDestino` 					VARCHAR(500)		NOT NULL		COMMENT 'Correo electronico donde sera enviado el correo',
	`Asunto`						VARCHAR(100)		NOT NULL		COMMENT 'Asunto del correo electronico',
	`Mensaje`						VARCHAR(5000)		NOT NULL		COMMENT 'Contenido del correo electronico',
	`EstatusEnvio`					CHAR(1)				NOT NULL		COMMENT 'Estus de la notificacion, este nacera con la N = No enviado, y podra tener los valores P= Proceso E= Enviado F= Fallo y C= Caducado',
	`FechaEnvio`					DATETIME			NOT NULL		COMMENT 'Fecha y hora de envio del correo',
	`FechaProgramada`				DATETIME			NOT NULL		COMMENT 'Es la fecha con la cual se programa el envio de correo',
	`FechaVencimiento`				DATETIME			NOT NULL		COMMENT 'Es la fecha con la cual se vence el correo',
	`Proceso`						VARCHAR(50)			NOT NULL		COMMENT 'Nombre del proceso por el cual se envio el correo',
	`PIDTarea`						VARCHAR(50)			NOT NULL		COMMENT 'Identificador del hilo de ejecucion de la tarea',
	`DescripcionError`				VARCHAR(5000)		NOT NULL		COMMENT 'Descripcion del error en caso que el correo no se envie',
	`RemitenteID`					INT(11)				NOT NULL		COMMENT 'Llave foranea a la tabla TARENVIOCORREOPARAM',

	`EmpresaID`						INT(11)				NOT NULL		COMMENT 'Campo de Auditoria',
	`Usuario`						INT(11)				NOT NULL		COMMENT 'Campo de Auditoria',
	`FechaActual`					DATETIME			NOT NULL		COMMENT 'Campo de Auditoria',
	`DireccionIP`					VARCHAR(15)			NOT NULL		COMMENT 'Campo de Auditoria',
	`ProgramaID`					VARCHAR(50)			NOT NULL		COMMENT 'Campo de Auditoria',
	`Sucursal`						INT(11)				NOT NULL		COMMENT 'Campo de Auditoria',
	`NumTransaccion`				BIGINT(20)			NOT NULL		COMMENT 'Campo de Auditoria',

	PRIMARY KEY(`EnvioCorreoID`),
	INDEX `INDEX_EDOCTAV2TARENVIOCORREOHIS_1`	(`EnvioCorreoID` ASC),
	INDEX `INDEX_EDOCTAV2TARENVIOCORREOHIS_2`	(`PIDTarea` ASC),
	CONSTRAINT FK_EDOCTAV2TARENVIOCORREOHIS_1 FOREIGN KEY (RemitenteID) REFERENCES TARENVIOCORREOPARAM (RemitenteID)
)ENGINE = InnoDB DEFAULT CHARSET=latin1 COMMENT = 'His: Tabla historica para almacenar los correo para enviar.'$$

