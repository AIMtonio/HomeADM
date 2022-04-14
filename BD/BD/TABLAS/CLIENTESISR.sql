-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTESISR
DELIMITER ;
DROP TABLE IF EXISTS `CLIENTESISR`;DELIMITER $$

CREATE TABLE `CLIENTESISR` (
  `FechaSistema` date NOT NULL,
  `ClienteID` int(11) NOT NULL,
  `TipoInstrumentoID` int(12) NOT NULL,
  `InstrumentoID` bigint(12) NOT NULL DEFAULT '0',
  `SaldoDiario` decimal(12,2) NOT NULL DEFAULT '0.00',
  `SaldoAcumulado` decimal(12,2) NOT NULL DEFAULT '0.00',
  `Exedente` decimal(12,2) NOT NULL DEFAULT '0.00',
  `ISR_dia` decimal(12,2) NOT NULL DEFAULT '0.00',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`FechaSistema`,`ClienteID`,`TipoInstrumentoID`,`InstrumentoID`),
  KEY `INDEX_ClienteID` (`ClienteID`),
  KEY `INDEX_FechaSis` (`FechaSistema`),
  KEY `INDEX_TipoInstrU` (`TipoInstrumentoID`),
  CONSTRAINT `fk_ClienteID_14` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`),
  CONSTRAINT `fk_TipoInstrumentoID_1` FOREIGN KEY (`TipoInstrumentoID`) REFERENCES `TIPOINSTRUMENTOS` (`TipoInstrumentoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla guarda ISR calculado por socio  dia a dia'$$