-- TMPUNIFICATABLACLI
DELIMITER ;
DROP TABLE IF EXISTS `TMPUNIFICATABLACLI`;

DELIMITER $$

CREATE TABLE TMPUNIFICATABLACLI(
NumRegistro				INT 			COMMENT 'Numero Registro',
Tabla 					VARCHAR(50)		COMMENT 'Nombre de Tabla',
CampoDistinto 			CHAR(2)			COMMENT 'Indica si el campo es Disntinto a ClienteID',
Campo					VARCHAR(40)		COMMENT 'Campo',
Condicion 				VARCHAR(60)		COMMENT 'Condicion para realizar el Update',
PRIMARY KEY (`NumRegistro`),
KEY `INDEX_TMPUNIFICATABLACLI_1` (`Tabla`)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp:Tabla temporal para el listado de tablas que tiene el ClienteID.'$$