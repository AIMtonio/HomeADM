
DELIMITER ;
DROP TABLE IF EXISTS TMPUSUARIOSSOLICITUDES;
DELIMITER $$
CREATE  TABLE TMPUSUARIOSSOLICITUDES (
	`UsuarioID`               INT(11) COMMENT 'Id del usuario',
	`NumSolicitudes`          INT(11) DEFAULT NULL COMMENT 'Numero de solicitudes asignadas a usuario analista',
	`NombreCompleto`          VARCHAR(200) DEFAULT NULL COMMENT 'Nombre completo usuarios analistas',
	`NumTransaccion`          BIGINT(20) DEFAULT NULL COMMENT 'Campo transaccion',
	PRIMARY KEY (UsuarioID,NumTransaccion)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla temporal para el resgitro de solicitudes a usarios analistas'$$