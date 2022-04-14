-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPAVALESSTF
DELIMITER ;
DROP TABLE IF EXISTS `TMPAVALESSTF`;DELIMITER $$

CREATE TABLE `TMPAVALESSTF` (
  `TransaccionID` bigint(20) DEFAULT NULL,
  `AvalNombreCompleto` varchar(250) DEFAULT NULL,
  `AvalNombres` varchar(250) DEFAULT NULL,
  `AvalApellidoPaterno` varchar(250) DEFAULT NULL,
  `AvalApellidoMaterno` varchar(250) DEFAULT NULL,
  `AvalSexo` varchar(10) DEFAULT NULL,
  `AvalFechaNacimiento` varchar(100) DEFAULT NULL,
  `AvalEdad` varchar(50) DEFAULT NULL,
  `AvalRFC` varchar(20) DEFAULT NULL,
  `AvalOcupacion` varchar(250) DEFAULT NULL,
  `AvalCorreo` varchar(200) DEFAULT NULL,
  `AvalDireccionCompleta` varchar(250) DEFAULT NULL,
  `AvalDomicilio` varchar(250) DEFAULT NULL,
  `AvalColonia` varchar(200) DEFAULT NULL,
  `AvalCiudad` varchar(200) DEFAULT NULL,
  `AvalEstado` varchar(200) DEFAULT NULL,
  `AvalCP` varchar(20) DEFAULT NULL,
  `AvalRadicar` varchar(150) DEFAULT NULL,
  `AvalTelCasa` varchar(200) DEFAULT NULL,
  `AvalCelular` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Temporal para calcular datos de avales'$$