-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CICLOBASECLIPRO
DELIMITER ;
DROP TABLE IF EXISTS `CICLOBASECLIPRO`;DELIMITER $$

CREATE TABLE `CICLOBASECLIPRO` (
  `ClienteID` int(11) NOT NULL COMMENT 'ID del Cliente',
  `ProspectoID` int(11) NOT NULL COMMENT 'ID del Prospecto',
  `ProductoCreditoID` int(11) NOT NULL COMMENT 'ID del Producto de Credito',
  `CicloBase` int(11) DEFAULT NULL COMMENT 'Ciclo Inicial o Numero de Creditos del Cliente',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ClienteID`,`ProspectoID`,`ProductoCreditoID`),
  KEY `fk_CICLOBASECLIPRO_1` (`ProductoCreditoID`),
  KEY `fk_CICLOBASECLIPRO_2` (`ClienteID`),
  KEY `fk_CICLOBASECLIPRO_3` (`ProspectoID`),
  CONSTRAINT `fk_CICLOBASECLIPRO_1` FOREIGN KEY (`ProductoCreditoID`) REFERENCES `PRODUCTOSCREDITO` (`ProducCreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Ciclo Inicial o Numero de Creditos, por Cliente y Producto d'$$