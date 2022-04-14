-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GRUPOSNOSOLIDARIOS
DELIMITER ;
DROP TABLE IF EXISTS `GRUPOSNOSOLIDARIOS`;DELIMITER $$

CREATE TABLE `GRUPOSNOSOLIDARIOS` (
  `GrupoID` bigint(12) NOT NULL DEFAULT '0' COMMENT 'ID consecutivo de la tabla',
  `NombreGrupo` varchar(200) DEFAULT NULL COMMENT 'Nombre del grupo',
  `FechaRegistro` date DEFAULT NULL COMMENT 'Fecha de registro',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'ID de la sucursal del grupo',
  `NumIntegrantes` int(10) DEFAULT NULL COMMENT 'Numero actual de integrantes del grupo',
  `PromotorID` int(11) DEFAULT NULL COMMENT 'ID del promotor',
  `LugarReunion` varchar(200) DEFAULT NULL COMMENT 'Lugar de reunion',
  `DiaReunion` varchar(30) DEFAULT NULL COMMENT 'Dia de reunion',
  `HoraReunion` varchar(50) DEFAULT NULL COMMENT 'Hora de reunion',
  `AhoObligatorio` decimal(14,2) DEFAULT NULL COMMENT 'Monto de ahorro obligatorio para los integrantes',
  `PlazoCredito` varchar(15) DEFAULT NULL COMMENT 'Plazo en que se otorgaran creditos a los integrantes',
  `CostoAusencia` decimal(14,2) DEFAULT NULL COMMENT 'Monto a cobrar a los integrantes por ausencia a reuniones',
  `AhorroCompro` decimal(14,2) DEFAULT NULL COMMENT 'Monto de ahorro compromiso',
  `MoraCredito` decimal(14,2) DEFAULT NULL COMMENT 'Monto maximo de mora en un credito para los integrantes',
  `EstadoID` int(11) DEFAULT NULL COMMENT 'ID del estado',
  `MunicipioID` int(11) DEFAULT NULL COMMENT 'ID del municipio',
  `Ubicacion` varchar(800) DEFAULT NULL COMMENT 'Lugar de ubicacion',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus del grupo A = Activo',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'ID de la empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` int(15) DEFAULT NULL,
  PRIMARY KEY (`GrupoID`),
  KEY `FK_SucursalID_6` (`SucursalID`),
  KEY `FK_PromotorID_3` (`PromotorID`),
  CONSTRAINT `FK_PromotorID_3` FOREIGN KEY (`PromotorID`) REFERENCES `PROMOTORES` (`PromotorID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_SucursalID_6` FOREIGN KEY (`SucursalID`) REFERENCES `SUCURSALES` (`SucursalID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Grupos no solidarios de cliente'$$