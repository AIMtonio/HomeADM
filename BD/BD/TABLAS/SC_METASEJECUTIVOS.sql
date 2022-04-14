-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SC_METASEJECUTIVOS
DELIMITER ;
DROP TABLE IF EXISTS `SC_METASEJECUTIVOS`;DELIMITER $$

CREATE TABLE `SC_METASEJECUTIVOS` (
  `ClaveEjecutivo` varchar(25) NOT NULL,
  `Mes` varchar(45) DEFAULT NULL,
  `Meta` decimal(12,2) DEFAULT NULL,
  `SucursalID` int(11) DEFAULT NULL,
  PRIMARY KEY (`ClaveEjecutivo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$