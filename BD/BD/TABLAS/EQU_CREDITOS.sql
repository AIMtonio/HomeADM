-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EQU_CREDITOS
DELIMITER ;
DROP TABLE IF EXISTS `EQU_CREDITOS`;DELIMITER $$

CREATE TABLE `EQU_CREDITOS` (
  `CreditoIDSAFI` bigint(12) NOT NULL COMMENT 'ID o Número de Crédito, SAFI',
  `CreditoIDCte` varchar(20) NOT NULL COMMENT 'ID o Número de Crédito, sistema del cliente',
  `CreCirculoID` varchar(20) DEFAULT NULL COMMENT 'ID de la Numero de Credito como se Estaba Reportando a Circulo de Credito',
  `FechaIncumplimiento` date DEFAULT NULL COMMENT 'Fecha de Incumplimiento del credito',
  PRIMARY KEY (`CreditoIDSAFI`,`CreditoIDCte`),
  KEY `Idx_EQU_CREDITOS_CreditoCte` (`CreditoIDCte`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$