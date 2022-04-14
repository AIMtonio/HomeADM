-- TMPUNIFICABUSQUEDACLI
DELIMITER ;
DROP TABLE IF EXISTS `TMPUNIFICABUSQUEDACLI`;
DELIMITER $$

CREATE TABLE TMPUNIFICABUSQUEDACLI(
NumRegistro				INT(11)			COMMENT 'Numero Registro',
ClienteID				INT(11) 		COMMENT 'Numero de ClienteID',
RFC						CHAR(13) 		DEFAULT NULL COMMENT 'Registro Federal de Contribuyentes del Cliente',
CURP 					CHAR(18) 		DEFAULT NULL COMMENT 'Clave Unica de Registro Poblacional',
CP 						CHAR(5) 		DEFAULT NULL COMMENT 'Codigo Postal',
Existe 					CHAR(1) 		DEFAULT 'N' COMMENT 'Existe el CLiente, N=No Existe, S=Si Existe, C=Creado',
ClienteIDUpd 			INT(11) 		DEFAULT NULL COMMENT 'Numero de Cliente Unificado Cartera',
Sentencia				VARCHAR(5000) 	DEFAULT '' COMMENT 'Sentencia de actualizacion',
NumErr 					INT(11) 		DEFAULT NULL COMMENT 'Numero de Error de Creacion Cliente Cartera',
ErrMen 					VARCHAR(400)	DEFAULT NULL COMMENT 'Mensaje de Error de Creacion Cliente Cartera',
PRIMARY KEY (`NumRegistro`),
KEY `INDEX_TMPUNIFICABUSQUEDACLI_1` (`ClienteID`)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp:Tabla para realiza la busqueda del cliente a unificar.'$$
