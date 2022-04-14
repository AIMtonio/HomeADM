-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INVFONDEKUBOTEMP
DELIMITER ;
DROP TABLE IF EXISTS `INVFONDEKUBOTEMP`;DELIMITER $$

CREATE TABLE `INVFONDEKUBOTEMP` (
  `FondeoKuboID` bigint(20) DEFAULT NULL,
  `MoratorioPagado` decimal(14,4) DEFAULT NULL,
  `ComFalPagPagada` decimal(14,4) DEFAULT NULL,
  `ProvisionAcum` decimal(14,4) DEFAULT NULL,
  `InteresFondCob` decimal(14,4) DEFAULT NULL,
  `CapitalPagado` decimal(14,4) DEFAULT NULL,
  KEY `INDEX_IntCob` (`InteresFondCob`) USING BTREE,
  KEY `INDEX_CapFon` (`CapitalPagado`) USING BTREE,
  KEY `INDEX_MoratP` (`MoratorioPagado`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla Temporal de Inversiones de Fondeadores'$$