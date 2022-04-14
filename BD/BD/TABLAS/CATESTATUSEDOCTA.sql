-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATESTATUSEDOCTA
DELIMITER ;
DROP TABLE IF EXISTS `CATESTATUSEDOCTA`;DELIMITER $$

CREATE TABLE `CATESTATUSEDOCTA` (
  `idEstatus` int(11) NOT NULL,
  `Descripcion` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idEstatus`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$