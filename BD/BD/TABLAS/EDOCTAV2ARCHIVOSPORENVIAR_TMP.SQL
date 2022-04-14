DELIMITER ;
DROP TABLE IF EXISTS EDOCTAV2ARCHIVOSPORENVIAR_TMP;
DELIMITER $$

CREATE TABLE EDOCTAV2ARCHIVOSPORENVIAR_TMP (
	`EnvioCorreoID`					BIGINT(20)			UNSIGNED NOT NULL   COMMENT 'Identificador de los correos',
	`ClienteID`						INT(1)				UNSIGNED NOT NULL   COMMENT 'Identificador de los correos',
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
	`RemitenteID`					INT(11)				NOT NULL		COMMENT 'Llave foranea a la tabla TARENVIOCORREOPARAM',


	`NumTransaccion`				BIGINT(20)			NOT NULL		COMMENT 'Campo de Auditoria',

	PRIMARY KEY(`EnvioCorreoID`),
	INDEX `INDEX_EDOCTAV2ARCHIVOSPORENVIAR_TMP_1`	(`EnvioCorreoID` ASC),
	CONSTRAINT FK_EDOCTAV2ARCHIVOSPORENVIAR_TMP_1 FOREIGN KEY (RemitenteID) REFERENCES TARENVIOCORREOPARAM (RemitenteID)
)ENGINE = InnoDB DEFAULT CHARSET=latin1 COMMENT = 'Tmp: Tabla para almacenar los correo para enviar.'$$

