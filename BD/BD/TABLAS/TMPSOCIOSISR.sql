-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPSOCIOSISR
DELIMITER ;
DROP TABLE IF EXISTS `TMPSOCIOSISR`;DELIMITER $$

CREATE TABLE `TMPSOCIOSISR` (
  `Instrumento` bigint(12) NOT NULL DEFAULT '0',
  `TipoInstrumentoID` int(11) NOT NULL,
  `ClienteID` int(11) NOT NULL,
  `Saldo` decimal(12,2) DEFAULT '0.00',
  `Saldo_total` decimal(12,2) DEFAULT '0.00',
  `TasaISR` decimal(12,2) DEFAULT '0.00',
  `ISR_total` decimal(12,2) DEFAULT '0.00',
  `ISR_dia` decimal(12,2) DEFAULT '0.00',
  PRIMARY KEY (`Instrumento`,`TipoInstrumentoID`,`ClienteID`),
  KEY `INDEX_tipoInstru` (`TipoInstrumentoID`),
  KEY `INDEX_ClienteID` (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de paso para el calculo de ISR'$$