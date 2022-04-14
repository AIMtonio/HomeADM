-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTATIPOACTIVO
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTATIPOACTIVO`;DELIMITER $$

CREATE TABLE `SUBCTATIPOACTIVO` (
  `ConceptoActivoID` int(11) NOT NULL COMMENT 'PK de la tabla, Y FK que corresponde con la tabla de CONCEPTOSACTIVOS',
  `TipoActivoID` int(11) NOT NULL COMMENT 'Id del tipo de activo',
  `SubCuenta` char(15) NOT NULL COMMENT 'Subcuenta por tipo de activo',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditoria Direccion IP ',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria Programa ',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
  PRIMARY KEY (`ConceptoActivoID`,`TipoActivoID`),
  KEY `fk_SUBCTATIPOACTIVO_1` (`ConceptoActivoID`),
  KEY `fk_SUBCTATIPOACTIVO_2` (`TipoActivoID`),
  CONSTRAINT `fk_SUBCTATIPOACTIVO_1` FOREIGN KEY (`ConceptoActivoID`) REFERENCES `CONCEPTOSACTIVOS` (`ConceptoActivoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_SUBCTATIPOACTIVO_2` FOREIGN KEY (`TipoActivoID`) REFERENCES `TIPOSACTIVOS` (`TipoActivoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Subcuenta de Tipos de Activos para el Modulo de Activos'$$