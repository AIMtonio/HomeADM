DELIMITER ;
DROP TABLE IF EXISTS EDOCTAV2TMP_DATOSCTE;
DELIMITER $$


CREATE TABLE EDOCTAV2TMP_DATOSCTE (
	RegistroID				BIGINT			NOT NULL AUTO_INCREMENT,
	ClienteID 				INT(11) 		NOT NULL COMMENT 'Numero de cliente',
	PRIMARY KEY(RegistroID)

) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla teporal para registrar los clientes a procesar en la extraccion de datos del estado de cuenta'$$
