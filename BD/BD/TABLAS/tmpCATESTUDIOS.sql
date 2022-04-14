-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- tmpCATESTUDIOS
DELIMITER ;
DROP TABLE IF EXISTS `tmpCATESTUDIOS`;DELIMITER $$

CREATE TABLE `tmpCATESTUDIOS` (
  `IdNivel` int(11) DEFAULT NULL,
  `Nivel` varchar(100) DEFAULT NULL,
  `idNivelSAFI` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$