-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATRESPUESTASSIC
DELIMITER ;
DROP TABLE IF EXISTS `CATRESPUESTASSIC`;DELIMITER $$

CREATE TABLE `CATRESPUESTASSIC` (
  `Codigo` varchar(5) NOT NULL COMMENT 'Codigo de la respuesta.',
  `Descripcion` varchar(200) DEFAULT NULL COMMENT 'Descripcion de la respuesta.',
  PRIMARY KEY (`Codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Respuestas de Otras SICs para la seccion de Mensajes del reporte de Circulo de Credito.'$$