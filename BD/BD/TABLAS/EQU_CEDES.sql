-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EQU_CEDES
DELIMITER ;
DROP TABLE IF EXISTS `EQU_CEDES`;
DELIMITER $$


CREATE TABLE `EQU_CEDES` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `CedeIDSAFI` int(11) NOT NULL COMMENT 'CEDE ID SAFI',
  `CedeIDCte` varchar(20) CHARACTER SET utf8 NOT NULL COMMENT 'CEDE ID SISTEMA ANTERIOR',
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Cedes'$$
