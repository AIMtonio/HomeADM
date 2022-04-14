-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TEMPLOCREPMARGINADAS
DELIMITER ;
DROP TABLE IF EXISTS `TEMPLOCREPMARGINADAS`;DELIMITER $$

CREATE TABLE `TEMPLOCREPMARGINADAS` (
  `EstadoID` int(11) DEFAULT NULL,
  `MunicipioID` int(11) DEFAULT NULL,
  `LocalidadID` int(11) DEFAULT NULL,
  `NombreLocalidad` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$