-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- tmp_AportacionSocial
DELIMITER ;
DROP TABLE IF EXISTS `tmp_AportacionSocial`;DELIMITER $$

CREATE TABLE `tmp_AportacionSocial` (
  `Consecutivo` bigint(20) DEFAULT NULL,
  `IdPersona` bigint(20) DEFAULT NULL,
  `Nombre` varchar(100) DEFAULT NULL,
  `CURP` varchar(25) DEFAULT NULL,
  `Sexo` varchar(12) DEFAULT NULL,
  `Parte` double DEFAULT NULL,
  `ClienteIDSAFI` int(11) DEFAULT NULL,
  `ClienteIDCte` varchar(20) DEFAULT NULL,
  `ClienteID` int(11) DEFAULT NULL,
  `NombreCompleto` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$