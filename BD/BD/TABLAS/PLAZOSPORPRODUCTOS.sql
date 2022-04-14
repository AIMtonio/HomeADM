-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLAZOSPORPRODUCTOS
DELIMITER ;
DROP TABLE IF EXISTS `PLAZOSPORPRODUCTOS`;DELIMITER $$

CREATE TABLE `PLAZOSPORPRODUCTOS` (
  `PlazoID` int(11) NOT NULL COMMENT 'PK  para identificar los plazos que el cliente determine.',
  `Plazo` int(11) NOT NULL COMMENT 'Indica el plazo',
  `TipoInstrumentoID` int(11) NOT NULL COMMENT 'FK hacia la tabla TIPOINSTRUMENTOS solo almacenara el 28 para CEDES',
  `TipoProductoID` int(11) NOT NULL COMMENT 'Indica el tipo de CEDES de la tabla TIPOSCEDES',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`PlazoID`),
  KEY `INDEX_PLAZOSPORPRODUCTOS_1` (`TipoProductoID`),
  KEY `FK_PLAZOSPORPRODUCTOS_1` (`TipoInstrumentoID`),
  CONSTRAINT `FK_PLAZOSPORPRODUCTOS_1` FOREIGN KEY (`TipoInstrumentoID`) REFERENCES `TIPOINSTRUMENTOS` (`TipoInstrumentoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena los plazos que se determinen por clientes para CEDES'$$