-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ENCABEZADOREP
DELIMITER ;
DROP TABLE IF EXISTS `ENCABEZADOREP`;DELIMITER $$

CREATE TABLE `ENCABEZADOREP` (
  `EncabezadoID` int(11) NOT NULL COMMENT 'id de la tabla',
  `NombreReporte` varchar(100) DEFAULT NULL COMMENT 'Nombre del reporte. \nEjemplo "CuentasPLD"\n\n',
  `LeyendaEnc` varchar(100) DEFAULT NULL COMMENT 'Leyenda del Encabezado.\nEjemplo: SAC-PLD02-CUE',
  PRIMARY KEY (`EncabezadoID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1$$