-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RATIOSPUNTOS
DELIMITER ;
DROP TABLE IF EXISTS `RATIOSPUNTOS`;DELIMITER $$

CREATE TABLE `RATIOSPUNTOS` (
  `RatiosPuntosID` int(11) NOT NULL,
  `RatiosPorClasifID` int(11) DEFAULT NULL,
  `Descripcion` varchar(500) DEFAULT NULL COMMENT 'Descripcion de los valores a ponderar',
  `LimiteInferior` decimal(12,2) DEFAULT NULL COMMENT 'Este campo aplica cuando es un rango ',
  `LimiteSuperior` decimal(12,2) DEFAULT NULL COMMENT 'Este campo aplica cuando es un Rango',
  `Puntos` decimal(12,2) DEFAULT NULL COMMENT 'Puntaje correspondiente a cada valor a ponderar ',
  PRIMARY KEY (`RatiosPuntosID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Parametrizacion donde se indica los puntos maximo q'$$