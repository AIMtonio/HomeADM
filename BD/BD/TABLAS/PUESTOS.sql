-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PUESTOS
DELIMITER ;
DROP TABLE IF EXISTS `PUESTOS`;DELIMITER $$

CREATE TABLE `PUESTOS` (
  `ClavePuestoID` varchar(10) NOT NULL COMMENT 'ID o clave del Puesto',
  `AreaID` bigint(20) DEFAULT NULL COMMENT 'ID o Clave del Area',
  `CategoriaID` int(11) DEFAULT NULL COMMENT 'ID o clave de Categoria',
  `Descripcion` varchar(100) DEFAULT NULL COMMENT 'Descripcion del Puesto',
  `AtiendeSuc` char(1) DEFAULT NULL COMMENT 'Especifica si el Puesto Atiende en sucursal\nS= Si atiende\nN= No atiende',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estado del puesto\nV: Vigente\nB: Baja',
  `EsGestor` char(1) DEFAULT NULL COMMENT 'S="Si" N="No"',
  `EsSupervisor` char(1) DEFAULT NULL COMMENT 'S="Si" N="No"',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ClavePuestoID`),
  KEY `fk_PUESTOS_1` (`AreaID`),
  KEY `fk_PUESTOS_2` (`CategoriaID`),
  CONSTRAINT `fk_PUESTOS_1` FOREIGN KEY (`AreaID`) REFERENCES `AREAS` (`AreaID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_PUESTOS_2` FOREIGN KEY (`CategoriaID`) REFERENCES `CATEGORIAPTO` (`CategoriaID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Puestos dentro del Organigrama de la Empresa'$$