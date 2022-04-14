-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAPRODUCCART
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTAPRODUCCART`;DELIMITER $$

CREATE TABLE `SUBCTAPRODUCCART` (
  `ConceptoCarID` int(11) NOT NULL,
  `ProducCreditoID` int(11) NOT NULL,
  `SubCuenta` varchar(10) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoCarID`,`ProducCreditoID`),
  KEY `fk_SUBCTAPRODUCCART_1` (`ConceptoCarID`),
  KEY `fk_SUBCTAPRODUCCART_2` (`ProducCreditoID`),
  CONSTRAINT `fk_SUBCTAPRODUCCART_1` FOREIGN KEY (`ConceptoCarID`) REFERENCES `CONCEPTOSCARTERA` (`ConceptoCarID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_SUBCTAPRODUCCART_2` FOREIGN KEY (`ProducCreditoID`) REFERENCES `PRODUCTOSCREDITO` (`ProducCreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Subcuenta por producto'$$