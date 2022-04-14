-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GENSOLICITUDES
DELIMITER ;
DROP TABLE IF EXISTS `GENSOLICITUDES`;DELIMITER $$

CREATE TABLE `GENSOLICITUDES` (
  `ID` int(11) NOT NULL,
  `NumSolicitud` int(11) NOT NULL,
  `CharSolicitud` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de control usada por el programa de circulo de credito'$$