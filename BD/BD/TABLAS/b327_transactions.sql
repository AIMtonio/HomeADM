-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- b327_transactions
DELIMITER ;
DROP TABLE IF EXISTS `b327_transactions`;
DELIMITER $$

CREATE TABLE `b327_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fld0` timestamp(3) NULL DEFAULT NULL,
  `fld1` varchar(20) DEFAULT NULL,
  `fld2` varchar(6) DEFAULT NULL,
  `fld3` varchar(4) DEFAULT NULL,
  `fld4` varchar(4) DEFAULT NULL,
  `fld5` varchar(6) DEFAULT NULL,
  `fld6` varchar(3) DEFAULT NULL,
  `fld7` varchar(2) DEFAULT NULL,
  `fld8` varchar(2) DEFAULT NULL,
  `fld9` varchar(2) DEFAULT NULL,
  `fld10` varchar(19) DEFAULT NULL,
  `fld11` varchar(2) DEFAULT NULL,
  `fld12` varchar(13) DEFAULT NULL,
  `fld13` varchar(4) DEFAULT NULL,
  `fld14` varchar(19) DEFAULT NULL,
  `fld15` varchar(12) DEFAULT NULL,
  `fld16` varchar(16) DEFAULT NULL,
  `fld17` varchar(22) DEFAULT NULL,
  `fld18` varchar(2) DEFAULT NULL,
  `fld19` varchar(4) DEFAULT NULL,
  `fld20` varchar(2) DEFAULT NULL,
  `fld21` varchar(6) DEFAULT NULL,
  `fld22` varchar(130) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx0` (`fld0`),
  KEY `idx1` (`fld0`,`fld20`),
  KEY `idx2` (`fld0`,`fld2`),
  KEY `idx3` (`fld7`),
  KEY `idx4` (`fld6`,`fld7`),
  KEY `idx5` (`fld10`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=latin1$$