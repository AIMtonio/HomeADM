-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDOPEREELEVANT
DELIMITER ;
DROP TABLE IF EXISTS `PLDOPEREELEVANT`;
DELIMITER $$

CREATE TABLE `PLDOPEREELEVANT` (
  `OpeReelevanteID` int(11) NOT NULL COMMENT 'Clave o ID de la Operacion Reelevante',
  `SucursalID` int(11) NOT NULL COMMENT 'Clave o ID de la Sucursal',
  `Fecha` date DEFAULT NULL COMMENT 'Fecha de la Operacion',
  `Hora` time DEFAULT NULL COMMENT 'Hora de la Operacion',
  `Localidad` varchar(10) DEFAULT NULL COMMENT 'clave de la Localidad  a la que corresponde la sucursal',
  `TipoOperacionID` varchar(3) DEFAULT NULL COMMENT 'clave del tipo de operación realizada',
  `InstrumentMonID` varchar(3) DEFAULT NULL COMMENT 'clave de tipo de instrumento monetario realizado',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Clave o Id del Cliente',
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `Monto` double DEFAULT NULL COMMENT 'Monto de la transaccion realizada en la moneda original',
  `ClaveMoneda` varchar(3) DEFAULT NULL COMMENT 'Monto de la transaccion realizada en la moneda original',
  `PrimerNombreCliente` varchar(50) DEFAULT NULL COMMENT 'Primer Nombre del Cliente',
  `SegundoNombreCliente` varchar(50) DEFAULT NULL COMMENT 'Segundo Nombre del Cliente',
  `TercerNombreCliente` varchar(50) DEFAULT NULL COMMENT 'Tercer nombre del Cliente',
  `ApellidoPatCliente` varchar(50) DEFAULT NULL COMMENT 'Apellido Paterno del Cliente',
  `ApellidoMatCliente` varchar(50) DEFAULT NULL COMMENT 'Apellido Materno del Cliente',
  `RFC` char(13) DEFAULT NULL COMMENT 'RFC del Cliente',
  `Calle` varchar(100) DEFAULT NULL COMMENT 'calle del Cliente',
  `ColoniaCliente` varchar(200) DEFAULT NULL COMMENT 'Colonia del Cliente',
  `LocalidadCliente` varchar(10) DEFAULT NULL COMMENT 'Localidad del Cliente',
  `CP` char(5) DEFAULT NULL COMMENT 'Codigo Postal del Cliente',
  `MunicipioID` int(11) DEFAULT NULL COMMENT 'Municipio del Cliente',
  `EstadoID` int(11) DEFAULT NULL COMMENT 'Estado del Cliente',
  `DescripcionOper` varchar(100) DEFAULT NULL COMMENT 'Descripcion de la operacion o transaccion reportada como Operacion Reelevante',
  `NombreCompleto` varchar(200) DEFAULT NULL COMMENT 'Nombre completo de la persona o Razón Social de la Persona Moral.',
  `UsuarioServicioID` int(11) NOT NULL DEFAULT '0' 'Identificador del Usuario de Servicio',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`OpeReelevanteID`,`SucursalID`),
  KEY `PLDOPEREELEVANT_IDX1` (`Fecha`,`ClienteID`,`UsuarioServicioID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Operaciones Reelevantes'$$