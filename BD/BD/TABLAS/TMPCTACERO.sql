-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCTACERO
DELIMITER ;
DROP TABLE IF EXISTS `TMPCTACERO`;DELIMITER $$

CREATE TABLE `TMPCTACERO` (
  `PolizaID` bigint(20) NOT NULL COMMENT 'Numero de la \nPoliza'
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$