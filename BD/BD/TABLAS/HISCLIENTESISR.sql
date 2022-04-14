-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISCLIENTESISR
DELIMITER ;
DROP TABLE IF EXISTS `HISCLIENTESISR`;DELIMITER $$

CREATE TABLE `HISCLIENTESISR` (
  `FechaSistema` date NOT NULL,
  `ClienteID` int(11) NOT NULL,
  `TipoInstrumentoID` int(12) NOT NULL,
  `InstrumentoID` bigint(12) NOT NULL DEFAULT '0',
  `SaldoDiario` decimal(12,2) NOT NULL DEFAULT '0.00',
  `SaldoAcumulado` decimal(12,2) NOT NULL DEFAULT '0.00',
  `Exedente` decimal(12,2) NOT NULL DEFAULT '0.00',
  `ISR_dia` decimal(12,2) NOT NULL DEFAULT '0.00',
  `MonedaID` int(11) DEFAULT NULL,
  `SucursalOrigen` int(5) DEFAULT NULL,
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
  KEY `INDEX_TipoInstru` (`TipoInstrumentoID`),
  CONSTRAINT `fk_ClienteID_15` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`),
  CONSTRAINT `fk_TipoInstrumentoID_2` FOREIGN KEY (`TipoInstrumentoID`) REFERENCES `TIPOINSTRUMENTOS` (`TipoInstrumentoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TABLA Historica de ISR calculado por socio		'$$