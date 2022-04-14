-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMP_BANCAJEROS
DELIMITER ;

DROP TABLE IF EXISTS `TMP_BANCAJEROS`;

DELIMITER $$


CREATE TABLE `TMP_BANCAJEROS` (
	ID 						BIGINT(20) NOT NULL AUTO_INCREMENT,		-- Identificador de la tabla
	CajaID 					INT(11),								-- ID de la Caja de Ventanilla
    UsuarioID				INT(11),								-- ID del Usuario
    PromotorID 				INT(11),								-- ID del Promotor
	NumTransaccion			BIGINT(20),								-- Numero de transaccion

	INDEX(CajaID),
	INDEX(UsuarioID),
	INDEX(PromotorID),
	INDEX(NumTransaccion),
	PRIMARY KEY (ID)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tbl: Tabla temporal fisica para guardar la informacion de los Creditos para Servicios REST.'$$
