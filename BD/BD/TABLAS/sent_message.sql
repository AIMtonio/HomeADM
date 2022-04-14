-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- sent_message
DELIMITER ;
DROP TABLE IF EXISTS `sent_message`;DELIMITER $$

CREATE TABLE `sent_message` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` char(2) NOT NULL,
  `receiver` varchar(45) NOT NULL,
  `sender` varchar(45) DEFAULT NULL,
  `sent` varchar(45) DEFAULT NULL,
  `message` varchar(160) DEFAULT NULL,
  `sent_messagecol` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$