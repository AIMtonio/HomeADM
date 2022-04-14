-- Creacion de tabla HUELLADIGITALPARAM

DELIMITER ;
DROP TABLE IF EXISTS `HUELLADIGITALPARAM`;

DELIMITER $$
CREATE TABLE `HUELLADIGITALPARAM` (
	`ParametroID`				INT(11)			NOT NULL	COMMENT 'Indica el numero unico de parametro',
	`HuellaMaestra`				INT(11)			NOT NULL	COMMENT 'Se utiliza para la huella maestra Mediante el ROLID',
	`ValidaHuellaRepetida`		CHAR(1)			NOT NULL	COMMENT 'Indica si se realizara el proceso de validacion de huellas repetidas, valores S o N',
	`EnviarCorreoRepetida`		CHAR(1)			NOT NULL	COMMENT 'Indica si se enviara el correo de huella repetida al usuario, valores S o N',
	`EnviarCorreoAutorizada`	CHAR(1)			NOT NULL	COMMENT 'Indica si se enviara el correo de huella autorizada al cliente, valores S o N',
	`LayoutCorreoRepetida`		TEXT			NOT NULL	COMMENT 'Layout html del correo de huella repetida',
	`LayoutCorreoAutorizada`	TEXT			NOT NULL	COMMENT 'Layout html del correo de huella autorizada',
	`RemitenteID`				INT				NOT NULL	COMMENT 'Identificador del remitente de correo',
	`RegistrosPagina`			INT(11)			NOT	NULL	COMMENT 'Indica el número de registros que se validaran por pagina',

	`EmpresaID`					INT(11)			DEFAULT NULL	COMMENT 'Paramteros de Auditoria',
	`Usuario`					INT(11)			DEFAULT NULL	COMMENT 'Paramteros de Auditoria',
	`FechaActual`				DATETIME		DEFAULT NULL	COMMENT 'Paramteros de Auditoria',
	`DireccionIP`				VARCHAR(15)		DEFAULT NULL	COMMENT 'Paramteros de Auditoria',
	`ProgramaID`				VARCHAR(20)		DEFAULT NULL	COMMENT 'Paramteros de Auditoria',
	`Sucursal`					VARCHAR(45)		DEFAULT NULL	COMMENT 'Paramteros de Auditoria',
	`NumTransaccion`			BIGINT(20)		DEFAULT NULL	COMMENT 'Paramteros de Auditoria',
	PRIMARY KEY (`ParametroID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT 'Par: Tabla de Parametros de Huella Digital'$$