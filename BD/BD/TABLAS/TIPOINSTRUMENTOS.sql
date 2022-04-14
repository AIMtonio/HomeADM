-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOINSTRUMENTOS
DELIMITER ;
DROP TABLE IF EXISTS `TIPOINSTRUMENTOS`;DELIMITER $$

CREATE TABLE `TIPOINSTRUMENTOS` (
  `TipoInstrumentoID` int(11) NOT NULL COMMENT 'Número consecutivo, para llevar el control de tipo de instrumentos. PK',
  `Descripcion` varchar(60) DEFAULT NULL COMMENT 'Descripción del tipo de instrumentos.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parámetro de auditoría.',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parámetro de auditoría.',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parámetro de auditoría.',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parámetro de auditoría.',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parámetro de auditoría.',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parámetro de auditoría.',
  `NumTransaccion` bigint(11) DEFAULT NULL COMMENT 'Parámetro de auditoría.',
  PRIMARY KEY (`TipoInstrumentoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Contiene los tipos de instrumentos(descripción que origina u'$$