-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCRWPREPAGOAMOR
DELIMITER ;
DROP TABLE IF EXISTS `TMPCRWPREPAGOAMOR`;
DELIMITER $$

CREATE TABLE `TMPCRWPREPAGOAMOR` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `Transaccion` bigint(20) NOT NULL COMMENT 'Numero de Tranasaccion',
  `SolFondeoID` bigint(20) NOT NULL COMMENT 'Credito',
  KEY `INDEX_TMPCRWPREPAGOAMOR_1` (`Transaccion`,`SolFondeoID`),
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla Temporal de Amortizaciones de las inversiones Pagadas'$$
