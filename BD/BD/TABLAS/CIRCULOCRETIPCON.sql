-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CIRCULOCRETIPCON
DELIMITER ;
DROP TABLE IF EXISTS `CIRCULOCRETIPCON`;DELIMITER $$

CREATE TABLE `CIRCULOCRETIPCON` (
  `TipoContratoCCID` varchar(2) NOT NULL COMMENT 'ID del tipo de contrato',
  `Descripcion` varchar(200) DEFAULT NULL COMMENT 'Descripcion del tipo de contrato',
  PRIMARY KEY (`TipoContratoCCID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tipos de Cuenta de Circulo de Credito'$$