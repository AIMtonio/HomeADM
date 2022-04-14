-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTARENDIAHO
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTARENDIAHO`;DELIMITER $$

CREATE TABLE `SUBCTARENDIAHO` (
  `ConceptoAhoID` int(5) NOT NULL COMMENT 'PK de la tabla, Y FK que corresponde con la tabla de CONCEPTOSAHORRO',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Paga` char(2) DEFAULT NULL COMMENT 'Subcuenta para cuando se Paga Rendimientos',
  `NoPaga` char(2) DEFAULT NULL COMMENT 'Subcuenta para cuando No Paga Rendimientos',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoAhoID`),
  KEY `fk_SUBCTARENDIAHO_1` (`ConceptoAhoID`),
  CONSTRAINT `fk_SUBCTARENDIAHO_1` FOREIGN KEY (`ConceptoAhoID`) REFERENCES `CONCEPTOSAHORRO` (`ConceptoAhoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Subcuenta de Rendimiento para el Modulo de Cuentas de Ahorro'$$