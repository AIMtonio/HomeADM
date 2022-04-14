-- TMPGENERALOTTARPRO
DELIMITER ;
DROP TABLE IF EXISTS `TMPGENERALOTTARPRO`;
DELIMITER $$

CREATE TABLE `TMPGENERALOTTARPRO` (
	`TmpGeneraLotTarProID`	INT(11) NOT NULL COMMENT 'Identificador de la tabla',
	`EstatusProceso`		CHAR(1) DEFAULT 'I' COMMENT 'Indicador si el proceso esta ejecutandose A = Activo  I= Inactivo',
	PRIMARY KEY (`TmpGeneraLotTarProID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP:Tabla temporal para identificar si el proceso de Generacion de Lote de Tarjeta esta Activo'$$