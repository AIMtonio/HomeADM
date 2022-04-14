-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPERROR
DELIMITER ;
DROP TABLE IF EXISTS `TMPERROR`;DELIMITER $$

CREATE TABLE `TMPERROR` (
  `Numero` int(11) NOT NULL,
  `Descripcion` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='tEMPORAL DE eRRORES'$$