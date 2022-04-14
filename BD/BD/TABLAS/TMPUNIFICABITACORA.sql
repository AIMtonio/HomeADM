-- TMPUNIFICABITACORA
DELIMITER ;
DROP TABLE IF EXISTS `TMPUNIFICABITACORA`;

DELIMITER $$

CREATE TABLE TMPUNIFICABITACORA(
NumRegistro			INT 			COMMENT 'Numero Registro',
Tabla				VARCHAR(50)		COMMENT 'Nombre de Tabla',
Registro 			DECIMAL(12,0) DEFAULT 0 COMMENT 'Cantidad de Registros',
Estatus				CHAR(1)			COMMENT 'P= Pendiente, U= Unificado',
Sentencia			VARCHAR(5000) 	COMMENT 'Sentencia de actualizacion',
PRIMARY KEY (`NumRegistro`),
KEY `INDEX_TMPUNIFICABITACORA_1` (`Tabla`)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp:Tabla temporal para las tablas que han actualizado el ClienteID.'$$
