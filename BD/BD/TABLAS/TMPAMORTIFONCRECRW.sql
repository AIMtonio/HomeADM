-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPAMORTIFONCRECRW
DELIMITER ;
DROP TABLE IF EXISTS `TMPAMORTIFONCRECRW`;

DELIMITER $$
CREATE TABLE `TMPAMORTIFONCRECRW` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `Transaccion` bigint(20) NOT NULL COMMENT 'Numero de Tranasaccion',
  `AmortizacionID` int(4) NOT NULL COMMENT 'No Amortizacion',
  `SolFondeoID` bigint(20) NOT NULL COMMENT 'Numero de solicitud de Fondeo CRW',
  KEY `INDEX_TMPAMORTIFONCRECRW_1` (`Transaccion`,`SolFondeoID`,`AmortizacionID`),
  KEY `INDEX_TMPAMORTIFONCRECRW_2` (`Transaccion`),
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Temporal de Amortizaciones de los Fondeos CRW.'$$
