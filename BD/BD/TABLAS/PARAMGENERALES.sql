-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMGENERALES
DELIMITER ;
DROP TABLE IF EXISTS `PARAMGENERALES`;DELIMITER $$

CREATE TABLE `PARAMGENERALES` (
  `LlaveParametro` varchar(50) NOT NULL,
  `ValorParametro` varchar(200) DEFAULT NULL COMMENT 'Tabla de parametros Generales para que procesos que sean particulares de Algun Cliente',
  `DescParametro` varchar(200) DEFAULT NULL COMMENT 'Brebe descripción de la funcionalidad del parámetro y sus posibles \nvalores',
  PRIMARY KEY (`LlaveParametro`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1$$