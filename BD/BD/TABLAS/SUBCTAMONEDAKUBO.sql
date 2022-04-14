-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAMONEDAKUBO
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTAMONEDAKUBO`;DELIMITER $$

CREATE TABLE `SUBCTAMONEDAKUBO` (
  `ConceptoKuboID` int(11) NOT NULL,
  `MonedaID` int(11) NOT NULL,
  `Subcuenta` char(2) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoKuboID`,`MonedaID`),
  KEY `fk_new_table_1` (`ConceptoKuboID`),
  KEY `fk_new_table_2` (`MonedaID`),
  CONSTRAINT `fk_new_table_1` FOREIGN KEY (`ConceptoKuboID`) REFERENCES `CONCEPTOSKUBO` (`ConceptoKuboID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_new_table_2` FOREIGN KEY (`MonedaID`) REFERENCES `MONEDAS` (`MonedaId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Subcuenta por tipo moneda'$$