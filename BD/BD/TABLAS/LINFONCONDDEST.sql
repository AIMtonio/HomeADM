-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LINFONCONDDEST
DELIMITER ;
DROP TABLE IF EXISTS `LINFONCONDDEST`;DELIMITER $$

CREATE TABLE `LINFONCONDDEST` (
  `LineaFondeoID` int(11) NOT NULL COMMENT 'ID de la linea de Fondeo, Consecutivo de linea por Institucion de Fondeo (InstitutFondID)\n',
  `DestinoCreID` int(11) NOT NULL COMMENT 'Identificador de tabla DESTINOSCREDITO',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`LineaFondeoID`,`DestinoCreID`),
  KEY `fk_LINFONCONDDEST_1_idx` (`LineaFondeoID`),
  KEY `fk_LINFONCONDDEST_2_idx` (`DestinoCreID`),
  CONSTRAINT `fk_LINFONCONDDEST_1` FOREIGN KEY (`LineaFondeoID`) REFERENCES `LINEAFONDEADOR` (`LineaFondeoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_LINFONCONDDEST_2` FOREIGN KEY (`DestinoCreID`) REFERENCES `DESTINOSCREDITO` (`DestinoCreID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Condiciones descto Lineas Fondeo para destinos de cred'$$