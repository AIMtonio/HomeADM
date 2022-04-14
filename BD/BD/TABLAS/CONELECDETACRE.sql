-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONELECDETACRE
DELIMITER ;
DROP TABLE IF EXISTS `CONELECDETACRE`;
DELIMITER $$


CREATE TABLE `CONELECDETACRE` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `AnioMes` int(11) DEFAULT NULL,
  `SucursalID` int(11) DEFAULT NULL,
  `ClienteID` int(11) DEFAULT NULL,
  `CreditoID` bigint(12) DEFAULT NULL,
  `FechaOperacion` date DEFAULT NULL,
  `TipoMovimi` int(11) DEFAULT NULL,
  `Descripcion` varchar(150) DEFAULT NULL,
  `Cargos` decimal(14,2) DEFAULT NULL,
  `Abonos` decimal(14,2) DEFAULT NULL,
  `PolizaID` bigint(20) DEFAULT NULL,
  KEY `ClienteID` (`PolizaID`,`CreditoID`),
  KEY `index2` (`ClienteID`),
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$
