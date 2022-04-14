-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICIDOCREQ_Par
DELIMITER ;
DROP TABLE IF EXISTS `SOLICIDOCREQ_Par`;DELIMITER $$

CREATE TABLE `SOLICIDOCREQ_Par` (
  `NumID` int(11) NOT NULL AUTO_INCREMENT,
  `Producto` int(11) DEFAULT NULL,
  `Clasif` int(11) DEFAULT NULL,
  PRIMARY KEY (`NumID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$