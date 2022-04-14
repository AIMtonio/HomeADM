-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPMEJORATASA
DELIMITER ;
DROP TABLE IF EXISTS `TMPMEJORATASA`;DELIMITER $$

CREATE TABLE `TMPMEJORATASA` (
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Numero de transaccion',
  `CedeID` bigint(20) DEFAULT NULL COMMENT 'ID del cede',
  KEY `TMPMEJORATASA_IDX_1` (`CedeID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Temporal para Recalculo del Interes en un Anclaje de CEDES'$$