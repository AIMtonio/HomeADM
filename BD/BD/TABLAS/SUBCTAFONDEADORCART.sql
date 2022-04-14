-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAFONDEADORCART
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTAFONDEADORCART`;DELIMITER $$

CREATE TABLE `SUBCTAFONDEADORCART` (
  `ConceptoCarID` int(11) NOT NULL COMMENT 'Id del concepto de cartera',
  `InstitutFondID` int(11) NOT NULL COMMENT 'Id de la institucion de fondeo',
  `SubCuenta` char(2) DEFAULT NULL COMMENT 'Numero de la subcuenta entre el concepto y la institucion de fondeo',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Id de la empresa',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Id del usuario',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Fecha actual',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Ip de donde se realiza el movimiento',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Id del programa',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Sucursal',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Numero de transaccion',
  PRIMARY KEY (`ConceptoCarID`,`InstitutFondID`),
  KEY `fk_SUBCTAFONDEADORCART_2` (`InstitutFondID`),
  CONSTRAINT `SUBCTAFONDEADORCART_ibfk_1` FOREIGN KEY (`ConceptoCarID`) REFERENCES `CONCEPTOSCARTERA` (`ConceptoCarID`),
  CONSTRAINT `SUBCTAFONDEADORCART_ibfk_2` FOREIGN KEY (`InstitutFondID`) REFERENCES `INSTITUTFONDEO` (`InstitutFondID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para la subcuenta del fondeador'$$