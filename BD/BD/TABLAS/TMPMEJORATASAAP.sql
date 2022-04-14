-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPMEJORATASAAP
DELIMITER ;
DROP TABLE IF EXISTS `TMPMEJORATASAAP`;DELIMITER $$

CREATE TABLE `TMPMEJORATASAAP` (
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Numero de transaccion.',
  `AportacionID` bigint(20) DEFAULT NULL COMMENT 'ID de la Aportación.',
  KEY `TMPMEJORATASAAP_IDX_1` (`AportacionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Recalculo del Interes en un Anclaje de APORTACIONES'$$