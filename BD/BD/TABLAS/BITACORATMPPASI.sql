-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORATMPPASI
DELIMITER ;
DROP TABLE IF EXISTS `BITACORATMPPASI`;DELIMITER $$

CREATE TABLE `BITACORATMPPASI` (
  `Tmp_Consecutivo` int(11) DEFAULT NULL,
  `Tmp_FecFin` date DEFAULT NULL,
  `Tmp_FecVig` date DEFAULT NULL,
  `Tmp_CuotasCap` int(11) DEFAULT NULL,
  `NumError` int(11) DEFAULT NULL,
  `ErrorMen` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$