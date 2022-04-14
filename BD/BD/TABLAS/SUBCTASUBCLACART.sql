-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTASUBCLACART
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTASUBCLACART`;DELIMITER $$

CREATE TABLE `SUBCTASUBCLACART` (
  `ConceptoCarID` int(11) NOT NULL,
  `ClasificacionID` int(11) NOT NULL,
  `SubCuenta` varchar(10) NOT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ClasificacionID`,`ConceptoCarID`),
  KEY `fk_SUBCTASUBCLACART_1` (`ClasificacionID`),
  KEY `fk_SUBCTASUBCLACART_2` (`ConceptoCarID`),
  CONSTRAINT `fk_SUBCTASUBCLACART_1` FOREIGN KEY (`ClasificacionID`) REFERENCES `CLASIFICCREDITO` (`ClasificacionID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_SUBCTASUBCLACART_2` FOREIGN KEY (`ConceptoCarID`) REFERENCES `CONCEPTOSCARTERA` (`ConceptoCarID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Subcuenta por SubClasificacion de Cartera)'$$