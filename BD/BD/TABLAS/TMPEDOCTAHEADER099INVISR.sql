-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPEDOCTAHEADER099INVISR
DELIMITER ;
DROP TABLE IF EXISTS `TMPEDOCTAHEADER099INVISR`;DELIMITER $$

CREATE TABLE `TMPEDOCTAHEADER099INVISR` (
  `ClienteID` int(11) DEFAULT NULL,
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `ISRretenido` decimal(14,2) DEFAULT NULL,
  `InversionID` int(11) DEFAULT NULL,
  KEY `IDX_TMPEDOCTAHEADER099INVISR_CLIENTE` (`ClienteID`) USING BTREE,
  KEY `IDX_TMPEDOCTAHEADER099INVISR_CUENTAAHO` (`CuentaAhoID`) USING BTREE,
  KEY `IDX_TMPEDOCTAHEADER099INVISR_INVERSION` (`InversionID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$