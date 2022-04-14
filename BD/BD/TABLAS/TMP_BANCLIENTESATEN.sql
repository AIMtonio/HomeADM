-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMP_BANCLIENTESATEN
DELIMITER ;

DROP TABLE IF EXISTS `TMP_BANCLIENTESATEN`;

DELIMITER $$


CREATE TABLE `TMP_BANCLIENTESATEN` (
	ID 						BIGINT(20) NOT NULL AUTO_INCREMENT,		-- Identificador de la tabla
	ClienteID				INT(11),								-- ID del Cliente
	NumTransaccion			BIGINT(20),								-- Numero de transaccion

	INDEX(ClienteID),
	INDEX(NumTransaccion),
	INDEX(ClienteID, NumTransaccion),
	PRIMARY KEY (ID)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tbl: Tabla temporal fisica para guardar la informacion de los clientes atendidos.'$$
