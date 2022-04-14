-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPFONDEOPRODCRE
DELIMITER ;
DROP TABLE IF EXISTS `TMPFONDEOPRODCRE`;DELIMITER $$

CREATE TABLE `TMPFONDEOPRODCRE` (
  `Var_ProdCre` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TABLA TEMPORAL PARA LA LINEA DE FONDEO PRODUCTOS DE CREDITO'$$