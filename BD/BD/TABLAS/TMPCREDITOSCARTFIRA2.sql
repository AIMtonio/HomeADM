-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCREDITOSCARTFIRA2
DELIMITER ;
DROP TABLE IF EXISTS `TMPCREDITOSCARTFIRA2`;DELIMITER $$

CREATE TABLE `TMPCREDITOSCARTFIRA2` (
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Numero de Cliente ID en el SAFI (Campo Extra no va en el reporte)',
  `Diasatraso` bigint(11) DEFAULT NULL,
  KEY `IDX_TMPCREDITOSCARTFIRA2_1` (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$