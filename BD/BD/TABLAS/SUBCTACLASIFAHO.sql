-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTACLASIFAHO
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTACLASIFAHO`;DELIMITER $$

CREATE TABLE `SUBCTACLASIFAHO` (
  `ConceptoAhoID` int(5) NOT NULL COMMENT 'PK de la tabla, Y FK que corresponde con la tabla de CONCEPTOSAHORRO',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Clasificacion` char(1) NOT NULL COMMENT 'Clasificacion Contable: V .-Depositos a la Vista, A .- Ahorro(Ordinario)',
  `SubCuenta` char(6) DEFAULT NULL COMMENT 'Numeros que corresponde a la subcuenta',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoAhoID`,`Clasificacion`),
  KEY `fk_SUBCTACLASIFAHO_1` (`ConceptoAhoID`),
  CONSTRAINT `fk_SUBCTACLASIFAHO_1` FOREIGN KEY (`ConceptoAhoID`) REFERENCES `CONCEPTOSAHORRO` (`ConceptoAhoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Subcuenta por Clasificacion del Modulo de Cuentas de Ahorro '$$