-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPPRINCIPALESCRED
DELIMITER ;
DROP TABLE IF EXISTS `TMPPRINCIPALESCRED`;DELIMITER $$

CREATE TABLE `TMPPRINCIPALESCRED` (
  `ClientePrin` int(11) DEFAULT NULL COMMENT 'Numero de Cliente\n',
  `SaldoCreditoPrin` decimal(46,4) DEFAULT NULL,
  KEY `IDX_TMPPRINCIPALESCRED_1` (`ClientePrin`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$