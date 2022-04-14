-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTATIPERINV
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTATIPERINV`;DELIMITER $$

CREATE TABLE `SUBCTATIPERINV` (
  `ConceptoInverID` int(5) NOT NULL COMMENT 'PK de la tabla, Y FK que corresponde con la tabla de CONCEPTOSINVER',
  `Fisica` char(2) DEFAULT NULL COMMENT 'Subcuenta para el tipo de Persona Fisica',
  `Moral` char(2) DEFAULT NULL COMMENT 'Subcuenta para el tipo de Persona Moral',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoInverID`),
  KEY `fk_SUBCTATIPERINV_1` (`ConceptoInverID`),
  CONSTRAINT `fk_SUBCTATIPERINV_1` FOREIGN KEY (`ConceptoInverID`) REFERENCES `CONCEPTOSINVER` (`ConceptoInvID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Subcuenta de Tipos de Persona para el Modulo de Inversiones'$$