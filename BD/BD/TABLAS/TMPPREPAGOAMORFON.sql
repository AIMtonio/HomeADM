-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPPREPAGOAMORFON
DELIMITER ;
DROP TABLE IF EXISTS `TMPPREPAGOAMORFON`;DELIMITER $$

CREATE TABLE `TMPPREPAGOAMORFON` (
  `Transaccion` bigint(20) NOT NULL COMMENT 'Numero de Tranasaccion',
  `FondeoKuboID` int(11) NOT NULL COMMENT 'Credito',
  KEY `TMPAMORTICRE_1` (`Transaccion`,`FondeoKuboID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla Temporal de Amortizaciones de las inversiones Pagadas'$$