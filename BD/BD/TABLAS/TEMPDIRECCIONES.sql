-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TEMPDIRECCIONES
DELIMITER ;
DROP TABLE IF EXISTS `TEMPDIRECCIONES`;DELIMITER $$

CREATE TABLE `TEMPDIRECCIONES` (
  `EstadoID` int(11) DEFAULT NULL,
  `MunicipioID` int(11) DEFAULT NULL,
  `NombreLocalidad` varchar(200) DEFAULT NULL,
  `TipoAsent` varchar(200) DEFAULT NULL,
  `Asentamiento` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$