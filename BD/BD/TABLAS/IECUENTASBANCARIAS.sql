-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- IECUENTASBANCARIAS
DELIMITER ;
DROP TABLE IF EXISTS `IECUENTASBANCARIAS`;DELIMITER $$

CREATE TABLE `IECUENTASBANCARIAS` (
  `Institucion` int(11) DEFAULT NULL,
  `Sucursal` varchar(150) DEFAULT NULL,
  `NombreEjecutivo` varchar(50) DEFAULT NULL,
  `Cuenta` varchar(15) DEFAULT NULL,
  `CuentaClabe` varchar(18) DEFAULT NULL,
  `Chequera` varchar(1) DEFAULT NULL,
  `MontoTotal` decimal(12,2) DEFAULT NULL,
  `InstitucionCompaq` varchar(45) DEFAULT NULL COMMENT 'Nombre de la institucion bancaria segun compac',
  `IdBancosCompac` int(11) DEFAULT NULL COMMENT 'Id de la institucion bancaria segun compac'
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$