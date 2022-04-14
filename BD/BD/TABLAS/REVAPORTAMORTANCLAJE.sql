-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REVAPORTAMORTANCLAJE
DELIMITER ;
DROP TABLE IF EXISTS `REVAPORTAMORTANCLAJE`;DELIMITER $$

CREATE TABLE `REVAPORTAMORTANCLAJE` (
  `Fecha` datetime NOT NULL COMMENT 'Fecha del Anclaje con hr y minutos',
  `AportMejora` int(11) NOT NULL COMMENT 'Aportacion que hace la Mejora.',
  `AportMejorada` int(11) NOT NULL COMMENT 'Aportacion que se Mejora con el Anclaje.',
  `AmortizacionID` int(11) NOT NULL DEFAULT '0' COMMENT 'Id de la Amortizacion o Calendario',
  `Interes` decimal(18,2) DEFAULT NULL COMMENT 'Interes',
  `Total` decimal(18,2) DEFAULT NULL COMMENT 'Total Capital + Interes - ISR ',
  KEY `fk_REVAPORTAMORTANCLAJE_1_idx` (`AportMejora`),
  KEY `fk_REVAPORTAMORTANCLAJE_2_idx` (`AportMejorada`),
  CONSTRAINT `fk_REVAPORTAMORTANCLAJE_1` FOREIGN KEY (`AportMejora`) REFERENCES `APORTACIONES` (`AportacionID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_REVAPORTAMORTANCLAJE_2` FOREIGN KEY (`AportMejorada`) REFERENCES `APORTACIONES` (`AportacionID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Posible Reversa de las Cuotas en Anclaje de Aportaciones.'$$