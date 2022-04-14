-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMP_CART9
DELIMITER ;
DROP TABLE IF EXISTS `TMP_CART9`;DELIMITER $$

CREATE TABLE `TMP_CART9` (
  `ClaveConcepto` varchar(45) DEFAULT NULL,
  `Descripcion` varchar(400) DEFAULT NULL,
  `Monto` decimal(16,2) DEFAULT NULL,
  `OrdenExcell` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$