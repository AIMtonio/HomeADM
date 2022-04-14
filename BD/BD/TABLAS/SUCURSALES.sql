-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUCURSALES
DELIMITER ;
DROP TABLE IF EXISTS `SUCURSALES`;
DELIMITER $$


CREATE TABLE `SUCURSALES` (
  `SucursalID` int(11) NOT NULL COMMENT 'Numero de Sucursal',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `NombreSucurs` varchar(50) DEFAULT NULL COMMENT 'Nombre de la Sucursal',
  `TipoSucursal` char(1) DEFAULT NULL COMMENT 'Tipo de Sucursal\nC .-  Coporativa\nA .- Atencion a Clientes\n',
  `FechaSucursal` date DEFAULT NULL COMMENT 'Fecha Actual\no de Sistema de \nla Sucursal',
  `EstadoID` int(11) DEFAULT NULL COMMENT 'FK de la tabla ESTADOSREPUB',
  `MunicipioID` int(11) DEFAULT NULL COMMENT 'Clave foranea tabla MUNICIPIOSREPUB\n',
  `LocalidadID` int(11) DEFAULT NULL,
  `ColoniaID` int(11) DEFAULT NULL,
  `CP` char(5) DEFAULT NULL COMMENT 'CODIGO POSTAL\n',
  `Colonia` varchar(45) DEFAULT NULL,
  `Calle` varchar(100) DEFAULT NULL,
  `Numero` char(10) DEFAULT NULL COMMENT 'numero de direccion\n',
  `DirecCompleta` varchar(250) DEFAULT NULL,
  `PlazaID` int(11) DEFAULT NULL,
  `IVA` decimal(12,2) DEFAULT NULL,
  `CentroCostoID` int(11) NOT NULL COMMENT 'Centro de Costos\nde la Sucursal',
  `Telefono` varchar(20) DEFAULT NULL,
  `NombreGerente` int(11) DEFAULT NULL COMMENT 'Nombre del \nGerente de la \nSucursal',
  `SubGerente` int(11) DEFAULT NULL,
  `TasaISR` decimal(12,2) DEFAULT NULL,
  `DifHorarMatriz` int(11) DEFAULT NULL,
  `Estatus` char(1) DEFAULT NULL COMMENT 'Indica el estatus del cierre\nA: Aperturada\nC: Cierre Sucursal\n',
  `PoderNotarialGte` varchar(500) DEFAULT NULL COMMENT 'Descripción del Poder Notarial del Gerente',
  `PoderNotarial` char(1) DEFAULT NULL COMMENT 'Si requiere de poder notarial',
  `TituloGte` varchar(10) DEFAULT NULL COMMENT 'Titulo del Gerente ',
  `TituloSubGte` varchar(10) DEFAULT NULL COMMENT 'Titulo del SubGerente ',
  `ExtTelefonoPart` varchar(6) DEFAULT NULL COMMENT 'Contiene el número de extensión de teléfono ',
  `PromotorCaptaID` char(5) DEFAULT NULL COMMENT 'Numero de Promotor de Captacion asignado a una sucursal',
  `ClaveSucCNBV` varchar(8) DEFAULT NULL COMMENT 'Clave de la Sucursal del Sujeto Obligado, usado para generar Reportes PLD.',
  `Latitud` varchar(10) DEFAULT NULL,
  `Longitud` varchar(11) DEFAULT NULL,
  `FechaAlta` date DEFAULT NULL,
  `HoraInicioOper` time DEFAULT NULL COMMENT 'Horario inicio operaciones sucursal.',
  `HoraFinOper` time DEFAULT NULL COMMENT 'Horario fin operaciones sucursal.',
  `ClaveSucOpeCred` varchar(10) DEFAULT NULL COMMENT ' Clave del Catalogo SITI - Sucursal que opera el credito',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`SucursalID`),
  KEY `fk_CentroCostoSuc` (`CentroCostoID`),
  KEY `fk_Estado` (`EstadoID`),
  KEY `fk_SUCURSALES_1` (`PlazaID`),
  KEY `Index_PromotorCapta` (`PromotorCaptaID`),
  CONSTRAINT `fk_CentroCostoSuc` FOREIGN KEY (`CentroCostoID`) REFERENCES `CENTROCOSTOS` (`CentroCostoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Estado` FOREIGN KEY (`EstadoID`) REFERENCES `ESTADOSREPUB` (`EstadoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_SUCURSALES_1` FOREIGN KEY (`PlazaID`) REFERENCES `PLAZAS` (`PlazaID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$
