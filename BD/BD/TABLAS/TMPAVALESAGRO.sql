-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPAVALESAGRO
DELIMITER ;
DROP TABLE IF EXISTS `TMPAVALESAGRO`;DELIMITER $$

CREATE TABLE `TMPAVALESAGRO` (
  `AvalID` int(11) DEFAULT NULL COMMENT 'ID del aval.',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'ID del cliente.',
  `ProspectoID` int(11) DEFAULT NULL COMMENT 'ID del prospecto.',
  `NombreCompleto` varchar(500) DEFAULT NULL COMMENT 'Nombre completo del cliente.',
  `RFC` varchar(20) DEFAULT NULL COMMENT 'RFC',
  `IFE` varchar(20) DEFAULT '' COMMENT 'IFE',
  `DireccionCompleta` varchar(500) DEFAULT NULL COMMENT 'Dirección Completa.',
  `CreditoID` bigint(12) DEFAULT NULL COMMENT 'Número del crédito.',
  KEY `IDX_TMPAVALESAGRO_1` (`CreditoID`),
  KEY `IDX_TMPAVALESAGRO_2` (`AvalID`),
  KEY `IDX_TMPAVALESAGRO_3` (`ClienteID`),
  KEY `IDX_TMPAVALESAGRO_4` (`ProspectoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: Temporal para datos de los avales en contratos agro.'$$