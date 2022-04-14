-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATRAZONESSCORECC
DELIMITER ;
DROP TABLE IF EXISTS `CATRAZONESSCORECC`;DELIMITER $$

CREATE TABLE `CATRAZONESSCORECC` (
  `Codigo` varchar(5) NOT NULL COMMENT 'Codigo de la razon del score.',
  `Descripcion` varchar(200) DEFAULT NULL COMMENT 'Descripcion de la razon.',
  PRIMARY KEY (`Codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Razones Score del reporte de Circulo de Credito.'$$