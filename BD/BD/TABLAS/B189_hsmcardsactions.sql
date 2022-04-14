-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- B189_hsmcardsactions
DELIMITER ;
DROP TABLE IF EXISTS `B189_hsmcardsactions`;
DELIMITER $$

CREATE TABLE `B189_hsmcardsactions` (
  `ID_HSMCARD189` int(11) NOT NULL AUTO_INCREMENT,
  `invoice` int(11) NOT NULL,
  `cardno` varchar(16) NOT NULL,
  `oldpinoffset` varchar(12) NOT NULL,
  `newpinoffset` varchar(12) NOT NULL,
  `creationdate` datetime DEFAULT NULL,
  `status` char(1) NOT NULL,
  `type` char(1) DEFAULT NULL,
    PRIMARY KEY (`ID_HSMCARD189`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$