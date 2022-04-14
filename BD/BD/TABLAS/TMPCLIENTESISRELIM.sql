-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCLIENTESISRELIM
DELIMITER ;
DROP TABLE IF EXISTS `TMPCLIENTESISRELIM`;DELIMITER $$

CREATE TABLE `TMPCLIENTESISRELIM` (
  `FechaSistema` date NOT NULL,
  `ClienteID` int(11) NOT NULL,
  `TipoInstrumentoID` int(12) NOT NULL,
  `InstrumentoID` bigint(12) NOT NULL DEFAULT '0',
  PRIMARY KEY (`InstrumentoID`,`TipoInstrumentoID`,`ClienteID`,`FechaSistema`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para ayuda eliminacion de registrso CLIENTESISR'$$