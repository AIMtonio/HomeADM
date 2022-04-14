-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTACLASIFCART
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTACLASIFCART`;DELIMITER $$

CREATE TABLE `SUBCTACLASIFCART` (
  `ConceptoCarID` int(11) NOT NULL,
  `Consumo` char(2) DEFAULT NULL,
  `Comercial` char(2) DEFAULT NULL,
  `Vivienda` char(2) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoCarID`),
  KEY `fk_SUBCUENTACLASIFCART_1` (`ConceptoCarID`),
  CONSTRAINT `fk_SUBCUENTACLASIFCART_1` FOREIGN KEY (`ConceptoCarID`) REFERENCES `CONCEPTOSCARTERA` (`ConceptoCarID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Subcuenta por clasificacion (consumo,comercial,vivienda)'$$