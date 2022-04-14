-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GESTORESCOBRANZA
DELIMITER ;
DROP TABLE IF EXISTS `GESTORESCOBRANZA`;DELIMITER $$

CREATE TABLE `GESTORESCOBRANZA` (
  `GestorID` int(11) NOT NULL COMMENT 'ID gestor de cobranza',
  `TipoGestor` varchar(1) DEFAULT NULL COMMENT 'Tipo de Gestor I= interno , E= externo',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'ID del usuario, solo para los Internos, para los externos es nulo',
  `Nombre` varchar(45) DEFAULT NULL COMMENT 'Nombre del gestor',
  `ApellidoPaterno` varchar(45) DEFAULT NULL COMMENT 'Apellido Paterno del gestor',
  `ApellidoMaterno` varchar(45) DEFAULT NULL COMMENT 'Apellido Materno del gestor',
  `TelefonoParticular` varchar(20) DEFAULT NULL COMMENT 'Telefono particular ',
  `TelefonoCelular` varchar(20) DEFAULT NULL COMMENT 'Telefono celular',
  `EstadoID` int(11) DEFAULT NULL COMMENT 'Hace referencia al ID del estado',
  `MunicipioID` int(11) DEFAULT NULL COMMENT 'Hace referencia al ID del muncipio',
  `LocalidadID` int(11) DEFAULT NULL COMMENT 'Numero de Localidad Correspondiente al Municipio',
  `ColoniaID` int(11) DEFAULT NULL COMMENT 'Nombre de la colonia',
  `Calle` varchar(50) DEFAULT NULL COMMENT 'Nombre de la calle',
  `NumeroCasa` char(10) DEFAULT NULL COMMENT 'Numero de casa',
  `NumInterior` char(10) DEFAULT NULL COMMENT 'Numero interior de la casa',
  `Piso` char(50) DEFAULT NULL COMMENT 'Numero de piso.',
  `PrimeraEntreCalle` varchar(50) DEFAULT NULL COMMENT 'Primer entrecalle en la que se encuentra la direccion',
  `SegundaEntreCalle` varchar(50) DEFAULT NULL COMMENT 'Segunda entrecalle en la que se encuentra la direccion',
  `CP` char(5) DEFAULT NULL COMMENT 'Codigo Postal',
  `PorcentajeComision` decimal(12,2) DEFAULT NULL COMMENT 'Porcentaje de comision y puede ser 0 a 50',
  `TipoAsigCobranzaID` int(11) DEFAULT NULL COMMENT 'ID hace referencia a la tabla TIPOASIGCOBRANZA',
  `Estatus` char(1) DEFAULT NULL COMMENT ' Estatus A = Activo, B = Baja',
  `FechaRegistro` date DEFAULT NULL COMMENT 'Fecha en la que se realizo el regsitro del gestor de cobranza',
  `FechaActivacion` date DEFAULT NULL COMMENT 'Fecha en la que se realizo la activacion',
  `FechaBaja` date DEFAULT NULL COMMENT 'Fecha en la que se dio de baja',
  `UsuarioRegistroID` int(11) DEFAULT NULL COMMENT 'ID del usuario que realizo el registro',
  `UsuarioActivaID` int(11) DEFAULT NULL COMMENT 'ID usuario que activo',
  `UsuarioBajaID` int(11) DEFAULT NULL COMMENT 'ID usuario que realizo la baja',
  `NombreCompleto` varchar(100) NOT NULL COMMENT 'Nombre completo del cliente',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`GestorID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que almacenara Catalogo Gestores de Cobranza'$$