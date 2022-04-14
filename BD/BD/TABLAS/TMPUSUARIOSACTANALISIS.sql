
DELIMITER ;   
DROP TABLE IF EXISTS TMPUSUARIOSACTANALISIS;
DELIMITER $$
CREATE  TABLE TMPUSUARIOSACTANALISIS (
`UsuarioID`               INT(11)  COMMENT 'Id del usuario',
`NombreCompleto`          VARCHAR(200) DEFAULT NULL COMMENT 'Nombre completo usuario analista',
`NumTransaccion`          BIGINT(20) DEFAULT NULL COMMENT 'Campo transaccion',
PRIMARY KEY (UsuarioID,NumTransaccion)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla temporal para usuarios analistas asignados a una solicitud'$$