-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TiposCredito
DELIMITER ;
DROP TABLE IF EXISTS `TiposCredito`;DELIMITER $$

CREATE TABLE `TiposCredito` (
  `TipoCreditoID` int(11) NOT NULL,
  `Nombre` varchar(100) NOT NULL,
  `NombreCorto` varchar(45) NOT NULL,
  PRIMARY KEY (`TipoCreditoID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1$$