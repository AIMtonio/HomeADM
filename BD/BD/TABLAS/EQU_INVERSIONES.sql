-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EQU_INVERSIONES
DELIMITER ;
DROP TABLE IF EXISTS `EQU_INVERSIONES`;
DELIMITER $$


CREATE TABLE `EQU_INVERSIONES` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `InversionIDSAFI` int(11) DEFAULT NULL,
  `InversionIDCte` varchar(20) DEFAULT NULL,
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$
