-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMP_BANCREDITOS
DELIMITER ;

DROP TABLE IF EXISTS `TMP_BANCREDITOS`;

DELIMITER $$


CREATE TABLE `TMP_BANCREDITOS` (
	ID 						BIGINT(20) NOT NULL AUTO_INCREMENT,		-- Identificador de la tabla
	CreditoID 				BIGINT(12),								-- ID del Credito
	NumTransaccion			BIGINT(20),								-- Numero de transaccion

	INDEX(CreditoID),
	INDEX(NumTransaccion),
	INDEX(CreditoID, NumTransaccion),
	PRIMARY KEY (ID)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tbl: Tabla temporal fisica para guardar la informacion de los Creditos para Servicios REST.'$$
