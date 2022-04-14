-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTASUBCLASIFCART
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTASUBCLASIFCART`;DELIMITER $$

CREATE TABLE `SUBCTASUBCLASIFCART` (
  `ConceptoCarID` int(11) NOT NULL,
  `ProductoCartID` int(11) NOT NULL,
  `SubCuenta` char(2) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoCarID`,`ProductoCartID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$