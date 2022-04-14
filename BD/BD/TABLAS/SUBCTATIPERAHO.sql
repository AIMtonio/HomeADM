-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTATIPERAHO
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTATIPERAHO`;DELIMITER $$

CREATE TABLE `SUBCTATIPERAHO` (
  `ConceptoAhoID` int(5) NOT NULL COMMENT 'PK de la tabla, Y FK que corresponde con la tabla de CONCEPTOSAHORRO',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Fisica` char(2) DEFAULT NULL COMMENT 'Subcuenta para el tipo de Persona Fisica',
  `Moral` char(2) DEFAULT NULL COMMENT 'Subcuenta para el tipo de Persona Moral',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoAhoID`),
  KEY `fk_SUBCTATIPERAHO_1` (`ConceptoAhoID`),
  CONSTRAINT `fk_SUBCTATIPERAHO_1` FOREIGN KEY (`ConceptoAhoID`) REFERENCES `CONCEPTOSAHORRO` (`ConceptoAhoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Subcuenta de Tipos de Persona para el Modulo de Cuentas de A'$$