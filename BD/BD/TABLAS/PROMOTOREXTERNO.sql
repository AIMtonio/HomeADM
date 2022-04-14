-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROMOTOREXTERNO
DELIMITER ;
DROP TABLE IF EXISTS `PROMOTOREXTERNO`;DELIMITER $$

CREATE TABLE `PROMOTOREXTERNO` (
  `Numero` int(11) NOT NULL DEFAULT '0' COMMENT 'PK de la Tabla',
  `Nombre` varchar(150) DEFAULT NULL COMMENT 'Campo para almacenar el nombre del promotor externo de inversion',
  `Telefono` varchar(20) DEFAULT NULL COMMENT 'Campo para almacenar el numero de telefono del promotor externo',
  `NumCelular` varchar(20) DEFAULT NULL COMMENT 'Campo para almacenar el numero de celular del promotor externo',
  `Correo` varchar(50) DEFAULT NULL COMMENT 'Campo para almacenar el correo del promotor externo',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Campo para almacenar el estatus del promotor externo',
  `ExtTelefono` varchar(7) DEFAULT NULL COMMENT 'Extensión del Telefono Particular.',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`Numero`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$