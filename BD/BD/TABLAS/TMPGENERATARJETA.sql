
-- TMPGENERATARJETA
DELIMITER ;
DROP TABLE IF EXISTS `TMPGENERATARJETA`;
DELIMITER $$

CREATE TABLE `TMPGENERATARJETA` (
	`TmpGeneraTarjetaID`	INT(11) NOT NULL COMMENT 'Identificador de la tabla',
	`EstatusProceso`		CHAR(1) DEFAULT 'I' COMMENT 'Indicador si el proceso esta ejecutandose A = Activo  I= Inactivo',
	PRIMARY KEY (`TmpGeneraTarjetaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP:Tabla temporal para identificar si el proceso de Generacion de Tarjeta esta Activo'$$