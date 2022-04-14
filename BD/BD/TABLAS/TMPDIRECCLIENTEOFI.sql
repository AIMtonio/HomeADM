-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPDIRECCLIENTEOFI
DELIMITER ;
DROP TABLE IF EXISTS `TMPDIRECCLIENTEOFI`;DELIMITER $$

CREATE TABLE `TMPDIRECCLIENTEOFI` (
  `ClienteID` int(11) DEFAULT NULL,
  `DireccionID` int(11) DEFAULT NULL,
  `EstadoID` int(11) DEFAULT NULL,
  `MunicipioID` int(11) DEFAULT NULL,
  `LocalidadID` int(11) DEFAULT NULL,
  `ColoniaID` int(11) DEFAULT NULL,
  `Colonia` varchar(200) DEFAULT NULL,
  `Calle` varchar(200) DEFAULT NULL,
  `NumeroCasa` varchar(20) DEFAULT NULL,
  `CP` varchar(5) DEFAULT NULL,
  `DireccionCompleta` varchar(300) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$