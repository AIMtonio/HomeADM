-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCTASBLOQUEADAS
DELIMITER ;
DROP TABLE IF EXISTS `TMPCTASBLOQUEADAS`;
DELIMITER $$

CREATE TABLE `TMPCTASBLOQUEADAS` (
  `ClienteID` int(11) DEFAULT NULL,
  `InversionID` int(11) NOT NULL,
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  PRIMARY KEY (`InversionID`),
  KEY `INDEX_TMPCTASBLOQUEADAS_1` (`CuentaAhoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: Temporal para validar las Cuentas Bloquedas que tienen una Inversion Vig.'$$
