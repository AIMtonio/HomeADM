-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTASUCURARRENDA
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTASUCURARRENDA`;DELIMITER $$

CREATE TABLE `SUBCTASUCURARRENDA` (
  `ConceptoArrendaID` int(5) NOT NULL COMMENT 'Identificador de la cuenta mayor, debe corresponder a un concepto de arrendamiento',
  `SucursalID` int(11) NOT NULL COMMENT 'ID de la sucursal ',
  `SubCuenta` char(6) DEFAULT NULL COMMENT 'Numeros que corresponde a la subcuenta',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa ID',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoArrendaID`,`SucursalID`),
  KEY `FK_ SUBCTASUCURARRENDA_1_idx` (`SucursalID`),
  CONSTRAINT `FK_ SUBCTASUCURARRENDA_1` FOREIGN KEY (`SucursalID`) REFERENCES `SUCURSALES` (`SucursalID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Subcuenta de Sucursales el Modulo de arrendamiento '$$