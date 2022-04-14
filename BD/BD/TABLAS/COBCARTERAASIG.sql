-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COBCARTERAASIG
DELIMITER ;
DROP TABLE IF EXISTS `COBCARTERAASIG`;DELIMITER $$

CREATE TABLE `COBCARTERAASIG` (
  `FolioAsigID` int(11) NOT NULL COMMENT 'Identificador consecutivo de la Asignacion',
  `FechaAsig` date DEFAULT NULL COMMENT 'Fecha en la que se realizo la asignacion',
  `GestorID` int(11) NOT NULL COMMENT 'ID gestor de cobranza',
  `PorcentajeComision` decimal(12,2) NOT NULL COMMENT 'Porcentaje de comision y puede ser 0 a 50',
  `TipoAsigCobranzaID` int(11) NOT NULL COMMENT 'ID hace referencia a la tabla TIPOASIGCOBRANZA',
  `EstatusAsig` char(1) DEFAULT NULL COMMENT 'Estatus Asignacion(Activo = A, Baja = B)',
  `FechaBaja` date NOT NULL COMMENT 'Fecha en que se libera o da de baja',
  `UsuarioAsigID` int(11) DEFAULT NULL COMMENT 'ID del usuario que realiza la asignacion',
  `UsuarioLibeID` int(11) DEFAULT NULL COMMENT 'ID del usuario que realiza la liberacion',
  `DiaAtrasoMin` int(11) DEFAULT NULL COMMENT 'Dias de atraso minimo en la busqueda',
  `DiaAtrasoMax` int(11) DEFAULT NULL COMMENT 'Dias de atraso maximo en la busqueda',
  `AdeudoMin` decimal(12,2) DEFAULT NULL COMMENT 'Adeudo minimo en la busqueda',
  `AdeudoMax` decimal(12,2) DEFAULT NULL COMMENT 'Adeudo maximo en la busqueda',
  `EstCredito` varchar(10) DEFAULT NULL COMMENT 'Estatus seleccionados en la busqueda',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Sucursal ID en la busqueda',
  `EstadoID` int(11) DEFAULT NULL COMMENT 'Estado ID en la busqueda',
  `MunicipioID` int(11) DEFAULT NULL COMMENT 'Municipio ID en la busqueda',
  `LocalidadID` int(11) DEFAULT NULL COMMENT 'Localidad ID en la busqueda',
  `ColoniaID` int(11) DEFAULT NULL COMMENT 'Colonia id en la busqueda',
  `LimRenglones` int(11) DEFAULT NULL COMMENT 'Limite de renglones en la busqueda',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`FolioAsigID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que almacenara las Asignaciones de Cartera para Cobranza'$$