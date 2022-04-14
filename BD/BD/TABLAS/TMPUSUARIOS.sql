-- Creacion de tabla TMPUSUARIOS

DELIMITER ;

DROP TABLE IF EXISTS TMPUSUARIOS;

DELIMITER $$

CREATE TABLE TMPUSUARIOS (
	TmpUsuarioID			INT(11) UNSIGNED PRIMARY KEY AUTO_INCREMENT	COMMENT	'Identificador Auto incremental',
	UsuarioID				INT(11)			NOT NULL	COMMENT 'ID del Usuario',
	Contrasenia				VARCHAR(100)	NOT NULL	COMMENT 'Contraseña Encritpda del usuario',
	Clave					VARCHAR(45)		NOT NULL	COMMENT 'Clave',
	EmpresaID				INT(11)			DEFAULT NULL COMMENT 'Empresa ID',
	Usuario					INT(11)			DEFAULT NULL COMMENT 'Campo de Auditoria',
	FechaActual				DATETIME		DEFAULT NULL COMMENT 'Campo de Auditoria',
	DireccionIP				VARCHAR(15)		DEFAULT NULL COMMENT 'Campo de Auditoria',
	ProgramaID				VARCHAR(50)		DEFAULT NULL COMMENT 'Campo de Auditoria',
	Sucursal				INT(11)			DEFAULT NULL COMMENT 'Campo de Auditoria',
	NumTransaccion			BIGINT(20)		DEFAULT NULL COMMENT 'Campo de Auditoria',
	INDEX(UsuarioID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla temporal para Guardar los usuarios logueadas ultimamente'$$