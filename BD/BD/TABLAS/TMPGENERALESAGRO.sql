-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPGENERALESAGRO
DELIMITER ;
DROP TABLE IF EXISTS `TMPGENERALESAGRO`;DELIMITER $$

CREATE TABLE `TMPGENERALESAGRO` (
  `ConsecutivoID` int(11) DEFAULT NULL COMMENT 'Número consecutivo.',
  `RolID` int(11) DEFAULT '0' COMMENT 'ID del Rol.',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'ID del cliente.',
  `ProspectoID` int(11) DEFAULT NULL COMMENT 'ID del prospecto.',
  `NombreCompleto` varchar(500) DEFAULT NULL COMMENT 'Nombre completo.',
  `RFC` varchar(20) DEFAULT NULL COMMENT 'RFC',
  `IFE` varchar(20) DEFAULT '' COMMENT 'IFE',
  `DireccionCompleta` varchar(500) DEFAULT NULL COMMENT 'Dirección Completa.',
  `CreditoID` bigint(12) DEFAULT NULL COMMENT 'Número del crédito.',
  KEY `IDX_TMPGENERALESAGRO_1` (`CreditoID`),
  KEY `IDX_TMPGENERALESAGRO_2` (`ConsecutivoID`),
  KEY `IDX_TMPGENERALESAGRO_3` (`ClienteID`),
  KEY `IDX_TMPGENERALESAGRO_4` (`ProspectoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: Temporal para datos generales en contratos agro.'$$