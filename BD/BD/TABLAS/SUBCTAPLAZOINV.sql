-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAPLAZOINV
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTAPLAZOINV`;DELIMITER $$

CREATE TABLE `SUBCTAPLAZOINV` (
  `ConceptoInverID` int(5) DEFAULT NULL COMMENT 'PK de la tabla, Y FK que corresponde con la tabla de CONCEPTOSINVER',
  `SubCtaPlazoInvID` int(5) NOT NULL COMMENT 'PK de la tabla, Y FK que corresponde con la tabla de CONCEPTOSINVER',
  `PlazoInferior` int(11) NOT NULL COMMENT 'Plazo Inferior',
  `PlazoSuperior` int(11) NOT NULL COMMENT 'Plazo Superior',
  `SubCuenta` char(2) DEFAULT NULL COMMENT 'Numeros que corresponden a la Subcuenta',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`SubCtaPlazoInvID`),
  KEY `fk_SUBCTAPLAZOINV_1` (`ConceptoInverID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Subcuenta de Tipos de Persona para el Modulo de Inversiones'$$