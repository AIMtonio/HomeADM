-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSCALENDARIO
DELIMITER ;
DROP TABLE IF EXISTS `SMSCALENDARIO`;DELIMITER $$

CREATE TABLE `SMSCALENDARIO` (
  `CalendarioID` int(11) NOT NULL,
  `FechaEnvio` date DEFAULT NULL,
  `CampaniaID` int(11) DEFAULT NULL,
  `ArchivoCargaID` int(11) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$