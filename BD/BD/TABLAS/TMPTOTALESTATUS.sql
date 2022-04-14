-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPTOTALESTATUS
DELIMITER ;
DROP TABLE IF EXISTS `TMPTOTALESTATUS`;DELIMITER $$

CREATE TABLE `TMPTOTALESTATUS` (
  `TipoEstatus` char(2) DEFAULT NULL,
  `TotalEstatus` int(11) DEFAULT NULL,
  `Orden` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$