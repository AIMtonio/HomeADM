-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTATIPERFON
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTATIPERFON`;DELIMITER $$

CREATE TABLE `SUBCTATIPERFON` (
  `ConceptoFondID` int(5) NOT NULL COMMENT 'PK de la tabla, Y FK que corresponde con la tabla de CONCEPTOSAHORRO',
  `TipoFondeo` char(1) NOT NULL COMMENT 'Indica el tipo de Fondeador INVERSIONISTA(I)/FONDEADOR(F)',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Fisica` char(6) DEFAULT NULL COMMENT 'Subcuenta para el tipo de Persona Fisica',
  `FisicaActEmp` char(6) DEFAULT NULL COMMENT 'Subcuenta para el tipo de PErsona FIsica con Act Emp',
  `Moral` char(6) DEFAULT NULL COMMENT 'Subcuenta para el tipo de Persona Moral',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoFondID`,`TipoFondeo`),
  CONSTRAINT `fk_SUBCTATIPERFON_1` FOREIGN KEY (`ConceptoFondID`) REFERENCES `CONCEPTOSFONDEO` (`ConceptoFondID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Subcuenta de Tipos de Persona para el Modulo de Fondeo'$$