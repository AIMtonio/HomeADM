-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPGARANTESAGRO
DELIMITER ;
DROP TABLE IF EXISTS `TMPGARANTESAGRO`;DELIMITER $$

CREATE TABLE `TMPGARANTESAGRO` (
  `GarantiaID` int(11) DEFAULT NULL COMMENT 'ID de la garantía.',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'ID del cliente.',
  `ProspectoID` int(11) DEFAULT NULL COMMENT 'ID del prospecto.',
  `NombreCompleto` varchar(500) DEFAULT NULL COMMENT 'Nombre completo del cliente.',
  `RFC` varchar(20) DEFAULT NULL COMMENT 'RFC',
  `IFE` varchar(20) DEFAULT '' COMMENT 'IFE',
  `DireccionCompleta` varchar(500) DEFAULT NULL COMMENT 'Dirección Completa.',
  `Observaciones` varchar(1200) DEFAULT NULL COMMENT 'Observaciones de la garantia.',
  `TipoGarantiaID` int(11) DEFAULT NULL COMMENT 'Tipo de la garantía.',
  `CreditoID` bigint(12) DEFAULT NULL COMMENT 'Número del crédito.',
  KEY `IDX_TMPGARANTESAGRO_1` (`CreditoID`),
  KEY `IDX_TMPGARANTESAGRO_2` (`GarantiaID`),
  KEY `IDX_TMPGARANTESAGRO_3` (`ClienteID`),
  KEY `IDX_TMPGARANTESAGRO_4` (`TipoGarantiaID`),
  KEY `IDX_TMPGARANTESAGRO_5` (`ProspectoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: Temporal para datos de los garantes en contratos agro.'$$