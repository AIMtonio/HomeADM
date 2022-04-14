-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPDATOS
DELIMITER ;
DROP TABLE IF EXISTS `TMPDATOS`;DELIMITER $$

CREATE TABLE `TMPDATOS` (
  `Sucursal` varchar(45) DEFAULT NULL,
  `SocioRea` varchar(45) DEFAULT NULL,
  `Apell1` varchar(45) DEFAULT NULL,
  `Apell2` varchar(45) DEFAULT NULL,
  `Nom1` varchar(45) DEFAULT NULL,
  `Nom2` varchar(45) DEFAULT NULL,
  `PVen` varchar(45) DEFAULT NULL,
  `Estado` varchar(45) DEFAULT NULL,
  `FAlta` varchar(45) DEFAULT NULL,
  `Giro` varchar(45) DEFAULT NULL,
  `FAper` varchar(45) DEFAULT NULL,
  `Genero` varchar(45) DEFAULT NULL,
  `VencidoReal` varchar(45) DEFAULT NULL,
  `Propiedad` varchar(45) DEFAULT NULL,
  `ProductoRevisado` varchar(45) DEFAULT NULL,
  `NoCuotas` varchar(45) DEFAULT NULL,
  `FNacim` varchar(45) DEFAULT NULL,
  `EdoCivil` varchar(45) DEFAULT NULL,
  `LugarNacimiento` varchar(45) DEFAULT NULL,
  `Carga` varchar(45) DEFAULT NULL,
  `NombreEmpleado` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Temporal de datos de Cliente'$$