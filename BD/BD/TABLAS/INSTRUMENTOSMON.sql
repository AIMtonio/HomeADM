-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INSTRUMENTOSMON
DELIMITER ;
DROP TABLE IF EXISTS `INSTRUMENTOSMON`;DELIMITER $$

CREATE TABLE `INSTRUMENTOSMON` (
  `InstrumentMonID` int(11) NOT NULL COMMENT 'clave de instrumento monetario 1',
  `Descripcion` varchar(100) DEFAULT NULL COMMENT 'monedas y billetes, cheques viajero, monedas oro, monedas platino, monedas plata,\n cheque bancario , pagare, etc',
  `TipoInstrumento` int(11) DEFAULT NULL COMMENT 'Tipo de instrumento monetario\nsegún catalogo de tipos de instrumentos monetarios (categorias)',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'No. Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(11) DEFAULT NULL,
  PRIMARY KEY (`InstrumentMonID`),
  KEY `fk_INSTRUMENTOSMON_1` (`TipoInstrumento`),
  CONSTRAINT `fk_INSTRUMENTOSMON_1` FOREIGN KEY (`TipoInstrumento`) REFERENCES `TIPOINSTRUMMONE` (`TipoInstruMonID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de instrumentos monetarios'$$