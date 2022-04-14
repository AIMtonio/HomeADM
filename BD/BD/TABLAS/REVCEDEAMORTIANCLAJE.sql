-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REVCEDEAMORTIANCLAJE
DELIMITER ;
DROP TABLE IF EXISTS `REVCEDEAMORTIANCLAJE`;DELIMITER $$

CREATE TABLE `REVCEDEAMORTIANCLAJE` (
  `Fecha` datetime NOT NULL COMMENT 'Fecha del Anclaje con hr y minutos',
  `CedeMejora` int(11) NOT NULL COMMENT 'Cede que hace la Mejora.',
  `CedeMejorada` int(11) NOT NULL COMMENT 'Cede que se Mejora con el Anclaje.',
  `AmortizacionID` int(11) NOT NULL DEFAULT '0' COMMENT 'Id de la Amortizacion o Calendario',
  `Interes` decimal(18,2) DEFAULT NULL COMMENT 'Interes',
  `Total` decimal(18,2) DEFAULT NULL COMMENT 'Total Capital + Interes - ISR ',
  KEY `fk_REVCEDEAMORTIANCLAJE_1_idx` (`CedeMejora`),
  KEY `fk_REVCEDEAMORTIANCLAJE_2_idx` (`CedeMejorada`),
  CONSTRAINT `fk_REVCEDEAMORTIANCLAJE_1` FOREIGN KEY (`CedeMejora`) REFERENCES `CEDES` (`CedeID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_REVCEDEAMORTIANCLAJE_2` FOREIGN KEY (`CedeMejorada`) REFERENCES `CEDES` (`CedeID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Para posible Reversa de las Cuotas en Anclaje de CEDES'$$