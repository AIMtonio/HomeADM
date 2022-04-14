-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TiposMovCredito
DELIMITER ;
DROP TABLE IF EXISTS `TiposMovCredito`;DELIMITER $$

CREATE TABLE `TiposMovCredito` (
  `TipoMovCredID` int(11) NOT NULL,
  `Descripcion` varchar(100) DEFAULT NULL,
  `OrdenPago` int(11) DEFAULT NULL,
  PRIMARY KEY (`TipoMovCredID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1$$