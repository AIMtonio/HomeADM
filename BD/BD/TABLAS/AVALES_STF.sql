-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AVALES_STF
DELIMITER ;
DROP TABLE IF EXISTS `AVALES_STF`;DELIMITER $$

CREATE TABLE `AVALES_STF` (
  `TransaccionID` bigint(20) DEFAULT NULL,
  `Aval_NombreCompleto` varchar(250) DEFAULT NULL,
  `Aval_Nombre` varchar(250) DEFAULT NULL,
  `Aval_ApellidoPaterno` varchar(250) DEFAULT NULL,
  `Aval_ApellidoMaterno` varchar(250) DEFAULT NULL,
  `Aval_Sexo` varchar(10) DEFAULT NULL,
  `Aval_FechaNacimiento` varchar(100) DEFAULT NULL,
  `Aval_Edad` varchar(50) DEFAULT NULL,
  `Aval_RFC` varchar(20) DEFAULT NULL,
  `Aval_Ocupacion` varchar(250) DEFAULT NULL,
  `Aval_Correo` varchar(200) DEFAULT NULL,
  `Aval_DireccionCompleta` varchar(250) DEFAULT NULL,
  `Aval_Domicilio` varchar(250) DEFAULT NULL,
  `Aval_Colonia` varchar(200) DEFAULT NULL,
  `Aval_Ciudad` varchar(200) DEFAULT NULL,
  `Aval_Estado` varchar(200) DEFAULT NULL,
  `Aval_CP` varchar(20) DEFAULT NULL,
  `Aval_Radicar` varchar(150) DEFAULT NULL,
  `Aval_TelCasa` varchar(200) DEFAULT NULL,
  `Aval_Celular` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$