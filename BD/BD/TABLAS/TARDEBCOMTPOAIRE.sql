-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBCOMTPOAIRE
DELIMITER ;
DROP TABLE IF EXISTS `TARDEBCOMTPOAIRE`;DELIMITER $$

CREATE TABLE `TARDEBCOMTPOAIRE` (
  `CompaniaID` char(4) NOT NULL COMMENT 'PK de tabla',
  `Nombre` varchar(45) DEFAULT NULL COMMENT 'Nombre de la compania telefonica\n',
  `ComisionMisMis` varchar(5) DEFAULT NULL COMMENT 'Porcentaje de Comision en mis@mis',
  `ComisionSusMis` varchar(5) DEFAULT NULL COMMENT 'Porcentaje de comision en sus@mis',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(20) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`CompaniaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$