-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REVERSADESCRE
DELIMITER ;
DROP TABLE IF EXISTS `REVERSADESCRE`;DELIMITER $$

CREATE TABLE `REVERSADESCRE` (
  `Fecha` date DEFAULT NULL,
  `CreditoID` bigint(12) DEFAULT NULL,
  `Motivo` varchar(200) DEFAULT NULL,
  `UsuarioAut` int(11) DEFAULT NULL,
  `ClienteID` int(11) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  KEY `fk_REVERSADESCRE_2` (`UsuarioAut`),
  KEY `fk_REVERSADESCRE_3` (`ClienteID`),
  KEY `fk_REVERSADESCRE_1` (`CreditoID`),
  CONSTRAINT `fk_REVERSADESCRE_1` FOREIGN KEY (`CreditoID`) REFERENCES `CREDITOS` (`CreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='DESEMBOLSO DE CREDITOS'$$