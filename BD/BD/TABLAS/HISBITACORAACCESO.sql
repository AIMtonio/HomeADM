-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISBITACORAACCESO
DELIMITER ;
DROP TABLE IF EXISTS `HISBITACORAACCESO`;DELIMITER $$

CREATE TABLE `HISBITACORAACCESO` (
  `FechaCorte` date NOT NULL COMMENT 'Fecha en que se realizo el paso a historico',
  `AccesoID` bigint(12) NOT NULL COMMENT 'Idetinficador de acceso  ',
  `Fecha` date NOT NULL COMMENT 'Fecha en que se intenta realizar el acceso al SAFI',
  `Hora` time NOT NULL COMMENT 'Hora que se intenta realizar acceso al SAFI',
  `ClaveUsuario` varchar(45) NOT NULL COMMENT 'Clave del usuario',
  `SucursalID` int(11) NOT NULL COMMENT 'ID de la sucursal donde accesan',
  `UsuarioID` int(11) NOT NULL COMMENT 'ID del usuario',
  `Perfil` int(11) NOT NULL COMMENT 'Perfil del usuario referente al rolID',
  `AccesoIP` varchar(20) NOT NULL COMMENT 'Direccion IP del usuario',
  `Recurso` varchar(45) NOT NULL COMMENT 'Descripcion del recurso que accede el usuario',
  `TipoAcceso` int(11) NOT NULL COMMENT 'Tipo de acceso 1= Acceso exitoso, 2=Acceso fallido, 3= Acceso Recursos',
  `TipoMetodo` varchar(10) NOT NULL COMMENT 'Tipo de metodo get, post',
  `DetalleAcceso` varchar(500) NOT NULL COMMENT 'Detalles acceso usuario',
  `EmpresaID` int(11) NOT NULL COMMENT 'Empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Nombre de Usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Fecha Actual del Sistema',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Direccion IP',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Programa',
  `Sucursal` int(11) NOT NULL COMMENT 'Nombre de la Sucursal',
  `NumTransaccion` bigint(20) NOT NULL,
  PRIMARY KEY (`FechaCorte`,`AccesoID`),
  KEY `idx_BITACORAACCESO_1` (`Fecha`),
  KEY `idx_BITACORAACCESO_2` (`SucursalID`),
  KEY `idx_BITACORAACCESO_3` (`UsuarioID`),
  KEY `idx_BITACORAACCESO_4` (`Recurso`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacacena hisotrico de datos de los usuarios que acceden al SAFI'$$