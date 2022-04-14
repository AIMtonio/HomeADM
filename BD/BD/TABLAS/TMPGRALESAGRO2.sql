-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPGRALESAGRO2
DELIMITER ;
DROP TABLE IF EXISTS `TMPGRALESAGRO2`;DELIMITER $$

CREATE TABLE `TMPGRALESAGRO2` (
  `ConsecutivoID` int(11) DEFAULT NULL COMMENT 'Número consecutivo.',
  `RolID` int(11) DEFAULT NULL COMMENT 'ID del Rol.',
  `NombreCompleto` varchar(500) DEFAULT NULL COMMENT 'Nombre completo.',
  `RFC` varchar(20) DEFAULT NULL COMMENT 'RFC',
  `IFE` varchar(20) DEFAULT '' COMMENT 'IFE',
  `DireccionCompleta` varchar(500) DEFAULT NULL COMMENT 'Dirección Completa.',
  `CreditoID` bigint(12) DEFAULT NULL COMMENT 'Número del crédito.',
  KEY `IDX_TMPGRALESAGRO2_1` (`CreditoID`),
  KEY `IDX_TMPGRALESAGRO2_2` (`ConsecutivoID`),
  KEY `IDX_TMPGRALESAGRO2_3` (`NombreCompleto`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: Temporal para datos generales en contratos agro.'$$