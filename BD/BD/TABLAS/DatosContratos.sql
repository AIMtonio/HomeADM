-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DatosContratos
DELIMITER ;
DROP TABLE IF EXISTS `DatosContratos`;DELIMITER $$

CREATE TABLE `DatosContratos` (
  `idDatosContratos` int(11) NOT NULL,
  `Clave` varchar(10) DEFAULT NULL,
  `Valor` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idDatosContratos`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$