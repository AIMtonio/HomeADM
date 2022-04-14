-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- NOTARIAS
DELIMITER ;
DROP TABLE IF EXISTS `NOTARIAS`;DELIMITER $$

CREATE TABLE `NOTARIAS` (
  `EstadoID` int(11) NOT NULL COMMENT 'Estado de la Republica',
  `MunicipioID` int(11) NOT NULL COMMENT 'Municipio de la Republica',
  `NotariaID` int(11) NOT NULL COMMENT 'Numero de Notaria',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Numero de Empresa',
  `Titular` varchar(200) DEFAULT NULL COMMENT 'Nombre del Titular de la Notaria\n',
  `Direccion` varchar(240) DEFAULT NULL COMMENT 'Direccion de la Notaria	',
  `Telefono` varchar(20) DEFAULT NULL COMMENT 'Telefono de la Notaria',
  `Correo` varchar(50) DEFAULT NULL COMMENT 'Correo de la Notaria',
  `ExtTelefonoPart` varchar(6) DEFAULT NULL COMMENT 'Contiene el numero de extensión de teléfono',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`EstadoID`,`MunicipioID`,`NotariaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Notarias Publicas'$$